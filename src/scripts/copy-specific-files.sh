#!/bin/bash

# Script pour copier des fichiers spécifiques vers le VPS
# Usage: ./copy-specific-files.sh

set -e

# Configuration VPS
VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
DEST_DIR="/home/vpsadmin/gnut06"

# Fichiers à copier
FILES_TO_COPY=(
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

# Dossiers à copier
FOLDERS_TO_COPY=(
    "src"
    "public"
)

echo "📁 Copie de fichiers spécifiques vers le VPS"
echo "🎯 Destination: $VPS_USER@$VPS_IP:$DEST_DIR"
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

echo "🔗 Test de connexion au VPS..."
run_ssh "echo 'Connexion réussie'"
echo "✅ Connexion OK"

echo ""
echo "📊 Vérification des fichiers locaux..."
echo ""
echo "Fichiers à copier:"
for file in "${FILES_TO_COPY[@]}"; do
    if [ -f "./$file" ]; then
        size=$(du -sh "./$file" | cut -f1)
        echo "  ✅ $file ($size)"
    else
        echo "  ❌ $file (non trouvé)"
    fi
done

echo ""
echo "Dossiers à copier:"
for folder in "${FOLDERS_TO_COPY[@]}"; do
    if [ -d "./$folder" ]; then
        size=$(du -sh "./$folder" | cut -f1)
        files=$(find "./$folder" -type f | wc -l)
        echo "  ✅ $folder ($size, $files fichiers)"
    else
        echo "  ❌ $folder (non trouvé)"
    fi
done

echo ""
echo "📤 Copie des fichiers individuels..."
for file in "${FILES_TO_COPY[@]}"; do
    if [ -f "./$file" ]; then
        echo "Copie de $file..."
        copy_files "./$file" "$DEST_DIR/"
        echo "  ✅ $file copié"
    else
        echo "  ⚠️  $file ignoré (non trouvé)"
    fi
done

echo ""
echo "📂 Copie des dossiers..."
for folder in "${FOLDERS_TO_COPY[@]}"; do
    if [ -d "./$folder" ]; then
        echo "Copie du dossier $folder..."
        
        # Supprimer l'ancien dossier sur le VPS
        run_ssh "rm -rf $DEST_DIR/$folder"
        
        # Créer une archive pour une copie plus rapide
        echo "  📦 Création d'une archive..."
        tar -czf "${folder}.tar.gz" "$folder"
        
        echo "  📤 Copie de l'archive..."
        copy_files "${folder}.tar.gz" "$DEST_DIR/"
        
        echo "  📂 Extraction sur le VPS..."
        run_ssh "cd $DEST_DIR && tar -xzf ${folder}.tar.gz && rm ${folder}.tar.gz"
        
        # Supprimer l'archive locale
        rm "${folder}.tar.gz"
        
        echo "  ✅ $folder copié"
    else
        echo "  ⚠️  $folder ignoré (non trouvé)"
    fi
done

echo ""
echo "🔍 Vérification des fichiers copiés..."
run_ssh "ls -la $DEST_DIR/"

echo ""
echo "📊 Vérification des dossiers copiés..."
for folder in "${FOLDERS_TO_COPY[@]}"; do
    if [ -d "./$folder" ]; then
        echo ""
        echo "📁 Contenu de $folder (premiers 10 éléments):"
        run_ssh "ls -la $DEST_DIR/$folder/ | head -10"
        echo "📏 Taille de $folder:"
        run_ssh "du -sh $DEST_DIR/$folder"
    fi
done

echo ""
echo "📈 Statistiques finales..."
run_ssh "du -sh $DEST_DIR"
run_ssh "find $DEST_DIR -type f | wc -l | xargs echo 'Total de fichiers:'"

echo ""
echo "✅ Copie terminée avec succès!"
echo ""
echo "📋 Fichiers copiés:"
for file in "${FILES_TO_COPY[@]}"; do
    echo "   - $DEST_DIR/$file"
done

echo ""
echo "📂 Dossiers copiés:"
for folder in "${FOLDERS_TO_COPY[@]}"; do
    echo "   - $DEST_DIR/$folder/"
done

echo ""
echo "🔍 Commandes utiles:"
echo "   # Voir tous les fichiers:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/'"
echo ""
echo "   # Voir le contenu du dossier src:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/src/'"
echo ""
echo "   # Voir le contenu du dossier public:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/public/'"
echo ""
echo "   # Installer les dépendances sur le VPS:"
echo "   ssh $VPS_USER@$VPS_IP 'cd $DEST_DIR && npm install'"
