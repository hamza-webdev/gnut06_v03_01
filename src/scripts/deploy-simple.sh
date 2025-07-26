#!/bin/bash

# Script de déploiement simple pour gnut06 (étape par étape)
# Usage: ./deploy-simple.sh

set -e

# Configuration
VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
DOMAIN="gnut06.zidani.org"
APP_DIR="gnut06"

echo "🚀 Déploiement simple de gnut06 - étape par étape"
echo "⚠️  Vous devrez saisir le mot de passe SSH à chaque étape"
echo ""

echo "📦 Étape 1: Construction de l'application..."
npm run build
echo "✅ Build terminé"

echo ""
echo "🔗 Étape 2: Test de connexion SSH..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "echo 'Connexion SSH réussie'"
echo "✅ Connexion SSH OK"

echo ""
echo "🗑️ Étape 3: Suppression de l'ancien répertoire..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "rm -rf ~/$APP_DIR"
echo "✅ Ancien répertoire supprimé"

echo ""
echo "📁 Étape 4: Création du nouveau répertoire..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "mkdir -p ~/$APP_DIR"
echo "✅ Nouveau répertoire créé"

echo ""
echo "🔍 Étape 5: Vérification du répertoire..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "ls -la ~/$APP_DIR"
echo "✅ Répertoire vérifié"

echo ""
echo "📤 Étape 6: Copie du dossier dist..."
scp -o StrictHostKeyChecking=no -r ./dist "$VPS_USER@$VPS_IP:~/$APP_DIR/"
echo "✅ Dossier dist copié"

echo ""
echo "📤 Étape 7: Copie du Dockerfile..."
scp -o StrictHostKeyChecking=no ./Dockerfile "$VPS_USER@$VPS_IP:~/$APP_DIR/"
echo "✅ Dockerfile copié"

echo ""
echo "📤 Étape 8: Copie de nginx.conf..."
scp -o StrictHostKeyChecking=no ./nginx.conf "$VPS_USER@$VPS_IP:~/$APP_DIR/"
echo "✅ nginx.conf copié"

echo ""
echo "📤 Étape 9: Copie de docker-compose.yml..."
scp -o StrictHostKeyChecking=no ./docker-compose.yml "$VPS_USER@$VPS_IP:~/$APP_DIR/"
echo "✅ docker-compose.yml copié"

echo ""
echo "📤 Étape 10: Copie de package.json..."
scp -o StrictHostKeyChecking=no ./package.json "$VPS_USER@$VPS_IP:~/$APP_DIR/"
echo "✅ package.json copié"

echo ""
echo "🔍 Étape 11: Vérification des fichiers copiés..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "ls -la ~/$APP_DIR/"
echo "✅ Fichiers vérifiés"

echo ""
echo "🐳 Étape 12: Arrêt des anciens containers..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "cd ~/$APP_DIR && docker-compose down --remove-orphans || true"
echo "✅ Anciens containers arrêtés"

echo ""
echo "🔨 Étape 13: Construction et démarrage des nouveaux containers..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "cd ~/$APP_DIR && docker-compose up -d --build"
echo "✅ Nouveaux containers démarrés"

echo ""
echo "🌐 Étape 14: Configuration de Nginx..."
scp -o StrictHostKeyChecking=no ./nginx-vps.conf "$VPS_USER@$VPS_IP:/tmp/gnut06.zidani.org"
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "sudo mv /tmp/gnut06.zidani.org /etc/nginx/sites-available/"
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "sudo ln -sf /etc/nginx/sites-available/gnut06.zidani.org /etc/nginx/sites-enabled/"
echo "✅ Nginx configuré"

echo ""
echo "🔒 Étape 15: Configuration SSL..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@zidani.org || echo 'Certificat SSL déjà existant ou erreur'"
echo "✅ SSL configuré"

echo ""
echo "🔄 Étape 16: Rechargement de Nginx..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "sudo nginx -t && sudo systemctl reload nginx"
echo "✅ Nginx rechargé"

echo ""
echo "🔍 Étape 17: Vérification finale..."
ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "docker-compose -f ~/$APP_DIR/docker-compose.yml ps"
echo ""

echo "✅ Déploiement terminé avec succès!"
echo "🌍 Votre application est accessible à l'adresse: https://$DOMAIN"
