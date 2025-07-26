#!/bin/bash

# Script de déploiement avec build local (évite les problèmes Rollup sur VPS)
# Usage: ./deploy-local-build.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"
DOMAIN="gnut06.zidani.org"

echo "🚀 Déploiement avec build local (solution anti-Rollup)"
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
echo "📄 ÉTAPE 4: Création du Dockerfile simple (sans build)"
run_ssh "cat > $VPS_DIR/Dockerfile << 'EOF'
FROM nginx:stable-alpine

# Copier le build depuis le répertoire local
COPY dist /usr/share/nginx/html

# Copier la configuration Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD [\"nginx\", \"-g\", \"daemon off;\"]
EOF"

echo ""
echo "📄 ÉTAPE 5: Création de nginx.conf"
run_ssh "cat > $VPS_DIR/nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Gestion des SPA (Single Page Application)
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache pour les assets statiques
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }

    # Headers de sécurité
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    add_header X-Content-Type-Options \"nosniff\" always;

    # Compression gzip
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
echo "🗑️ ÉTAPE 7: Suppression de l'ancien build sur le VPS"
run_ssh "rm -rf $VPS_DIR/dist"

echo ""
echo "📤 ÉTAPE 8: Copie du nouveau build"
echo "Création d'une archive pour une copie plus rapide..."
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
run_ssh "curl -I http://localhost:3002 || echo 'Container pas encore prêt'"

echo ""
echo "🌐 ÉTAPE 13: Configuration Nginx VPS (si pas déjà fait)"
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
echo "🔒 ÉTAPE 14: SSL (si pas déjà configuré)"
run_ssh "sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@zidani.org || echo 'Certificat déjà existant'"

echo ""
echo "🔄 ÉTAPE 15: Rechargement Nginx"
run_ssh "sudo systemctl reload nginx"

echo ""
echo "🔍 ÉTAPE 16: Tests finaux"
echo "Test du container:"
run_ssh "curl -I http://localhost:3002"

echo ""
echo "Test du site HTTPS:"
curl -I https://$DOMAIN || echo "Site pas encore accessible (propagation DNS)"

echo ""
echo "✅ Déploiement terminé avec succès!"
echo "🌍 Application accessible sur: https://$DOMAIN"
echo ""
echo "🎯 Cette méthode évite complètement les problèmes Rollup sur le VPS"
echo "   car le build se fait sur votre machine locale où tout fonctionne."
echo ""
echo "🔍 Commandes utiles:"
echo "   - Logs: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose logs'"
echo "   - Redémarrer: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose restart'"
echo "   - Status: ssh $VPS_USER@$VPS_IP 'docker ps'"
