#!/bin/bash

# Script de déploiement robuste avec gestion des erreurs de connexion
# Usage: ./deploy-robust.sh

set -e

# Configuration
VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
DOMAIN="gnut06.zidani.org"
APP_DIR="gnut06"

# Options SSH robustes
SSH_OPTS="-o ConnectTimeout=30 -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no"
SCP_OPTS="-o ConnectTimeout=30 -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no"

echo "🚀 Déploiement robuste de gnut06..."
echo ""

# Fonction pour exécuter des commandes SSH avec retry
run_ssh() {
    local cmd="$1"
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "🔄 Tentative $attempt/$max_attempts: $cmd"
        if ssh $SSH_OPTS "$VPS_USER@$VPS_IP" "$cmd"; then
            echo "✅ Commande réussie"
            return 0
        else
            echo "❌ Tentative $attempt échouée"
            if [ $attempt -lt $max_attempts ]; then
                echo "⏳ Attente de 5 secondes avant nouvelle tentative..."
                sleep 5
            fi
            attempt=$((attempt + 1))
        fi
    done
    
    echo "❌ Toutes les tentatives ont échoué pour: $cmd"
    return 1
}

# Fonction pour copier des fichiers avec retry
copy_file() {
    local src="$1"
    local dest="$2"
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "📤 Tentative $attempt/$max_attempts: Copie $src -> $dest"
        if scp $SCP_OPTS -r "$src" "$VPS_USER@$VPS_IP:$dest"; then
            echo "✅ Copie réussie"
            return 0
        else
            echo "❌ Tentative $attempt échouée"
            if [ $attempt -lt $max_attempts ]; then
                echo "⏳ Attente de 5 secondes avant nouvelle tentative..."
                sleep 5
            fi
            attempt=$((attempt + 1))
        fi
    done
    
    echo "❌ Toutes les tentatives de copie ont échoué pour: $src"
    return 1
}

echo "📦 Étape 1: Construction de l'application..."
npm run build
echo "✅ Build terminé"

echo ""
echo "🔗 Étape 2: Test de connexion SSH..."
run_ssh "echo 'Connexion SSH réussie'"

echo ""
echo "🗑️ Étape 3: Nettoyage de l'ancien répertoire..."
run_ssh "rm -rf ~/$APP_DIR"

echo ""
echo "📁 Étape 4: Création du nouveau répertoire..."
run_ssh "mkdir -p ~/$APP_DIR"

echo ""
echo "🔍 Étape 5: Vérification du répertoire..."
run_ssh "ls -la ~/$APP_DIR"

echo ""
echo "📤 Étape 6: Copie des fichiers (par petits morceaux)..."

# Copier le dossier dist en plusieurs parties si nécessaire
if [ -d "./dist" ]; then
    echo "📦 Copie du dossier dist..."
    copy_file "./dist" "~/$APP_DIR/"
else
    echo "❌ Dossier dist non trouvé - exécutez 'npm run build'"
    exit 1
fi

echo "📄 Copie du Dockerfile..."
copy_file "./Dockerfile" "~/$APP_DIR/"

echo "📄 Copie de nginx.conf..."
copy_file "./nginx.conf" "~/$APP_DIR/"

echo "📄 Copie de docker-compose.yml..."
copy_file "./docker-compose.yml" "~/$APP_DIR/"

echo "📄 Copie de package.json..."
copy_file "./package.json" "~/$APP_DIR/"

echo ""
echo "🔍 Étape 7: Vérification des fichiers copiés..."
run_ssh "ls -la ~/$APP_DIR/"

echo ""
echo "🐳 Étape 8: Gestion des containers Docker..."
run_ssh "cd ~/$APP_DIR && docker-compose down --remove-orphans || true"
run_ssh "docker system prune -f || true"

echo ""
echo "🔨 Étape 9: Construction et démarrage des containers..."
run_ssh "cd ~/$APP_DIR && docker-compose up -d --build"

echo ""
echo "🌐 Étape 10: Configuration de Nginx..."
copy_file "./nginx-vps.conf" "/tmp/gnut06.zidani.org"
run_ssh "sudo mv /tmp/gnut06.zidani.org /etc/nginx/sites-available/"
run_ssh "sudo ln -sf /etc/nginx/sites-available/gnut06.zidani.org /etc/nginx/sites-enabled/"

echo ""
echo "🔒 Étape 11: Configuration SSL..."
run_ssh "sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@zidani.org || echo 'Certificat SSL déjà existant'"

echo ""
echo "🔄 Étape 12: Rechargement de Nginx..."
run_ssh "sudo nginx -t && sudo systemctl reload nginx"

echo ""
echo "🔍 Étape 13: Vérification finale..."
run_ssh "docker-compose -f ~/$APP_DIR/docker-compose.yml ps"

echo ""
echo "✅ Déploiement terminé avec succès!"
echo "🌍 Votre application est accessible à l'adresse: https://$DOMAIN"
