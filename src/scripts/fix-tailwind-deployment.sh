#!/bin/bash

# Script pour corriger le problème Tailwind CSS et la configuration Docker
# Usage: ./fix-tailwind-deployment.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"

echo "🎨 Correction du problème Tailwind CSS et configuration Docker"
echo "📍 VPS: $VPS_USER@$VPS_IP:$VPS_DIR"
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
echo "🔧 ÉTAPE 1: Correction du Dockerfile"
run_ssh "cat > $VPS_DIR/Dockerfile << 'EOF'
# Étape de build
FROM node:20-alpine as build-stage
WORKDIR /app

# Installation des outils de build pour les dépendances natives
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

# Configuration Nginx personnalisée pour SPA et Tailwind
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposition du port
EXPOSE 80

# Démarrage de Nginx
CMD [\"nginx\", \"-g\", \"daemon off;\"]
EOF"

echo "✅ Dockerfile corrigé"

echo ""
echo "🔧 ÉTAPE 2: Création de la configuration Nginx pour le container"
run_ssh "cat > $VPS_DIR/nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Configuration pour SPA (Single Page Application)
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache pour les assets CSS/JS (important pour Tailwind)
    location ~* \.(css|js)\$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
        add_header Access-Control-Allow-Origin \"*\";
    }

    # Cache pour les autres assets statiques
    location ~* \.(png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }

    # Headers de sécurité
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    add_header X-Content-Type-Options \"nosniff\" always;

    # Compression gzip (important pour Tailwind CSS)
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
        application/json;

    # Headers CORS pour les assets
    location ~* \.(css|js|woff|woff2|ttf|eot|svg)\$ {
        add_header Access-Control-Allow-Origin \"*\";
        add_header Access-Control-Allow-Methods \"GET, POST, OPTIONS\";
        add_header Access-Control-Allow-Headers \"DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range\";
    }
}
EOF"

echo "✅ Configuration Nginx créée"

echo ""
echo "🔧 ÉTAPE 3: Correction du docker-compose.yml (port 3002)"
run_ssh "cat > $VPS_DIR/docker-compose.yml << 'EOF'
version: '3.8'

services:
  gnut06-app:
    build: .
    container_name: gnut06-app
    restart: unless-stopped
    ports:
      - \"3002:80\"  # Port correct pour Nginx VPS
    networks:
      - gnut06-network
    environment:
      - NODE_ENV=production

networks:
  gnut06-network:
    driver: bridge
EOF"

echo "✅ docker-compose.yml corrigé (port 3002)"

echo ""
echo "🔧 ÉTAPE 4: Vérification de la configuration Tailwind locale"
echo "Vérification de tailwind.config.ts..."
if [ -f "./tailwind.config.ts" ]; then
    echo "✅ tailwind.config.ts trouvé localement"
    echo "Contenu:"
    cat ./tailwind.config.ts
else
    echo "❌ tailwind.config.ts non trouvé"
fi

echo ""
echo "🔧 ÉTAPE 5: Build local avec Tailwind"
echo "Nettoyage du build précédent..."
rm -rf dist/

echo "Build de l'application avec Tailwind..."
if npm run build; then
    echo "✅ Build local réussi"
    
    # Vérifier que les fichiers CSS sont présents
    echo "Vérification des fichiers CSS dans le build:"
    find dist/ -name "*.css" -exec ls -la {} \; || echo "Aucun fichier CSS trouvé"
    
    echo "Taille du build:"
    du -sh dist/
else
    echo "❌ Build local échoué"
    exit 1
fi

echo ""
echo "🔧 ÉTAPE 6: Copie du build vers le VPS"
echo "Suppression de l'ancien build..."
run_ssh "rm -rf $VPS_DIR/dist"

echo "Création d'une archive..."
tar -czf dist.tar.gz dist/

echo "Copie de l'archive..."
if command -v sshpass &> /dev/null; then
    sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no dist.tar.gz "$VPS_USER@$VPS_IP:$VPS_DIR/"
else
    echo "📤 Copie: dist.tar.gz -> $VPS_DIR/"
    scp -o StrictHostKeyChecking=no dist.tar.gz "$VPS_USER@$VPS_IP:$VPS_DIR/"
fi

echo "Extraction sur le VPS..."
run_ssh "cd $VPS_DIR && tar -xzf dist.tar.gz && rm dist.tar.gz"
rm dist.tar.gz

echo "✅ Build copié"

echo ""
echo "🔧 ÉTAPE 7: Vérification des fichiers CSS sur le VPS"
run_ssh "find $VPS_DIR/dist -name '*.css' -exec ls -la {} \;" || echo "Aucun fichier CSS trouvé sur le VPS"

echo ""
echo "🐳 ÉTAPE 8: Redémarrage Docker avec la nouvelle configuration"
run_ssh "cd $VPS_DIR && docker compose down --remove-orphans"
run_ssh "docker system prune -f"

echo "Construction du nouveau container..."
run_ssh "cd $VPS_DIR && docker compose up -d --build"

echo ""
echo "⏳ Attente du démarrage..."
sleep 20

echo ""
echo "🔍 ÉTAPE 9: Vérification du container"
run_ssh "docker compose -f $VPS_DIR/docker-compose.yml ps"

echo ""
echo "🌐 ÉTAPE 10: Tests"
echo "Test du container sur le port 3002:"
run_ssh "curl -I http://localhost:3002 | head -3"

echo ""
echo "Test de récupération d'un fichier CSS:"
run_ssh "curl -s http://localhost:3002/ | grep -o 'href=\"[^\"]*\.css[^\"]*\"' | head -3" || echo "Aucun lien CSS trouvé"

echo ""
echo "✅ Correction terminée!"
echo ""
echo "🎨 Changements apportés:"
echo "   ✅ Dockerfile corrigé avec configuration Nginx"
echo "   ✅ Port changé de 8080 à 3002 (correspond à Nginx VPS)"
echo "   ✅ Configuration Nginx optimisée pour Tailwind CSS"
echo "   ✅ Build local avec Tailwind copié"
echo "   ✅ Headers CORS et compression configurés"
echo ""
echo "🌍 Testez maintenant: https://gnut06.zidani.org"
echo ""
echo "🔍 Si le CSS ne s'affiche toujours pas:"
echo "   1. Vérifiez la console du navigateur (F12)"
echo "   2. Regardez les logs: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose logs'"
echo "   3. Testez directement: curl -I https://gnut06.zidani.org"
