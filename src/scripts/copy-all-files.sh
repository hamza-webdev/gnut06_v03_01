#!/bin/bash

# Script pour copier tous les fichiers nécessaires vers le VPS
# Usage: ./copy-all-files.sh

set -e

# Configuration VPS
VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
DEST_DIR="/home/vpsadmin/gnut06"

# Fichiers et dossiers à copier
FILES_TO_COPY=(
    "./dist"
    "./src"
    "./vite.config.ts"
    "./package.json"
    "./package-lock.json"
)

echo "📁 Copie de tous les fichiers vers le VPS"
echo "🎯 Destination: $VPS_USER@$VPS_IP:$DEST_DIR"
echo "⚠️  Les anciens fichiers seront écrasés"
echo ""

# Fonction SSH avec mot de passe
run_ssh() {
    if command -v sshpass &> /dev/null; then
        sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
    else
        echo "🔐 Exécution sur le VPS: $1"
        ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
    fi
}

# Fonction de copie avec mot de passe
copy_files() {
    if command -v sshpass &> /dev/null; then
        sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
    else
        echo "📤 Copie: $1 -> $2"
        scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
    fi
}

echo "🔗 Test de connexion au VPS..."
if run_ssh "echo 'Connexion réussie'"; then
    echo "✅ Connexion SSH OK"
else
    echo "❌ Erreur de connexion SSH"
    exit 1
fi

echo ""
echo "📁 Création/préparation du répertoire de destination..."
run_ssh "mkdir -p $DEST_DIR"
echo "✅ Répertoire préparé"

echo ""
echo "📊 Vérification des fichiers locaux..."
for item in "${FILES_TO_COPY[@]}"; do
    if [ -e "$item" ]; then
        if [ -d "$item" ]; then
            size=$(du -sh "$item" | cut -f1)
            files=$(find "$item" -type f | wc -l)
            echo "✅ $item (dossier: $size, $files fichiers)"
        else
            size=$(du -sh "$item" | cut -f1)
            echo "✅ $item (fichier: $size)"
        fi
    else
        echo "❌ $item (non trouvé)"
        echo "⚠️  Continuons avec les autres fichiers..."
    fi
done

echo ""
echo "🗑️ Suppression des anciens fichiers sur le VPS..."
for item in "${FILES_TO_COPY[@]}"; do
    filename=$(basename "$item")
    echo "Suppression de $filename..."
    run_ssh "rm -rf $DEST_DIR/$filename" || echo "Fichier $filename n'existait pas"
done
echo "✅ Anciens fichiers supprimés"

echo ""
echo "📤 Copie des fichiers vers le VPS..."

# Copie de chaque élément
for item in "${FILES_TO_COPY[@]}"; do
    if [ -e "$item" ]; then
        filename=$(basename "$item")
        echo ""
        echo "📦 Copie de $item..."
        
        if [ -d "$item" ]; then
            # Pour les dossiers, créer une archive pour une copie plus rapide
            echo "  📁 Création d'une archive pour le dossier..."
            tar -czf "${filename}.tar.gz" -C "$(dirname "$item")" "$(basename "$item")"
            
            echo "  📤 Copie de l'archive..."
            if copy_files "${filename}.tar.gz" "$DEST_DIR/"; then
                echo "  ✅ Archive copiée"
                echo "  📂 Extraction sur le VPS..."
                run_ssh "cd $DEST_DIR && tar -xzf ${filename}.tar.gz && rm ${filename}.tar.gz"
                echo "  ✅ Archive extraite et supprimée"
                rm "${filename}.tar.gz"
            else
                echo "  ❌ Échec de copie de l'archive"
                rm "${filename}.tar.gz"
                echo "  💡 Essai de copie directe..."
                if copy_files "$item" "$DEST_DIR/"; then
                    echo "  ✅ Copie directe réussie"
                else
                    echo "  ❌ Échec de copie directe pour $item"
                fi
            fi
        else
            # Pour les fichiers, copie directe
            if copy_files "$item" "$DEST_DIR/"; then
                echo "  ✅ Fichier copié"
            else
                echo "  ❌ Échec de copie pour $item"
            fi
        fi
    else
        echo "⚠️  $item non trouvé, ignoré"
    fi
done

echo ""
echo "🔍 Vérification des fichiers copiés..."
run_ssh "ls -la $DEST_DIR/"

echo ""
echo "📊 Détails des dossiers copiés..."
for item in "${FILES_TO_COPY[@]}"; do
    filename=$(basename "$item")
    if [ -d "$item" ]; then
        echo ""
        echo "📁 Contenu de $filename:"
        run_ssh "ls -la $DEST_DIR/$filename/ | head -10"
        run_ssh "du -sh $DEST_DIR/$filename"
    fi
done

echo ""
echo "📈 Statistiques finales..."
run_ssh "du -sh $DEST_DIR"
run_ssh "find $DEST_DIR -type f | wc -l | xargs echo 'Total de fichiers copiés:'"

echo ""
echo "✅ Copie de tous les fichiers terminée avec succès!"
echo "📍 Emplacement sur le VPS: $DEST_DIR"
echo ""
echo "🔍 Fichiers et dossiers copiés:"
for item in "${FILES_TO_COPY[@]}"; do
    filename=$(basename "$item")
    echo "   - $DEST_DIR/$filename"
done

echo ""
echo "🔍 Commandes utiles pour vérifier:"
echo "   # Connexion au VPS:"
echo "   ssh $VPS_USER@$VPS_IP"
echo ""
echo "   # Voir tous les fichiers:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/'"
echo ""
echo "   # Voir le contenu du dossier src:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/src/'"
echo ""
echo "   # Voir le contenu du dossier dist:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/dist/'"
