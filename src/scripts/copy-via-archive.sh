#!/bin/bash

# Script de copie via archive unique (évite les problèmes de connexion multiples)
# Usage: ./copy-via-archive.sh

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

echo "📦 Copie via archive unique (méthode la plus fiable)"
echo "🎯 Destination: $VPS_USER@$VPS_IP:$DEST_DIR"
echo ""

# Fonction SSH simple
run_ssh() {
    if command -v sshpass &> /dev/null; then
        sshpass -p "$VPS_PASSWORD" ssh -o ConnectTimeout=30 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
    else
        echo "🔐 Exécution sur le VPS: $1"
        ssh -o ConnectTimeout=30 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
    fi
}

# Fonction de copie simple
copy_file() {
    if command -v sshpass &> /dev/null; then
        sshpass -p "$VPS_PASSWORD" scp -o ConnectTimeout=30 -o StrictHostKeyChecking=no "$1" "$VPS_USER@$VPS_IP:$2"
    else
        echo "📤 Copie: $1 -> $2"
        scp -o ConnectTimeout=30 -o StrictHostKeyChecking=no "$1" "$VPS_USER@$VPS_IP:$2"
    fi
}

echo "🔗 Test de connexion..."
run_ssh "echo 'Connexion OK'"

echo ""
echo "📊 Vérification des fichiers locaux..."
missing_files=0

echo "Fichiers:"
for file in "${FILES_TO_COPY[@]}"; do
    if [ -f "./$file" ]; then
        size=$(du -sh "./$file" | cut -f1)
        echo "  ✅ $file ($size)"
    else
        echo "  ❌ $file (manquant)"
        missing_files=$((missing_files + 1))
    fi
done

echo ""
echo "Dossiers:"
for folder in "${FOLDERS_TO_COPY[@]}"; do
    if [ -d "./$folder" ]; then
        size=$(du -sh "./$folder" | cut -f1)
        files=$(find "./$folder" -type f | wc -l)
        echo "  ✅ $folder ($size, $files fichiers)"
    else
        echo "  ❌ $folder (manquant)"
        missing_files=$((missing_files + 1))
    fi
done

if [ $missing_files -gt 0 ]; then
    echo ""
    echo "⚠️  $missing_files fichiers/dossiers manquants, mais on continue..."
fi

echo ""
echo "📦 Création d'une archive unique avec tous les fichiers..."

# Créer un répertoire temporaire
temp_dir="temp_copy_$(date +%s)"
mkdir "$temp_dir"

# Copier tous les fichiers dans le répertoire temporaire
echo "Préparation des fichiers..."
for file in "${FILES_TO_COPY[@]}"; do
    if [ -f "./$file" ]; then
        cp "./$file" "$temp_dir/"
        echo "  ✅ $file ajouté"
    fi
done

for folder in "${FOLDERS_TO_COPY[@]}"; do
    if [ -d "./$folder" ]; then
        cp -r "./$folder" "$temp_dir/"
        echo "  ✅ $folder ajouté"
    fi
done

# Créer l'archive
archive_name="gnut06_files_$(date +%Y%m%d_%H%M%S).tar.gz"
echo ""
echo "📦 Création de l'archive $archive_name..."
tar -czf "$archive_name" -C "$temp_dir" .

# Supprimer le répertoire temporaire
rm -rf "$temp_dir"

# Vérifier la taille de l'archive
archive_size=$(du -sh "$archive_name" | cut -f1)
echo "✅ Archive créée ($archive_size)"

echo ""
echo "📤 Copie de l'archive vers le VPS (une seule connexion)..."
if copy_file "$archive_name" "$DEST_DIR/"; then
    echo "✅ Archive copiée avec succès"
    
    echo ""
    echo "📂 Extraction de l'archive sur le VPS..."
    if run_ssh "cd $DEST_DIR && tar -xzf $archive_name && rm $archive_name"; then
        echo "✅ Archive extraite et supprimée"
    else
        echo "❌ Erreur lors de l'extraction"
        echo "💡 L'archive est sur le VPS, vous pouvez l'extraire manuellement:"
        echo "    ssh $VPS_USER@$VPS_IP 'cd $DEST_DIR && tar -xzf $archive_name'"
    fi
else
    echo "❌ Échec de copie de l'archive"
    echo ""
    echo "💡 Solutions alternatives:"
    echo "1. Vérifiez l'espace disque: ssh $VPS_USER@$VPS_IP 'df -h'"
    echo "2. Essayez avec rsync: rsync -avz $archive_name $VPS_USER@$VPS_IP:$DEST_DIR/"
    echo "3. Copiez manuellement: scp $archive_name $VPS_USER@$VPS_IP:$DEST_DIR/"
fi

# Supprimer l'archive locale
rm "$archive_name"

echo ""
echo "🔍 Vérification des fichiers copiés..."
run_ssh "ls -la $DEST_DIR/" || echo "Impossible de lister les fichiers"

echo ""
echo "📊 Vérification des dossiers..."
for folder in "${FOLDERS_TO_COPY[@]}"; do
    if [ -d "./$folder" ]; then
        echo ""
        echo "📁 Contenu de $folder:"
        run_ssh "ls -la $DEST_DIR/$folder/ | head -5" || echo "Dossier $folder non accessible"
    fi
done

echo ""
echo "📈 Statistiques finales..."
run_ssh "du -sh $DEST_DIR" || echo "Impossible de calculer la taille"

echo ""
echo "✅ Copie terminée!"
echo ""
echo "🎯 Avantages de cette méthode:"
echo "   - Une seule connexion SCP (plus fiable)"
echo "   - Archive compressée (plus rapide)"
echo "   - Moins de risques de déconnexion"
echo ""
echo "🔍 Vérifications:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/'"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/src/'"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/public/'"
