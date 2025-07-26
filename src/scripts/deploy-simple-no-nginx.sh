#!/bin/bash

# Script de déploiement simple sans configuration Nginx (déjà fait)
# Usage: ./deploy-simple-no-nginx.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"
DOMAIN="gnut06.zidani.org"

echo "🚀 Déploiement simple (Nginx déjà configuré)"
echo "📍 VPS: $VPS_USER@$VPS_IP:$VPS_DIR"
echo "🌐 Domaine: $DOMAIN"
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

# Fonction de copie
copy_files() {
    if command -v sshpass &> /dev/null; then
        sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
    else
        echo "📤 Copie: $1 -> $2"
        scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
    fi
}

echo "📦 ÉTAPE 1: Build local"
echo "Nettoyage du build précédent..."
rm -rf dist/

echo "Build de l'application..."
if npm run build; then
    echo "✅ Build local réussi"
    echo "📊 Taille: $(du -sh dist | cut -f1)"
else
    echo "❌ Erreur lors du build local"
    exit 1
fi

echo ""
echo "🔗 ÉTAPE 2: Connexion au VPS"
run_ssh "echo 'Connexion réussie'"

echo ""
echo "📁 ÉTAPE 3: Préparation du VPS"
run_ssh "mkdir -p $VPS_DIR"

echo ""
echo "📄 ÉTAPE 4: Création du Dockerfile simple"
run_ssh "cat > $VPS_DIR/Dockerfile << 'EOF'
FROM nginx:stable-alpine
COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [\"nginx\", \"-g\", \"daemon off;\"]
EOF"

echo ""
echo "📄 ÉTAPE 5: Création de nginx.conf pour le container"
run_ssh "cat > $VPS_DIR/nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }

    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    add_header X-Content-Type-Options \"nosniff\" always;

    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;
}
EOF"

echo ""
echo "📄 ÉTAPE 6: Création de docker-compose.yml"
run_ssh "cat > $VPS_DIR/docker-compose.yml << 'EOF'
version: '3.8'

services:
  gnut06-app:
    build: .
    container_name: gnut06-app
    restart: unless-stopped
    ports:
      - \"3002:80\"
    networks:
      - gnut06-network

networks:
  gnut06-network:
    driver: bridge
EOF"

echo ""
echo "🗑️ ÉTAPE 7: Suppression de l'ancien build"
run_ssh "rm -rf $VPS_DIR/dist"

echo ""
echo "📤 ÉTAPE 8: Copie du nouveau build"
echo "Création d'une archive..."
tar -czf dist.tar.gz dist/

echo "Copie de l'archive..."
if copy_files "dist.tar.gz" "$VPS_DIR/"; then
    echo "✅ Archive copiée"
    run_ssh "cd $VPS_DIR && tar -xzf dist.tar.gz && rm dist.tar.gz"
    echo "✅ Archive extraite"
    rm dist.tar.gz
else
    echo "❌ Échec de copie de l'archive"
    rm dist.tar.gz
    echo "💡 Essai de copie directe..."
    if copy_files "./dist" "$VPS_DIR/"; then
        echo "✅ Copie directe réussie"
    else
        echo "❌ Échec de copie"
        exit 1
    fi
fi

echo ""
echo "🔍 ÉTAPE 9: Vérification des fichiers"
run_ssh "ls -la $VPS_DIR/"
run_ssh "ls -la $VPS_DIR/dist/ | head -5"

echo ""
echo "🐳 ÉTAPE 10: Docker - Arrêt des anciens containers"
run_ssh "cd $VPS_DIR && docker compose down --remove-orphans || true"
run_ssh "docker system prune -f || true"

echo ""
echo "🔨 ÉTAPE 11: Docker - Construction et démarrage"
run_ssh "cd $VPS_DIR && docker compose up -d --build"

echo ""
echo "⏳ Attente du démarrage du container..."
sleep 15

echo ""
echo "🔍 ÉTAPE 12: Vérification du container"
run_ssh "docker compose -f $VPS_DIR/docker-compose.yml ps"

echo ""
echo "🌐 ÉTAPE 13: Test du container"
run_ssh "curl -I http://localhost:3002 || echo 'Container pas encore prêt'"

echo ""
echo "🔍 ÉTAPE 14: Test du site final"
echo "Test du site HTTPS (Nginx déjà configuré):"
curl -I https://$DOMAIN || echo "Site pas encore accessible"

echo ""
echo "✅ Déploiement terminé avec succès!"
echo "🌍 Application accessible sur: https://$DOMAIN"
echo ""
echo "ℹ️  Configuration Nginx ignorée (déjà faite)"
echo "🐳 Container Docker démarré sur le port 3002"
echo ""
echo "🔍 Commandes utiles:"
echo "   - Logs: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose logs'"
echo "   - Redémarrer: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose restart'"
echo "   - Status: ssh $VPS_USER@$VPS_IP 'docker ps'"
echo "   - Arrêter: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose down'"
