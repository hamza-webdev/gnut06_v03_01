#!/bin/bash

# Script de redéploiement complet depuis zéro
# Usage: ./redeploy-from-zero.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"

echo "🚀 Redéploiement complet de gnut06 depuis zéro"
echo "📍 VPS: $VPS_USER@$VPS_IP:$VPS_DIR"
echo "🌐 Site: https://gnut06.zidani.org"
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

echo "🔗 Test de connexion au VPS..."
run_ssh "echo 'Connexion réussie'"

echo ""
echo "🗑️ ÉTAPE 1: Nettoyage complet du VPS"
echo "Arrêt et suppression des anciens containers..."
run_ssh "cd $VPS_DIR && docker compose down --remove-orphans || true" 2>/dev/null || true
run_ssh "docker system prune -af || true"

echo "Suppression complète du répertoire..."
run_ssh "rm -rf $VPS_DIR"
run_ssh "mkdir -p $VPS_DIR"

echo "✅ VPS nettoyé"

echo ""
echo "📦 ÉTAPE 2: Préparation locale"
echo "Vérification des fichiers locaux essentiels..."

# Liste des fichiers/dossiers à copier
FILES_TO_COPY=(
    "src"
    "public"
    "package.json"
    "package-lock.json"
    "index.html"
    "vite.config.ts"
    "tailwind.config.ts"
    "tsconfig.json"
    "tsconfig.app.json"
    "tsconfig.node.json"
    "postcss.config.js"
    "components.json"
    ".env.production"
)

echo "Fichiers à copier:"
for item in "${FILES_TO_COPY[@]}"; do
    if [ -e "./$item" ]; then
        if [ -d "./$item" ]; then
            size=$(du -sh "./$item" | cut -f1)
            files=$(find "./$item" -type f | wc -l)
            echo "  ✅ $item (dossier: $size, $files fichiers)"
        else
            size=$(du -sh "./$item" | cut -f1)
            echo "  ✅ $item (fichier: $size)"
        fi
    else
        echo "  ⚠️  $item (non trouvé - sera ignoré)"
    fi
done

echo ""
echo "📤 ÉTAPE 3: Copie de tous les fichiers vers le VPS"

# Copie des fichiers individuels
for item in "${FILES_TO_COPY[@]}"; do
    if [ -e "./$item" ]; then
        echo "Copie de $item..."
        if [ -d "./$item" ]; then
            # Pour les dossiers, créer une archive
            tar -czf "${item}.tar.gz" "$item"
            copy_files "${item}.tar.gz" "$VPS_DIR/"
            run_ssh "cd $VPS_DIR && tar -xzf ${item}.tar.gz && rm ${item}.tar.gz"
            rm "${item}.tar.gz"
        else
            # Pour les fichiers
            copy_files "./$item" "$VPS_DIR/"
        fi
        echo "  ✅ $item copié"
    fi
done

echo ""
echo "📄 ÉTAPE 4: Création de la configuration Nginx pour le container"
run_ssh "cat > $VPS_DIR/nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Configuration pour SPA React
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Optimisation pour les assets CSS/JS (crucial pour Tailwind)
    location ~* \.(css|js)\$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
        add_header Content-Type \"text/css\" always;
        
        # Headers CORS pour éviter les problèmes de chargement
        add_header Access-Control-Allow-Origin \"*\";
        add_header Access-Control-Allow-Methods \"GET, POST, OPTIONS\";
        add_header Access-Control-Allow-Headers \"DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range\";
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

    # Compression gzip optimisée pour Tailwind CSS
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
    error_log /var/log/nginx/error.log warn;
}
EOF"

echo "✅ Configuration Nginx container créée"

echo ""
echo "🔍 ÉTAPE 5: Vérification des fichiers copiés"
run_ssh "ls -la $VPS_DIR/"

echo ""
echo "Vérification de la configuration Tailwind:"
run_ssh "cat $VPS_DIR/tailwind.config.ts | head -10" || echo "tailwind.config.ts non accessible"

echo ""
echo "Vérification du fichier CSS principal:"
run_ssh "cat $VPS_DIR/src/index.css | head -10" || echo "src/index.css non accessible"

echo ""
echo "🐳 ÉTAPE 6: Construction et démarrage Docker"
echo "Construction du container (cela peut prendre quelques minutes)..."
run_ssh "cd $VPS_DIR && docker compose up -d --build"

echo ""
echo "⏳ Attente du démarrage complet (45 secondes)..."
sleep 45

echo ""
echo "🔍 ÉTAPE 7: Vérifications complètes"

echo ""
echo "1️⃣ Status du container:"
run_ssh "docker compose -f $VPS_DIR/docker-compose.yml ps"

echo ""
echo "2️⃣ Logs du container (dernières lignes):"
run_ssh "docker logs gnut06-app --tail 10"

echo ""
echo "3️⃣ Port 8080 ouvert:"
run_ssh "netstat -tuln | grep :8080" || echo "Port 8080 non ouvert"

echo ""
echo "4️⃣ Test de connectivité du container:"
run_ssh "curl -I http://localhost:8080 2>/dev/null | head -3" || echo "Container non accessible"

echo ""
echo "5️⃣ Vérification des fichiers dans le container:"
run_ssh "docker exec gnut06-app ls -la /usr/share/nginx/html/ | head -10" || echo "Impossible d'accéder au contenu du container"

echo ""
echo "6️⃣ Vérification des fichiers CSS dans le container:"
run_ssh "docker exec gnut06-app find /usr/share/nginx/html -name '*.css' -exec ls -la {} \;" || echo "Aucun fichier CSS trouvé"

echo ""
echo "7️⃣ Test du contenu d'un fichier CSS:"
run_ssh "docker exec gnut06-app find /usr/share/nginx/html -name '*.css' -exec head -5 {} \;" || echo "Impossible de lire les fichiers CSS"

echo ""
echo "8️⃣ Test du site public:"
echo "Test HTTPS:"
curl -I https://gnut06.zidani.org 2>/dev/null | head -3 || echo "Site non accessible depuis l'extérieur"

echo ""
echo "Test de récupération de la page:"
curl -s https://gnut06.zidani.org 2>/dev/null | head -10 || echo "Impossible de récupérer la page"

echo ""
echo "Test des liens CSS sur le site:"
curl -s https://gnut06.zidani.org 2>/dev/null | grep -o 'href=\"[^\"]*\.css[^\"]*\"' | head -3 || echo "Aucun lien CSS trouvé"

echo ""
echo "✅ REDÉPLOIEMENT TERMINÉ!"
echo ""
echo "🎯 Résumé de la configuration:"
echo "   - Tous les fichiers copiés depuis le local"
echo "   - Container Docker construit avec le code source complet"
echo "   - Nginx container optimisé pour Tailwind CSS"
echo "   - Port 8080 (correspond à votre Nginx VPS)"
echo "   - Configuration SPA pour React Router"
echo ""
echo "🌍 Testez maintenant: https://gnut06.zidani.org"
echo ""
echo "🔍 Si le design ne s'affiche toujours pas:"
echo "   1. Ouvrez la console du navigateur (F12) et regardez les erreurs"
echo "   2. Vérifiez les logs: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose logs'"
echo "   3. Testez un fichier CSS directement: curl -I https://gnut06.zidani.org/assets/[nom-du-fichier].css"
echo ""
echo "📊 Commandes utiles:"
echo "   - Logs container: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose logs -f'"
echo "   - Redémarrer: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose restart'"
echo "   - Reconstruire: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose up -d --build'"
