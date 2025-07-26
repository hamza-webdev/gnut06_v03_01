#!/bin/bash

# Script robuste pour copier des fichiers spécifiques vers le VPS
# Usage: ./copy-files-robust.sh

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

echo "📁 Copie robuste de fichiers vers le VPS"
echo "🎯 Destination: $VPS_USER@$VPS_IP:$DEST_DIR"
echo ""

# Options SSH robustes
SSH_OPTS="-o ConnectTimeout=30 -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no"

# Fonction SSH avec retry
run_ssh() {
    local cmd="$1"
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "🔄 SSH tentative $attempt/$max_attempts: $cmd"
        if ssh $SSH_OPTS "$VPS_USER@$VPS_IP" "$cmd"; then
            echo "✅ SSH réussi"
            return 0
        else
            echo "❌ SSH tentative $attempt échouée"
            if [ $attempt -lt $max_attempts ]; then
                echo "⏳ Attente de 5 secondes..."
                sleep 5
            fi
            attempt=$((attempt + 1))
        fi
    done
    
    echo "❌ Toutes les tentatives SSH ont échoué"
    return 1
}

# Fonction de copie avec retry et méthodes alternatives
copy_file_robust() {
    local src="$1"
    local dest="$2"
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "📤 Copie tentative $attempt/$max_attempts: $src"
        
        # Méthode 1: scp direct
        if scp $SSH_OPTS "$src" "$VPS_USER@$VPS_IP:$dest"; then
            echo "✅ Copie réussie (scp direct)"
            return 0
        fi
        
        echo "❌ scp direct échoué"
        
        # Méthode 2: rsync si disponible
        if command -v rsync &> /dev/null; then
            echo "💡 Essai avec rsync..."
            if rsync -avz -e "ssh $SSH_OPTS" "$src" "$VPS_USER@$VPS_IP:$dest"; then
                echo "✅ Copie réussie (rsync)"
                return 0
            fi
            echo "❌ rsync échoué"
        fi
        
        # Méthode 3: Copie via cat et SSH (pour les petits fichiers)
        if [ -f "$src" ] && [ $(stat -f%z "$src" 2>/dev/null || stat -c%s "$src" 2>/dev/null) -lt 1048576 ]; then
            echo "💡 Essai avec cat via SSH..."
            if cat "$src" | ssh $SSH_OPTS "$VPS_USER@$VPS_IP" "cat > $dest/$(basename "$src")"; then
                echo "✅ Copie réussie (cat via SSH)"
                return 0
            fi
            echo "❌ cat via SSH échoué"
        fi
        
        if [ $attempt -lt $max_attempts ]; then
            echo "⏳ Attente de 10 secondes avant nouvelle tentative..."
            sleep 10
        fi
        attempt=$((attempt + 1))
    done
    
    echo "❌ Toutes les méthodes de copie ont échoué pour: $src"
    return 1
}

echo "🔗 Test de connexion au VPS..."
run_ssh "echo 'Connexion réussie'"

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
        echo ""
        echo "📄 Copie de $file..."
        if copy_file_robust "./$file" "$DEST_DIR"; then
            echo "  ✅ $file copié avec succès"
        else
            echo "  ❌ Échec de copie pour $file"
            echo "  💡 Vous pouvez essayer manuellement:"
            echo "      scp ./$file $VPS_USER@$VPS_IP:$DEST_DIR/"
        fi
    else
        echo "  ⚠️  $file ignoré (non trouvé)"
    fi
done

echo ""
echo "📂 Copie des dossiers (méthode archive)..."
for folder in "${FOLDERS_TO_COPY[@]}"; do
    if [ -d "./$folder" ]; then
        echo ""
        echo "📁 Copie du dossier $folder..."
        
        # Supprimer l'ancien dossier sur le VPS
        run_ssh "rm -rf $DEST_DIR/$folder"
        
        # Créer une archive compressée
        echo "  📦 Création d'une archive compressée..."
        tar -czf "${folder}.tar.gz" "$folder"
        archive_size=$(du -sh "${folder}.tar.gz" | cut -f1)
        echo "  📊 Taille de l'archive: $archive_size"
        
        echo "  📤 Copie de l'archive..."
        if copy_file_robust "${folder}.tar.gz" "$DEST_DIR"; then
            echo "  ✅ Archive copiée"
            
            echo "  📂 Extraction sur le VPS..."
            if run_ssh "cd $DEST_DIR && tar -xzf ${folder}.tar.gz && rm ${folder}.tar.gz"; then
                echo "  ✅ Archive extraite et supprimée"
            else
                echo "  ❌ Erreur lors de l'extraction"
            fi
        else
            echo "  ❌ Échec de copie de l'archive"
        fi
        
        # Supprimer l'archive locale
        rm "${folder}.tar.gz"
        
    else
        echo "  ⚠️  $folder ignoré (non trouvé)"
    fi
done

echo ""
echo "🔍 Vérification finale..."
run_ssh "ls -la $DEST_DIR/"

echo ""
echo "📊 Statistiques finales..."
run_ssh "du -sh $DEST_DIR" || echo "Impossible de calculer la taille"
run_ssh "find $DEST_DIR -type f | wc -l | xargs echo 'Total de fichiers:'" || echo "Impossible de compter les fichiers"

echo ""
echo "✅ Script terminé!"
echo ""
echo "🔍 Commandes de vérification:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/'"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/src/'"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/public/'"
echo ""
echo "💡 Si certains fichiers n'ont pas pu être copiés:"
echo "   1. Vérifiez l'espace disque: ssh $VPS_USER@$VPS_IP 'df -h'"
echo "   2. Vérifiez la mémoire: ssh $VPS_USER@$VPS_IP 'free -h'"
echo "   3. Essayez la copie manuelle des fichiers qui ont échoué"
