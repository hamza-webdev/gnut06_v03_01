#!/bin/bash

# Script de déploiement pour gnut06 sur VPS
# Usage: ./deploy.sh

set -e  # Arrêter le script en cas d'erreur

# Configuration
VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
DOMAIN="gnut06.zidani.org"
APP_DIR="gnut06"
LOCAL_DIR="."

echo "🚀 Début du déploiement de gnut06..."

# Vérifier si sshpass est installé
if ! command -v sshpass &> /dev/null; then
    echo "❌ sshpass n'est pas installé."
    echo "💡 Solutions :"
    echo "   1. Installer sshpass : sudo apt-get install sshpass (Ubuntu/Debian)"
    echo "   2. Utiliser le déploiement sécurisé : ./deploy-secure.sh"
    echo "   3. Installer les prérequis : ./setup-local.sh"
    exit 1
fi

# Fonction pour exécuter des commandes sur le VPS
run_remote() {
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
}

# Fonction pour copier des fichiers vers le VPS
copy_to_vps() {
    sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
}

echo "📦 Construction de l'application en local..."
npm run build 

echo "📁 Préparation du répertoire sur le VPS..."
echo "🗑️ Suppression de l'ancien répertoire s'il existe..."
run_remote "rm -rf ~/$APP_DIR"
echo "📁 Création du nouveau répertoire..."
run_remote "mkdir -p ~/$APP_DIR"
echo "✅ Répertoire $APP_DIR créé/recréé"

echo "📤 Copie des fichiers vers le VPS..."
copy_to_vps "$LOCAL_DIR/dist" "~/$APP_DIR/"
copy_to_vps "$LOCAL_DIR/Dockerfile" "~/$APP_DIR/"
copy_to_vps "$LOCAL_DIR/nginx.conf" "~/$APP_DIR/"
copy_to_vps "$LOCAL_DIR/docker-compose.yml" "~/$APP_DIR/"
copy_to_vps "$LOCAL_DIR/package.json" "~/$APP_DIR/"

echo "🐳 Arrêt et suppression des anciens containers..."
run_remote "cd ~/$APP_DIR && docker-compose down --remove-orphans || true"
run_remote "docker system prune -f || true"

echo "🔨 Construction et démarrage des nouveaux containers..."
run_remote "cd ~/$APP_DIR && docker-compose up -d --build"

echo "🌐 Configuration de Nginx..."
copy_to_vps "$LOCAL_DIR/nginx-vps.conf" "/tmp/gnut06.zidani.org"
run_remote "sudo mv /tmp/gnut06.zidani.org /etc/nginx/sites-available/"
run_remote "sudo ln -sf /etc/nginx/sites-available/gnut06.zidani.org /etc/nginx/sites-enabled/"

echo "🔒 Configuration SSL avec Let's Encrypt..."
run_remote "sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@zidani.org || echo 'Certificat SSL déjà existant ou erreur'"

echo "🔄 Rechargement de Nginx..."
run_remote "sudo nginx -t && sudo systemctl reload nginx"

echo "🔍 Vérification du statut des services..."
run_remote "docker-compose -f ~/$APP_DIR/docker-compose.yml ps"
run_remote "sudo systemctl status nginx --no-pager -l"

echo "✅ Déploiement terminé avec succès!"
echo "🌍 Votre application est accessible à l'adresse: https://$DOMAIN"
echo ""
echo "📊 Commandes utiles pour la maintenance:"
echo "  - Voir les logs: ssh $VPS_USER@$VPS_IP 'cd $APP_DIR && docker-compose logs -f'"
echo "  - Redémarrer l'app: ssh $VPS_USER@$VPS_IP 'cd $APP_DIR && docker-compose restart'"
echo "  - Arrêter l'app: ssh $VPS_USER@$VPS_IP 'cd $APP_DIR && docker-compose down'"
