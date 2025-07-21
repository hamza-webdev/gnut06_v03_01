#!/bin/bash

# Script pour copier le dossier src vers le VPS
# Usage: ./copy-src.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
SOURCE_DIR="./src"
DEST_DIR="/home/vpsadmin/gnut06"

echo "📁 Copie du dossier src vers le VPS"
echo "Source: $SOURCE_DIR"
echo "Destination: $VPS_USER@$VPS_IP:$DEST_DIR"
echo ""

# Vérifier que le dossier src existe
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Erreur: Le dossier $SOURCE_DIR n'existe pas"
    exit 1
fi

echo "📊 Informations sur le dossier src:"
echo "Taille: $(du -sh $SOURCE_DIR | cut -f1)"
echo "Nombre de fichiers: $(find $SOURCE_DIR -type f | wc -l)"
echo ""

# Fonction SSH avec mot de passe
run_ssh() {
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
}

# Fonction de copie avec mot de passe
copy_with_scp() {
    sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
}

echo "🔗 Test de connexion au VPS..."
if run_ssh "echo 'Connexion réussie'"; then
    echo "✅ Connexion SSH OK"
else
    echo "❌ Erreur de connexion SSH"
    exit 1
fi

echo ""
echo "📁 Création du répertoire de destination sur le VPS..."
run_ssh "mkdir -p $DEST_DIR"
echo "✅ Répertoire créé"

echo ""
echo "📤 Copie du dossier src..."
if copy_with_scp "$SOURCE_DIR" "$DEST_DIR/"; then
    echo "✅ Copie réussie"
else
    echo "❌ Erreur lors de la copie"
    echo ""
    echo "💡 Essai avec une méthode alternative (tar + scp)..."
    
    # Créer une archive tar
    echo "📦 Création d'une archive tar..."
    tar -czf src.tar.gz -C . src/
    
    echo "📤 Copie de l'archive..."
    if copy_with_scp "src.tar.gz" "$DEST_DIR/"; then
        echo "✅ Archive copiée"
        
        echo "📂 Extraction de l'archive sur le VPS..."
        run_ssh "cd $DEST_DIR && tar -xzf src.tar.gz && rm src.tar.gz"
        
        echo "✅ Archive extraite et supprimée"
        rm src.tar.gz
    else
        echo "❌ Échec de copie de l'archive"
        rm src.tar.gz
        exit 1
    fi
fi

echo ""
echo "🔍 Vérification de la copie..."
run_ssh "ls -la $DEST_DIR/"
echo ""
run_ssh "ls -la $DEST_DIR/src/ | head -10"

echo ""
echo "📊 Statistiques finales:"
run_ssh "du -sh $DEST_DIR/src"
run_ssh "find $DEST_DIR/src -type f | wc -l | xargs echo 'Nombre de fichiers copiés:'"

echo ""
echo "✅ Copie du dossier src terminée avec succès!"
echo "📍 Emplacement sur le VPS: $DEST_DIR/src"
echo ""
echo "🔍 Pour vérifier:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/src'"
