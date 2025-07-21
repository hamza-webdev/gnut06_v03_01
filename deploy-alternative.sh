#!/bin/bash

# Script de déploiement alternatif - création des fichiers directement sur le VPS
# Usage: ./deploy-alternative.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
DOMAIN="gnut06.zidani.org"
APP_DIR="gnut06"

echo "🚀 Déploiement alternatif - création des fichiers sur le VPS"
echo ""

# Fonction SSH simple
run_ssh() {
    ssh -o ConnectTimeout=15 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
}

echo "📦 Étape 1: Build local"
npm run build
echo "✅ Build terminé"

echo ""
echo "🔗 Étape 2: Test de connexion"
run_ssh "echo 'Connexion OK'"

echo ""
echo "📁 Étape 3: Préparation du répertoire"
run_ssh "rm -rf ~/$APP_DIR && mkdir -p ~/$APP_DIR"

echo ""
echo "📄 Étape 4: Création du Dockerfile sur le VPS"
run_ssh "cat > ~/$APP_DIR/Dockerfile << 'EOF'
# Servir l'application avec Nginx (build déjà fait localement)
FROM nginx:stable-alpine

# Copier le build depuis le répertoire local
COPY dist /usr/share/nginx/html

# Copier la configuration Nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD [\"nginx\", \"-g\", \"daemon off;\"]
EOF"

echo ""
echo "📄 Étape 5: Création de nginx.conf sur le VPS"
run_ssh "cat > ~/$APP_DIR/nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Gestion des fichiers statiques
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache pour les assets statiques
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }

    # Sécurité headers
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    add_header X-Content-Type-Options \"nosniff\" always;
    add_header Referrer-Policy \"no-referrer-when-downgrade\" always;
    add_header Content-Security-Policy \"default-src 'self' http: https: data: blob: 'unsafe-inline'\" always;

    # Compression gzip
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;
}
EOF"

echo ""
echo "📄 Étape 6: Création de docker-compose.yml sur le VPS"
run_ssh "cat > ~/$APP_DIR/docker-compose.yml << 'EOF'
version: '3.8'

services:
  gnut06-app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: gnut06-app
    restart: unless-stopped
    ports:
      - \"3002:80\"
    networks:
      - gnut06-network
    environment:
      - NODE_ENV=production
    labels:
      - \"traefik.enable=false\"

networks:
  gnut06-network:
    driver: bridge
EOF"

echo ""
echo "📄 Étape 7: Création de package.json sur le VPS"
run_ssh "cat > ~/$APP_DIR/package.json << 'EOF'
{
  \"name\": \"gnut06\",
  \"version\": \"1.0.0\",
  \"scripts\": {
    \"build\": \"echo 'Build déjà fait'\"
  }
}
EOF"

echo ""
echo "📤 Étape 8: Copie du dossier dist (tentative avec tar)"
echo "Création d'une archive tar du dossier dist..."
tar -czf dist.tar.gz -C dist .
echo "Copie de l'archive..."
if scp -o ConnectTimeout=30 -o StrictHostKeyChecking=no dist.tar.gz "$VPS_USER@$VPS_IP:~/$APP_DIR/"; then
    echo "✅ Archive copiée avec succès"
    run_ssh "cd ~/$APP_DIR && mkdir -p dist && tar -xzf dist.tar.gz -C dist && rm dist.tar.gz"
    rm dist.tar.gz
else
    echo "❌ Échec de copie de l'archive"
    echo "💡 Vous devrez copier manuellement le dossier dist"
    rm dist.tar.gz
fi

echo ""
echo "🔍 Étape 9: Vérification des fichiers"
run_ssh "ls -la ~/$APP_DIR/"  Besmillah2025

echo ""
echo "🐳 Étape 10: Docker"
run_ssh "cd ~/$APP_DIR && docker compose down --remove-orphans || true"
run_ssh "cd ~/$APP_DIR && docker compose up -d --build"

echo ""
echo "🌐 Étape 11: Configuration Nginx VPS"
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

run_ssh "sudo ln -sf /etc/nginx/sites-available/gnut06.zidani.org /etc/nginx/sites-enabled/"

echo ""
echo "🔒 Étape 12: SSL"
run_ssh "sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@zidani.org || echo 'Certificat déjà existant'"

echo ""
echo "🔄 Étape 13: Rechargement Nginx"
run_ssh "sudo nginx -t && sudo systemctl reload nginx"

echo ""
echo "✅ Déploiement alternatif terminé!"
echo "🌍 Application accessible sur: https://$DOMAIN"
