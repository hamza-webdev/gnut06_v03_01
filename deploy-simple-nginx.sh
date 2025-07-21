#!/bin/bash

# Script de déploiement ultra-simple avec Nginx statique
# Usage: ./deploy-simple-nginx.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
DOMAIN="gnut06.zidani.org"
APP_DIR="gnut06"

echo "🚀 Déploiement ultra-simple avec Nginx statique"
echo ""

# Fonction SSH
run_ssh() {
    ssh -o ConnectTimeout=15 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
}

echo "📦 Étape 1: Build local"
npm run build
echo "✅ Build terminé"

echo ""
echo "📁 Étape 2: Préparation du répertoire sur le VPS"
run_ssh "rm -rf ~/$APP_DIR && mkdir -p ~/$APP_DIR"

echo ""
echo "📄 Étape 3: Création du Dockerfile simple"
run_ssh "cat > ~/$APP_DIR/Dockerfile << 'EOF'
FROM nginx:alpine
COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [\"nginx\", \"-g\", \"daemon off;\"]
EOF"

echo ""
echo "📄 Étape 4: Création de nginx.conf"
run_ssh "cat > ~/$APP_DIR/nginx.conf << 'EOF'
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

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
EOF"

echo ""
echo "📄 Étape 5: Création de docker-compose.yml"
run_ssh "cat > ~/$APP_DIR/docker-compose.yml << 'EOF'
version: '3.8'
services:
  gnut06-app:
    build: .
    container_name: gnut06-app
    restart: unless-stopped
    ports:
      - \"3002:80\"
EOF"

echo ""
echo "📤 Étape 6: Copie du dossier dist"
echo "Création d'une archive compressée..."
tar -czf dist.tar.gz -C dist .

echo "Copie de l'archive (peut prendre du temps)..."
if scp -o ConnectTimeout=60 -o StrictHostKeyChecking=no dist.tar.gz "$VPS_USER@$VPS_IP:~/$APP_DIR/"; then
    echo "✅ Archive copiée"
    run_ssh "cd ~/$APP_DIR && mkdir -p dist && tar -xzf dist.tar.gz -C dist && rm dist.tar.gz"
    rm dist.tar.gz
else
    echo "❌ Échec de copie - essai avec rsync..."
    rm dist.tar.gz
    if command -v rsync &> /dev/null; then
        rsync -avz --progress -e "ssh -o StrictHostKeyChecking=no" ./dist/ "$VPS_USER@$VPS_IP:~/$APP_DIR/dist/"
        echo "✅ Copie avec rsync réussie"
    else
        echo "❌ rsync non disponible. Copie manuelle nécessaire."
        echo "Exécutez: scp -r ./dist $VPS_USER@$VPS_IP:~/$APP_DIR/"
        exit 1
    fi
fi

echo ""
echo "🔍 Étape 7: Vérification des fichiers"
run_ssh "ls -la ~/$APP_DIR/ && ls -la ~/$APP_DIR/dist/ | head -10"

echo ""
echo "🐳 Étape 8: Arrêt des anciens containers"
run_ssh "cd ~/$APP_DIR && docker compose down --remove-orphans || true"
run_ssh "docker system prune -f || true"

echo ""
echo "🔨 Étape 9: Construction et démarrage du nouveau container"
run_ssh "cd ~/$APP_DIR && docker compose up -d --build"

echo ""
echo "⏳ Attente du démarrage du container..."
sleep 10

echo ""
echo "🔍 Étape 10: Vérification du container"
run_ssh "docker compose -f ~/$APP_DIR/docker-compose.yml ps"
run_ssh "curl -I http://localhost:3002 || echo 'Container pas encore prêt'"

echo ""
echo "🌐 Étape 11: Configuration Nginx sur le VPS"
run_ssh "sudo tee /etc/nginx/sites-available/gnut06.zidani.org > /dev/null << 'EOF'
server {
    listen 80;
    server_name gnut06.zidani.org;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name gnut06.zidani.org;

    ssl_certificate /etc/letsencrypt/live/gnut06.zidani.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/gnut06.zidani.org/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    
    add_header Strict-Transport-Security \"max-age=31536000; includeSubDomains\" always;
    
    location / {
        proxy_pass http://localhost:3002;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    access_log /var/log/nginx/gnut06.zidani.org.access.log;
    error_log /var/log/nginx/gnut06.zidani.org.error.log;
}
EOF"

echo ""
echo "🔗 Étape 12: Activation du site"
run_ssh "sudo ln -sf /etc/nginx/sites-available/gnut06.zidani.org /etc/nginx/sites-enabled/"
run_ssh "sudo nginx -t"

echo ""
echo "🔒 Étape 13: Configuration SSL"
run_ssh "sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@zidani.org || echo 'Certificat déjà existant'"

echo ""
echo "🔄 Étape 14: Rechargement Nginx"
run_ssh "sudo systemctl reload nginx"

echo ""
echo "🔍 Étape 15: Test final"
echo "Test local du container:"
run_ssh "curl -I http://localhost:3002"
echo ""
echo "Test du site HTTPS:"
curl -I https://$DOMAIN || echo "Site pas encore accessible (DNS ou certificat)"

echo ""
echo "✅ Déploiement terminé!"
echo "🌍 Votre application devrait être accessible sur: https://$DOMAIN"
echo ""
echo "🔍 Pour vérifier:"
echo "   - Container: ssh $VPS_USER@$VPS_IP 'docker ps'"
echo "   - Logs: ssh $VPS_USER@$VPS_IP 'cd $APP_DIR && docker compose logs'"
echo "   - Site: curl -I https://$DOMAIN"
