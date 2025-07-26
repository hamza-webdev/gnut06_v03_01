#!/bin/bash

# Script pour copier tous les fichiers nécessaires au build sur le VPS
# Usage: ./copy-build-files.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06" 

# Fichiers nécessaires pour le build
BUILD_FILES=(
    "index.html"
    "vite.config.ts"
    "tsconfig.json"
    "tsconfig.app.json"
    "tsconfig.node.json"
    "package.json"
    "package-lock.json"
    "postcss.config.js"
    "tailwind.config.ts"
    "components.json"
)

echo "📁 Copie des fichiers nécessaires au build"
echo "🎯 Destination: $VPS_USER@$VPS_IP:$VPS_DIR"
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

echo "🔗 Test de connexion..."
run_ssh "echo 'Connexion OK'"

echo ""
echo "📁 Préparation du répertoire..."
run_ssh "mkdir -p $VPS_DIR"

echo ""
echo "📊 Vérification des fichiers locaux..."
for file in "${BUILD_FILES[@]}"; do
    if [ -f "./$file" ]; then
        size=$(du -sh "./$file" | cut -f1)
        echo "✅ $file ($size)"
    else
        echo "❌ $file (manquant)"
    fi
done

echo ""
echo "📤 Copie des fichiers de configuration..."
for file in "${BUILD_FILES[@]}"; do
    if [ -f "./$file" ]; then
        echo "Copie de $file..."
        copy_files "./$file" "$VPS_DIR/"
        echo "✅ $file copié"
    else
        echo "⚠️  $file ignoré (non trouvé)"
    fi
done

echo ""
echo "📂 Copie du dossier src (nécessaire pour le build)..."
if [ -d "./src" ]; then
    echo "Création d'une archive du dossier src..."
    tar -czf src.tar.gz src/
    
    echo "Copie de l'archive src..."
    copy_files "src.tar.gz" "$VPS_DIR/"
    
    echo "Extraction sur le VPS..."
    run_ssh "cd $VPS_DIR && tar -xzf src.tar.gz && rm src.tar.gz"
    
    rm src.tar.gz
    echo "✅ Dossier src copié"
else
    echo "❌ Dossier src non trouvé"
fi

echo ""
echo "📂 Copie du dossier public (si existe)..."
if [ -d "./public" ]; then
    echo "Copie du dossier public..."
    copy_files "./public" "$VPS_DIR/"
    echo "✅ Dossier public copié"
else
    echo "⚠️  Dossier public non trouvé (optionnel)"
fi

echo ""
echo "🔍 Vérification des fichiers copiés..."
run_ssh "ls -la $VPS_DIR/"

echo ""
echo "📊 Vérification de la structure..."
run_ssh "ls -la $VPS_DIR/src/ | head -5" || echo "Dossier src non accessible"

echo ""
echo "🔧 Installation/mise à jour des dépendances..."
run_ssh "cd $VPS_DIR && rm -rf node_modules package-lock.json"
run_ssh "cd $VPS_DIR && npm install"

echo ""
echo "🚀 Test du build sur le VPS..."
if run_ssh "cd $VPS_DIR && npm run build"; then
    echo "✅ Build réussi sur le VPS!"
    echo ""
    echo "📊 Résultat du build:"
    run_ssh "ls -la $VPS_DIR/dist/ | head -10"
    run_ssh "du -sh $VPS_DIR/dist"
    
    echo ""
    echo "🎉 Succès! Vous pouvez maintenant:"
    echo "   1. Utiliser le build sur le VPS directement"
    echo "   2. Ou lancer: ssh $VPS_USER@$VPS_IP 'cd $VPS_DIR && docker compose up -d --build'"
else
    echo "❌ Build encore en échec sur le VPS"
    echo ""
    echo "🔍 Debug - Contenu de index.html:"
    run_ssh "cat $VPS_DIR/index.html | head -10" || echo "index.html non lisible"
    
    echo ""
    echo "🔍 Debug - Configuration Vite:"
    run_ssh "cat $VPS_DIR/vite.config.ts" || echo "vite.config.ts non lisible"
    
    echo ""
    echo "💡 SOLUTION ALTERNATIVE:"
    echo "Le build sur VPS ne fonctionne pas. Utilisez plutôt:"
    echo "   ./deploy-docker-only.sh"
    echo ""
    echo "Cette méthode fait le build localement (où ça marche)"
    echo "et copie juste le résultat vers le VPS."
fi

echo ""
echo "✅ Script terminé"
echo ""
echo "📋 Fichiers copiés vers $VPS_DIR:"
for file in "${BUILD_FILES[@]}"; do
    echo "   - $file"
done
echo "   - src/ (dossier)"
echo "   - public/ (si existant)"
