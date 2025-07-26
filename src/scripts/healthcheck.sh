#!/bin/bash

# Script de vérification de santé pour l'application gnut06
# Usage: ./healthcheck.sh

VPS_IP="167.86.93.157"
DOMAIN="gnut06.zidani.org"
PORT="3002"

echo "🔍 Vérification de la santé de l'application gnut06..."

# Test de connectivité au VPS
echo "📡 Test de connectivité au VPS..."
if ping -c 1 $VPS_IP > /dev/null 2>&1; then
    echo "✅ VPS accessible"
else
    echo "❌ VPS non accessible"
    exit 1
fi

# Test du container Docker
echo "🐳 Vérification du container Docker..."
if sshpass -p "Besmillah2025" ssh -o StrictHostKeyChecking=no vpsadmin@$VPS_IP "docker ps | grep gnut06-app" > /dev/null 2>&1; then
    echo "✅ Container Docker en cours d'exécution"
else
    echo "❌ Container Docker non trouvé ou arrêté"
fi

# Test du port local
echo "🔌 Test du port $PORT..."
if sshpass -p "Besmillah2025" ssh -o StrictHostKeyChecking=no vpsadmin@$VPS_IP "netstat -tuln | grep :$PORT" > /dev/null 2>&1; then
    echo "✅ Port $PORT ouvert"
else
    echo "❌ Port $PORT fermé"
fi

# Test HTTPS
echo "🔒 Test HTTPS..."
if curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN | grep -q "200\|301\|302"; then
    echo "✅ Site HTTPS accessible"
else
    echo "❌ Site HTTPS non accessible"
fi

# Test du certificat SSL
echo "🛡️ Vérification du certificat SSL..."
if openssl s_client -connect $DOMAIN:443 -servername $DOMAIN < /dev/null 2>/dev/null | openssl x509 -noout -dates 2>/dev/null; then
    echo "✅ Certificat SSL valide"
else
    echo "❌ Problème avec le certificat SSL"
fi

echo "🏁 Vérification terminée"
