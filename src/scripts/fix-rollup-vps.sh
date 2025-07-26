#!/bin/bash

# Script pour corriger définitivement le problème Rollup sur le VPS
# Usage: ./fix-rollup-vps.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"

echo "🔧 Correction définitive du problème Rollup sur le VPS"
echo "📍 Répertoire: $VPS_DIR"
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
echo "📍 Vérification du répertoire..."
run_ssh "cd $VPS_DIR && pwd && ls -la"

echo ""
echo "🗑️ ÉTAPE 1: Nettoyage complet"
echo "Suppression de node_modules et package-lock.json..."
run_ssh "cd $VPS_DIR && rm -rf node_modules package-lock.json"

echo ""
echo "🧹 Nettoyage du cache npm..."
run_ssh "npm cache clean --force"

echo ""
echo "🔍 ÉTAPE 2: Vérification de l'environnement"
echo "Version de Node.js:"
run_ssh "node --version"
echo "Version de npm:"
run_ssh "npm --version"
echo "Architecture du système:"
run_ssh "uname -m"

echo ""
echo "📦 ÉTAPE 3: Installation propre des dépendances"
echo "Installation avec npm install (sans cache)..."
run_ssh "cd $VPS_DIR && npm install --no-optional --force"

echo ""
echo "🔧 ÉTAPE 4: Installation spécifique de Rollup pour Linux"
echo "Installation du module Rollup Linux..."
run_ssh "cd $VPS_DIR && npm install @rollup/rollup-linux-x64-gnu --save-dev --force"

echo ""
echo "🔍 ÉTAPE 5: Vérification des installations"
echo "Vérification de Rollup:"
run_ssh "cd $VPS_DIR && npm ls rollup" || echo "Rollup non listé (normal si dans les dépendances de Vite)"

echo "Vérification du module Linux:"
run_ssh "cd $VPS_DIR && ls -la node_modules/@rollup/ | grep linux" || echo "Module Linux non trouvé"

echo ""
echo "🚀 ÉTAPE 6: Test du build"
echo "Tentative de build..."
if run_ssh "cd $VPS_DIR && npm run build"; then
    echo "✅ Build réussi!"
    echo ""
    echo "📊 Vérification du résultat:"
    run_ssh "cd $VPS_DIR && ls -la dist/ | head -10"
    run_ssh "cd $VPS_DIR && du -sh dist"
else
    echo "❌ Build encore en échec"
    echo ""
    echo "🔧 ÉTAPE 7: Solution alternative - Réinstallation complète"
    echo "Suppression complète et réinstallation..."
    
    run_ssh "cd $VPS_DIR && rm -rf node_modules package-lock.json"
    
    echo "Mise à jour de npm..."
    run_ssh "npm install -g npm@latest" || echo "Mise à jour npm échouée (permissions?)"
    
    echo "Installation avec npm ci..."
    run_ssh "cd $VPS_DIR && npm ci --force" || echo "npm ci échoué"
    
    echo "Installation manuelle de Vite et Rollup..."
    run_ssh "cd $VPS_DIR && npm install vite@latest @rollup/rollup-linux-x64-gnu --save-dev --force"
    
    echo "Nouveau test de build..."
    if run_ssh "cd $VPS_DIR && npm run build"; then
        echo "✅ Build réussi après réinstallation!"
    else
        echo "❌ Build toujours en échec"
        echo ""
        echo "💡 SOLUTION FINALE: Build local uniquement"
        echo "Le problème persiste. Recommandation:"
        echo "1. Faites le build sur votre machine locale: npm run build"
        echo "2. Copiez seulement le dossier dist vers le VPS"
        echo "3. Utilisez un Dockerfile simple qui copie juste dist/"
        echo ""
        echo "Commandes pour la solution finale:"
        echo "# Local:"
        echo "npm run build"
        echo "scp -r ./dist $VPS_USER@$VPS_IP:$VPS_DIR/"
        echo ""
        echo "# Sur le VPS:"
        echo "cd $VPS_DIR && docker compose up -d --build"
    fi
fi

echo ""
echo "📋 RÉSUMÉ:"
if run_ssh "cd $VPS_DIR && test -d dist && echo 'dist existe'" > /dev/null 2>&1; then
    echo "✅ Le build fonctionne sur le VPS"
    echo "🎯 Vous pouvez maintenant utiliser: docker compose up -d --build"
else
    echo "❌ Le build ne fonctionne pas sur le VPS"
    echo "🎯 Utilisez la solution de build local:"
    echo "   1. npm run build (local)"
    echo "   2. scp -r ./dist $VPS_USER@$VPS_IP:$VPS_DIR/"
    echo "   3. docker compose up -d --build (VPS)"
fi

echo ""
echo "🏁 Script de correction terminé"
