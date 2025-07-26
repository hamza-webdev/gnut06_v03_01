#!/bin/bash

# Script de déploiement manuel avec instructions étape par étape
# Usage: ./deploy-manual.sh

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
DOMAIN="gnut06.zidani.org"
APP_DIR="gnut06"

echo "🚀 Guide de déploiement manuel pour gnut06"
echo "⚠️  Problème de connexion SSH détecté - déploiement manuel recommandé"
echo ""

echo "📦 Étape 1: Build local (automatique)"
npm run build
echo "✅ Build terminé"
echo ""

echo "🔗 Étape 2: Connexion au VPS"
echo "Exécutez cette commande pour vous connecter au VPS:"
echo "ssh $VPS_USER@$VPS_IP"
echo ""
echo "Une fois connecté, exécutez les commandes suivantes sur le VPS:"
echo ""

echo "🗑️ Étape 3: Nettoyage (sur le VPS)"
echo "rm -rf ~/$APP_DIR"
echo "mkdir -p ~/$APP_DIR"
echo "ls -la ~/$APP_DIR"
echo ""

echo "📤 Étape 4: Transfert des fichiers"
echo "Ouvrez un NOUVEAU terminal local et exécutez ces commandes UNE PAR UNE:"
echo ""
echo "# Copie du dossier dist"
echo "scp -r ./dist $VPS_USER@$VPS_IP:~/$APP_DIR/"
echo ""
echo "# Copie des fichiers de configuration"
echo "scp ./Dockerfile $VPS_USER@$VPS_IP:~/$APP_DIR/"
echo "scp ./nginx.conf $VPS_USER@$VPS_IP:~/$APP_DIR/"
echo "scp ./docker-compose.yml $VPS_USER@$VPS_IP:~/$APP_DIR/"
echo "scp ./package.json $VPS_USER@$VPS_IP:~/$APP_DIR/"
echo ""

echo "🌐 Étape 5: Configuration Nginx (sur le VPS)"
echo "# Créer le fichier de configuration Nginx directement sur le VPS"
echo "sudo nano /etc/nginx/sites-available/gnut06.zidani.org"
echo ""
echo "# Copiez-collez ce contenu dans le fichier:"
echo "------- DÉBUT DU CONTENU -------"
cat nginx-vps.conf
echo "------- FIN DU CONTENU -------"
echo ""
echo "# Puis activez le site:"
echo "sudo ln -sf /etc/nginx/sites-available/gnut06.zidani.org /etc/nginx/sites-enabled/"
echo "sudo nginx -t"
echo ""

echo "🐳 Étape 6: Docker (sur le VPS)"
echo "cd ~/$APP_DIR"
echo "docker-compose down --remove-orphans || true"
echo "docker system prune -f"
echo "docker-compose up -d --build"
echo "docker-compose ps"
echo ""

echo "🔒 Étape 7: SSL (sur le VPS)"
echo "sudo certbot --nginx -d $DOMAIN --email admin@zidani.org"
echo "sudo systemctl reload nginx"
echo ""

echo "🔍 Étape 8: Vérification finale"
echo "curl -I https://$DOMAIN"
echo ""

echo "✅ Instructions de déploiement manuel générées!"
echo ""
echo "💡 RÉSUMÉ DES ACTIONS:"
echo "1. Le build local est fait automatiquement"
echo "2. Connectez-vous au VPS: ssh $VPS_USER@$VPS_IP"
echo "3. Suivez les étapes 3-8 ci-dessus"
echo "4. Utilisez un nouveau terminal pour les transferts de fichiers"
echo ""
echo "🆘 Si les transferts scp échouent encore:"
echo "   - Vérifiez l'espace disque: df -h"
echo "   - Vérifiez la mémoire: free -h"
echo "   - Redémarrez le service SSH: sudo systemctl restart ssh"
