#!/bin/bash

# Script de maintenance pour gnut06
# Usage: ./maintenance.sh [action]
# Actions: status, restart, stop, start, logs, backup, update

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
APP_DIR="gnut06"
DOMAIN="gnut06.zidani.org"

# Fonction pour exécuter des commandes sur le VPS
run_remote() {
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
}

case "$1" in
    "status")
        echo "📊 Statut de l'application gnut06..."
        run_remote "cd ~/$APP_DIR && docker-compose ps"
        run_remote "sudo systemctl status nginx --no-pager -l"
        echo "🌐 Test de connectivité..."
        curl -I https://$DOMAIN || echo "❌ Site non accessible"
        ;;
    
    "restart")
        echo "🔄 Redémarrage de l'application..."
        run_remote "cd ~/$APP_DIR && docker-compose restart"
        echo "✅ Application redémarrée"
        ;;
    
    "stop")
        echo "⏹️ Arrêt de l'application..."
        run_remote "cd ~/$APP_DIR && docker-compose down"
        echo "✅ Application arrêtée"
        ;;
    
    "start")
        echo "▶️ Démarrage de l'application..."
        run_remote "cd ~/$APP_DIR && docker-compose up -d"
        echo "✅ Application démarrée"
        ;;
    
    "logs")
        echo "📋 Logs de l'application (Ctrl+C pour quitter)..."
        run_remote "cd ~/$APP_DIR && docker-compose logs -f"
        ;;
    
    "backup")
        echo "💾 Sauvegarde de la configuration..."
        BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        sshpass -p "$VPS_PASSWORD" scp -r -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP:~/$APP_DIR" "./$BACKUP_DIR/"
        echo "✅ Sauvegarde créée dans $BACKUP_DIR"
        ;;
    
    "update")
        echo "🔄 Mise à jour de l'application..."
        npm run build
        ./deploy.sh
        echo "✅ Mise à jour terminée"
        ;;
    
    "clean")
        echo "🧹 Nettoyage des ressources Docker..."
        run_remote "docker system prune -f"
        run_remote "docker volume prune -f"
        echo "✅ Nettoyage terminé"
        ;;
    
    *)
        echo "🛠️ Script de maintenance gnut06"
        echo ""
        echo "Usage: $0 [action]"
        echo ""
        echo "Actions disponibles:"
        echo "  status   - Afficher le statut des services"
        echo "  restart  - Redémarrer l'application"
        echo "  stop     - Arrêter l'application"
        echo "  start    - Démarrer l'application"
        echo "  logs     - Afficher les logs en temps réel"
        echo "  backup   - Créer une sauvegarde"
        echo "  update   - Mettre à jour l'application"
        echo "  clean    - Nettoyer les ressources Docker"
        echo ""
        echo "Exemple: $0 status"
        ;;
esac
