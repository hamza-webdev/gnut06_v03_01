#!/bin/bash

# Script de déploiement Docker uniquement (Nginx VPS déjà configuré)
# Usage: ./deploy-docker-only.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"

echo "🐳 Déploiement Docker uniquement"
echo "📍 VPS: $VPS_USER@$VPS_IP:$VPS_DIR"
echo "ℹ️  Nginx VPS déjà configuré - on met juste à jour le container"
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

echo "📦 Build local"
rm -rf dist/
npm run build

if [ ! -d "dist" ]; then
    echo "❌ Build échoué"
    exit 1
fi

echo "✅ Build réussi ($(du -sh dist | cut -f1))"

echo ""
echo "🔗 Connexion au VPS"
run_ssh "echo 'OK'"

echo ""
echo "🗑️ Nettoyage de l'ancien build"
run_ssh "rm -rf $VPS_DIR/dist"

echo ""
echo "📤 Copie du nouveau build"
tar -czf dist.tar.gz dist/
copy_files "dist.tar.gz" "$VPS_DIR/"
run_ssh "cd $VPS_DIR && tar -xzf dist.tar.gz && rm dist.tar.gz"
rm dist.tar.gz
echo "✅ Build copié"

echo ""
echo "🐳 Redémarrage du container Docker"
run_ssh "cd $VPS_DIR && docker compose down"
run_ssh "cd $VPS_DIR && docker compose up -d --build"

echo ""
echo "⏳ Attente du démarrage..."
sleep 10

echo ""
echo "🔍 Vérification"
run_ssh "docker ps | grep gnut06"
run_ssh "curl -I http://localhost:3002 | head -1"

echo ""
echo "✅ Déploiement terminé!"
echo "🌍 Votre application est mise à jour sur: https://gnut06.zidani.org"
echo ""
echo "📊 Status:"
run_ssh "docker compose -f $VPS_DIR/docker-compose.yml ps"
