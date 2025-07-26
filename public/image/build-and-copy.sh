#!/bin/bash

# Script pour build local et copie vers le VPS
# Usage: ./build-and-copy.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
DEST_DIR="/home/vpsadmin/gnut06"

echo "🚀 Build local et copie vers le VPS"
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

# Fonction de copie
copy_files() {
    if command -v sshpass &> /dev/null; then
        sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
    else
        echo "📤 Copie: $1 -> $2"
        scp -o StrictHostKeyChecking=no -r "$1" "$VPS_USER@$VPS_IP:$2"
    fi
}

echo "📦 Étape 1: Build local"
echo "Nettoyage du build précédent..."
rm -rf dist/

echo "Build de l'application..."
npm run build

if [ ! -d "dist" ]; then
    echo "❌ Erreur: Le build a échoué, dossier dist non créé"
    exit 1
fi

echo "✅ Build local réussi"
echo "📊 Taille du build: $(du -sh dist | cut -f1)"
echo ""

echo "🔗 Étape 2: Test de connexion au VPS"
run_ssh "echo 'Connexion réussie'"
echo "✅ Connexion OK"

echo ""
echo "📁 Étape 3: Préparation du répertoire sur le VPS"
run_ssh "mkdir -p $DEST_DIR"

echo ""
echo "🗑️ Étape 4: Suppression de l'ancien build sur le VPS"
run_ssh "rm -rf $DEST_DIR/dist"

echo ""
echo "📤 Étape 5: Copie du nouveau build"
if copy_files "./dist" "$DEST_DIR/"; then
    echo "✅ Copie réussie"
else
    echo "❌ Erreur lors de la copie directe"
    echo "💡 Essai avec archive tar..."
    
    # Créer une archive
    tar -czf dist.tar.gz dist/
    echo "📦 Archive créée: $(du -sh dist.tar.gz | cut -f1)"
    
    if copy_files "dist.tar.gz" "$DEST_DIR/"; then
        echo "✅ Archive copiée"
        run_ssh "cd $DEST_DIR && tar -xzf dist.tar.gz && rm dist.tar.gz"
        echo "✅ Archive extraite"
        rm dist.tar.gz
    else
        echo "❌ Échec de copie"
        rm dist.tar.gz
        exit 1
    fi
fi

echo ""
echo "🔍 Étape 6: Vérification"
run_ssh "ls -la $DEST_DIR/dist/ | head -10"

echo ""
echo "📊 Statistiques finales:"
run_ssh "du -sh $DEST_DIR/dist"
run_ssh "find $DEST_DIR/dist -type f | wc -l | xargs echo 'Fichiers copiés:'"

echo ""
echo "✅ Build et copie terminés avec succès!"
echo "📍 Build disponible sur le VPS: $DEST_DIR/dist"
echo ""
echo "🐳 Prochaines étapes pour Docker:"
echo "   1. ssh $VPS_USER@$VPS_IP"
echo "   2. cd $DEST_DIR"
echo "   3. docker compose down && docker compose up -d --build"
