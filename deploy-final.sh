#!/bin/bash

# Script de déploiement final pour gnut06
# Usage: ./deploy-final.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
DOMAIN="gnut06.zidani.org"
APP_DIR="/home/vpsadmin/gnut06"

echo "🚀 Déploiement final de gnut06"
echo "📍 Destination: $VPS_USER@$VPS_IP:$APP_DIR"
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

echo "📦 Étape 1: Build local"
echo "Nettoyage du build précédent..."
rm -rf dist/

echo "Build de l'application..."
npm run build

if [ ! -d "dist" ]; then
    echo "❌ Erreur: Le build a échoué"
    exit 1
fi

echo "✅ Build local réussi"
echo "📊 Taille: $(du -sh dist | cut -f1)"
echo ""

echo "🔗 Étape 2: Connexion au VPS"
run_ssh "echo 'Connexion réussie'"

echo ""
echo "📁 Étape 3: Préparation du répertoire"
run_ssh "mkdir -p $APP_DIR"
run_ssh "rm -rf $APP_DIR/dist $APP_DIR/Dockerfile $APP_DIR/nginx.conf $APP_DIR/docker-compose.yml"

echo ""
echo "📄 Étape 4: Création des fichiers de configuration"

# Dockerfile
run_ssh "cat > $APP_DIR/Dockerfile << 'EOF'
FROM nginx:stable-alpine
COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [\"nginx\", \"-g\", \"daemon off;\"]
EOF"

# nginx.conf
run_ssh "cat > $APP_DIR/nginx.conf << 'EOF'
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

# docker-compose.yml
run_ssh "cat > $APP_DIR/docker-compose.yml << 'EOF'
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

echo "✅ Fichiers de configuration créés"

echo ""
echo "📤 Étape 5: Copie du build"
echo "Création d'une archive..."
tar -czf dist.tar.gz dist/

echo "Copie de l'archive..."
if copy_files "dist.tar.gz" "$APP_DIR/"; then
    echo "✅ Archive copiée"
    run_ssh "cd $APP_DIR && tar -xzf dist.tar.gz && rm dist.tar.gz"
    echo "✅ Archive extraite"
    rm dist.tar.gz
else
    echo "❌ Échec de copie"
    rm dist.tar.gz
    exit 1
fi

echo ""
echo "🔍 Étape 6: Vérification des fichiers"
run_ssh "ls -la $APP_DIR/"
run_ssh "ls -la $APP_DIR/dist/ | head -5"

echo ""
echo "🐳 Étape 7: Docker"
run_ssh "cd $APP_DIR && docker compose down --remove-orphans || true"
run_ssh "docker system prune -f || true"

echo "Construction du container..."
run_ssh "cd $APP_DIR && docker compose up -d --build"

echo "⏳ Attente du démarrage..."
sleep 10

echo ""
echo "🔍 Étape 8: Vérification du container"
run_ssh "docker compose -f $APP_DIR/docker-compose.yml ps"
run_ssh "curl -I http://localhost:3002 || echo 'Container pas encore prêt'"

echo ""
echo "🌐 Étape 9: Configuration Nginx VPS"
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
run_ssh "sudo nginx -t"

echo ""
echo "🔒 Étape 10: SSL"
run_ssh "sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@zidani.org || echo 'Certificat déjà existant'"

echo ""
echo "🔄 Étape 11: Rechargement Nginx"
run_ssh "sudo systemctl reload nginx"

echo ""
echo "🔍 Étape 12: Test final"
echo "Test du container:"
run_ssh "curl -I http://localhost:3002"

echo ""
echo "Test du site HTTPS:"
curl -I https://$DOMAIN || echo "Site pas encore accessible (propagation DNS)"

echo ""
echo "✅ Déploiement terminé avec succès!"
echo "🌍 Application accessible sur: https://$DOMAIN"
echo ""
echo "🔍 Vérifications:"
echo "   - Container: ssh $VPS_USER@$VPS_IP 'docker ps'"
echo "   - Logs: ssh $VPS_USER@$VPS_IP 'cd $APP_DIR && docker compose logs'"
echo "   - Site: curl -I https://$DOMAIN"
