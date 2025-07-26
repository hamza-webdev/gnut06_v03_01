#!/bin/bash

# Script pour synchroniser les ports entre Nginx VPS et Docker
# Usage: ./sync-nginx-ports.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"

echo "🔧 Synchronisation des ports Nginx VPS et Docker"
echo "📍 VPS: $VPS_USER@$VPS_IP"
echo ""

# Fonction SSH
run_ssh() {
    if command -v sshpass &> /dev/null; then
        sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
    else
        echo "🔐 Exécution sur le VPS: $1"
        ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
    fi
}

echo "🔗 Connexion au VPS..."
run_ssh "echo 'Connexion réussie'"

echo ""
echo "🔍 DIAGNOSTIC ACTUEL"
echo "==================="

echo ""
echo "1️⃣ Configuration Nginx VPS actuelle:"
run_ssh "grep 'proxy_pass' /etc/nginx/sites-available/gnut06.zidani.org.conf" || echo "Configuration non trouvée"

echo ""
echo "2️⃣ Configuration Docker actuelle:"
run_ssh "grep -A 2 -B 2 'ports:' $VPS_DIR/docker-compose.yml" || echo "docker-compose.yml non trouvé"

echo ""
echo "3️⃣ Ports actuellement ouverts:"
run_ssh "netstat -tuln | grep -E ':(8080|3002)'" || echo "Aucun des ports 8080/3002 ouvert"

echo ""
echo "4️⃣ Status du container:"
run_ssh "docker ps | grep gnut06" || echo "Container gnut06 non trouvé"

echo ""
echo "🔧 SOLUTION: Utiliser le port 8080 partout"
echo "==========================================="
echo ""
echo "Votre Nginx VPS est configuré pour le port 8080."
echo "Je vais configurer Docker pour utiliser aussi le port 8080."

echo ""
echo "📄 Mise à jour du docker-compose.yml pour le port 8080:"
run_ssh "cat > $VPS_DIR/docker-compose.yml << 'EOF'
version: '3.8'

services:
  gnut06-app:
    build: .
    container_name: gnut06-app
    restart: unless-stopped
    ports:
      - \"8080:80\"  # Port 8080 pour correspondre à Nginx VPS
    networks:
      - gnut06-network
    environment:
      - NODE_ENV=production

networks:
  gnut06-network:
    driver: bridge
EOF"

echo "✅ docker-compose.yml mis à jour (port 8080)"

echo ""
echo "📄 Vérification/création du Dockerfile optimisé:"
run_ssh "cat > $VPS_DIR/Dockerfile << 'EOF'
# Étape de build
FROM node:20-alpine as build-stage
WORKDIR /app

# Installation des outils de build
RUN apk add --no-cache python3 make g++

# Copie des fichiers de dépendances
COPY package*.json ./

# Nettoyage et installation
RUN rm -rf node_modules package-lock.json || true
RUN npm cache clean --force
RUN npm install

# Copie du code source
COPY . .

# Build de l'application
RUN npm run build

# Étape de production avec Nginx
FROM nginx:alpine as production-stage

# Copie du build
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Configuration Nginx pour SPA et assets CSS
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposition du port
EXPOSE 80

# Démarrage de Nginx
CMD [\"nginx\", \"-g\", \"daemon off;\"]
EOF"

echo "✅ Dockerfile vérifié"

echo ""
echo "📄 Configuration Nginx pour le container (optimisée pour Tailwind):"
run_ssh "cat > $VPS_DIR/nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Configuration pour SPA
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Optimisation pour les assets CSS/JS (Tailwind)
    location ~* \.(css|js)\$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
        add_header Access-Control-Allow-Origin \"*\";
        
        # Headers spécifiques pour CSS
        add_header Content-Type \"text/css\" always;
    }

    # Cache pour les autres assets
    location ~* \.(png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }

    # Headers de sécurité
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    add_header X-Content-Type-Options \"nosniff\" always;

    # Compression gzip optimisée pour Tailwind
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json
        text/html;

    # Logs pour debug
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
EOF"

echo "✅ Configuration Nginx container créée"

echo ""
echo "📦 Build local et copie:"
echo "Nettoyage du build précédent..."
rm -rf dist/

echo "Build de l'application..."
if npm run build; then
    echo "✅ Build local réussi"
    
    echo "Vérification des fichiers CSS:"
    find dist/ -name "*.css" -exec ls -la {} \; || echo "Aucun fichier CSS trouvé"
    
    echo "Taille du build: $(du -sh dist | cut -f1)"
else
    echo "❌ Build local échoué"
    exit 1
fi

echo ""
echo "📤 Copie du build vers le VPS:"
run_ssh "rm -rf $VPS_DIR/dist"

tar -czf dist.tar.gz dist/
if command -v sshpass &> /dev/null; then
    sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no dist.tar.gz "$VPS_USER@$VPS_IP:$VPS_DIR/"
else
    echo "📤 Copie: dist.tar.gz -> $VPS_DIR/"
    scp -o StrictHostKeyChecking=no dist.tar.gz "$VPS_USER@$VPS_IP:$VPS_DIR/"
fi

run_ssh "cd $VPS_DIR && tar -xzf dist.tar.gz && rm dist.tar.gz"
rm dist.tar.gz

echo "✅ Build copié"

echo ""
echo "🐳 Redémarrage Docker:"
run_ssh "cd $VPS_DIR && docker compose down --remove-orphans"
run_ssh "docker system prune -f"

echo "Construction du nouveau container..."
run_ssh "cd $VPS_DIR && docker compose up -d --build"

echo ""
echo "⏳ Attente du démarrage (30 secondes)..."
sleep 30

echo ""
echo "🔍 VÉRIFICATIONS FINALES"
echo "========================"

echo ""
echo "1️⃣ Status du container:"
run_ssh "docker compose -f $VPS_DIR/docker-compose.yml ps"

echo ""
echo "2️⃣ Port 8080 ouvert:"
run_ssh "netstat -tuln | grep :8080" || echo "Port 8080 non ouvert"

echo ""
echo "3️⃣ Test du container:"
run_ssh "curl -I http://localhost:8080 2>/dev/null | head -3" || echo "Container non accessible"

echo ""
echo "4️⃣ Test des fichiers CSS dans le container:"
run_ssh "docker exec gnut06-app find /usr/share/nginx/html -name '*.css' -exec ls -la {} \;" || echo "Aucun CSS dans le container"

echo ""
echo "5️⃣ Test du site public:"
curl -I https://gnut06.zidani.org 2>/dev/null | head -3 || echo "Site non accessible"

echo ""
echo "6️⃣ Vérification des liens CSS sur le site:"
curl -s https://gnut06.zidani.org 2>/dev/null | grep -o 'href=\"[^\"]*\.css[^\"]*\"' | head -3 || echo "Aucun lien CSS trouvé"

echo ""
echo "✅ Synchronisation terminée!"
echo ""
echo "🎯 Configuration finale:"
echo "   - Nginx VPS: proxy vers localhost:8080"
echo "   - Docker container: écoute sur le port 8080"
echo "   - Configuration Nginx optimisée pour Tailwind CSS"
echo ""
echo "🌍 Testez maintenant: https://gnut06.zidani.org"
echo ""
echo "🔍 Si le CSS ne s'affiche toujours pas:"
echo "   1. Vérifiez la console du navigateur (F12)"
echo "   2. Regardez les logs: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose logs'"
echo "   3. Vérifiez les logs Nginx VPS: ssh $VPS_USER@$VPS_IP 'sudo tail -f /var/log/nginx/error.log'"
