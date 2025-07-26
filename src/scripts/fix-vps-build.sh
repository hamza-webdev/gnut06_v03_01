#!/bin/bash

# Script pour corriger le problème de build sur le VPS
# Usage: ./fix-vps-build.sh

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"

echo "🔧 Correction du problème de build sur le VPS"
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

echo "🔗 Connexion au VPS..."
run_ssh "echo 'Connexion réussie'"

echo ""
echo "📍 Vérification du répertoire actuel..."
run_ssh "pwd && ls -la $VPS_DIR/"

echo ""
echo "🗑️ Nettoyage complet des dépendances..."
run_ssh "cd $VPS_DIR && rm -rf node_modules package-lock.json"

echo ""
echo "🔍 Vérification de Node.js et npm..."
run_ssh "node --version && npm --version"

echo ""
echo "📦 Réinstallation des dépendances..."
run_ssh "cd $VPS_DIR && npm cache clean --force"
run_ssh "cd $VPS_DIR && npm install"

echo ""
echo "🔧 Installation spécifique de Rollup pour Linux..."
run_ssh "cd $VPS_DIR && npm install @rollup/rollup-linux-x64-gnu --save-dev"

echo ""
echo "🔍 Vérification des dépendances installées..."
run_ssh "cd $VPS_DIR && ls -la node_modules/@rollup/ | head -10"

echo ""
echo "🚀 Test du build..."
if run_ssh "cd $VPS_DIR && npm run build"; then
    echo "✅ Build réussi sur le VPS!"
    
    echo ""
    echo "📊 Vérification du résultat..."
    run_ssh "cd $VPS_DIR && ls -la dist/ | head -10"
    run_ssh "cd $VPS_DIR && du -sh dist"
else
    echo "❌ Build encore en échec"
    echo ""
    echo "💡 Solutions alternatives:"
    echo "   1. Utilisez le build local: ./build-and-copy.sh"
    echo "   2. Ou essayez avec une version différente de Node.js"
    echo ""
    echo "🔍 Informations de debug:"
    run_ssh "cd $VPS_DIR && npm ls rollup"
    run_ssh "cd $VPS_DIR && npm ls @rollup/rollup-linux-x64-gnu"
fi

echo ""
echo "🏁 Script de correction terminé"
