#!/bin/bash

# Script interactif pour copier le dossier src vers le VPS (sans sshpass)
# Usage: ./copy-src-interactive.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
SOURCE_DIR="./src"
DEST_DIR="/home/vpsadmin/gnut06"  

echo "📁 Copie interactive du dossier src vers le VPS"
echo "Source: $SOURCE_DIR"
echo "Destination: $VPS_USER@$VPS_IP:$DEST_DIR"
echo "⚠️  Vous devrez saisir le mot de passe SSH plusieurs fois"
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

# Fonction SSH interactive
run_ssh() {
    echo "🔐 Exécution sur le VPS: $1"
    ssh -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "$1"
}

# Fonction de copie interactive
copy_with_scp() {
    echo "📤 Copie: $1 -> $2"
    scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
}

echo "🔗 Test de connexion au VPS..."
run_ssh "echo 'Connexion réussie'"
echo "✅ Connexion SSH OK"

echo ""
echo "📁 Création du répertoire de destination sur le VPS..."
run_ssh "mkdir -p $DEST_DIR"
echo "✅ Répertoire créé"

echo ""
echo "📤 Copie du dossier src..."
echo "⚠️  Cette opération peut prendre du temps selon la taille du dossier"

if copy_with_scp "$SOURCE_DIR" "$DEST_DIR/"; then
    echo "✅ Copie réussie"
else
    echo "❌ Erreur lors de la copie directe"
    echo ""
    echo "💡 Essai avec une méthode alternative (tar + scp)..."
    
    # Créer une archive tar
    echo "📦 Création d'une archive tar..."
    tar -czf src.tar.gz -C . src/
    echo "✅ Archive créée: src.tar.gz ($(du -sh src.tar.gz | cut -f1))"
    
    echo ""
    echo "📤 Copie de l'archive (plus rapide)..."
    if copy_with_scp "src.tar.gz" "$DEST_DIR/"; then
        echo "✅ Archive copiée"
        
        echo ""
        echo "📂 Extraction de l'archive sur le VPS..."
        run_ssh "cd $DEST_DIR && tar -xzf src.tar.gz && rm src.tar.gz"
        echo "✅ Archive extraite et supprimée"
        
        # Supprimer l'archive locale
        rm src.tar.gz
        echo "✅ Archive locale supprimée"
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
echo "📂 Contenu du dossier src copié:"
run_ssh "ls -la $DEST_DIR/src/ | head -10"

echo ""
echo "📊 Statistiques finales:"
run_ssh "du -sh $DEST_DIR/src"
run_ssh "find $DEST_DIR/src -type f | wc -l | xargs echo 'Nombre de fichiers copiés:'"

echo ""
echo "✅ Copie du dossier src terminée avec succès!"
echo "📍 Emplacement sur le VPS: $DEST_DIR/src"
echo ""
echo "🔍 Commandes utiles:"
echo "   # Voir le contenu:"
echo "   ssh $VPS_USER@$VPS_IP 'ls -la $DEST_DIR/src'"
echo ""
echo "   # Voir la structure:"
echo "   ssh $VPS_USER@$VPS_IP 'tree $DEST_DIR/src' || ssh $VPS_USER@$VPS_IP 'find $DEST_DIR/src -type d'"
echo ""
echo "   # Voir les fichiers TypeScript/JavaScript:"
echo "   ssh $VPS_USER@$VPS_IP 'find $DEST_DIR/src -name \"*.ts\" -o -name \"*.tsx\" -o -name \"*.js\" -o -name \"*.jsx\"'"
