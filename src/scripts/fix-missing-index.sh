#!/bin/bash

# Script pour corriger le problème de index.html manquant sur le VPS
# Usage: ./fix-missing-index.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"

echo "🔧 Correction du problème index.html manquant"
echo "📍 VPS: $VPS_USER@$VPS_IP:$VPS_DIR"
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
        sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no "$1" "$VPS_USER@$VPS_IP:$2"
    else
        echo "📤 Copie: $1 -> $2"
        scp -o StrictHostKeyChecking=no "$1" "$VPS_USER@$VPS_IP:$2"
    fi
}

echo "🔍 DIAGNOSTIC: Vérification des fichiers sur le VPS"
echo "Contenu du répertoire $VPS_DIR:"
run_ssh "ls -la $VPS_DIR/"

echo ""
echo "Recherche du fichier index.html:"
run_ssh "find $VPS_DIR -name 'index.html' -type f" || echo "Aucun index.html trouvé"

echo ""
echo "Vérification des fichiers de configuration Vite:"
run_ssh "ls -la $VPS_DIR/ | grep -E '(vite|package|tsconfig)'" || echo "Fichiers de config non trouvés"

echo ""
echo "🔍 DIAGNOSTIC LOCAL: Vérification des fichiers locaux"
if [ -f "./index.html" ]; then
    echo "✅ index.html trouvé localement"
    echo "Contenu des premières lignes:"
    head -5 ./index.html
else
    echo "❌ index.html non trouvé localement"
fi

echo ""
echo "Autres fichiers importants locaux:"
ls -la . | grep -E "(index\.html|vite\.config|package\.json|tsconfig)" || echo "Fichiers manquants"

echo ""
echo "🔧 CORRECTION: Copie des fichiers manquants"

# Copier index.html s'il existe localement
if [ -f "./index.html" ]; then
    echo "📤 Copie de index.html..."
    copy_files "./index.html" "$VPS_DIR/"
    echo "✅ index.html copié"
else
    echo "❌ index.html non trouvé localement"
    echo "💡 Création d'un index.html basique..."
    
    # Créer un index.html basique
    cat > temp_index.html << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>gnut06</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF
    
    copy_files "temp_index.html" "$VPS_DIR/index.html"
    rm temp_index.html
    echo "✅ index.html basique créé et copié"
fi

# Copier vite.config.ts s'il manque
if [ -f "./vite.config.ts" ]; then
    echo "📤 Copie de vite.config.ts..."
    copy_files "./vite.config.ts" "$VPS_DIR/"
    echo "✅ vite.config.ts copié"
fi

# Copier les fichiers tsconfig s'ils manquent
for file in tsconfig.json tsconfig.app.json tsconfig.node.json; do
    if [ -f "./$file" ]; then
        echo "📤 Copie de $file..."
        copy_files "./$file" "$VPS_DIR/"
        echo "✅ $file copié"
    fi
done

echo ""
echo "🔍 VÉRIFICATION: Fichiers après correction"
run_ssh "ls -la $VPS_DIR/ | grep -E '(index\.html|vite\.config|tsconfig)'"

echo ""
echo "🚀 TEST: Tentative de build sur le VPS"
if run_ssh "cd $VPS_DIR && npm run build"; then
    echo "✅ Build réussi sur le VPS!"
    echo ""
    echo "📊 Vérification du résultat:"
    run_ssh "ls -la $VPS_DIR/dist/ | head -5"
    run_ssh "du -sh $VPS_DIR/dist"
else
    echo "❌ Build encore en échec"
    echo ""
    echo "💡 SOLUTION ALTERNATIVE: Build local recommandé"
    echo ""
    echo "Le problème persiste. Utilisez plutôt:"
    echo "1. ./deploy-docker-only.sh (build local + copie)"
    echo "2. Ou manuellement:"
    echo "   npm run build (local)"
    echo "   scp -r ./dist $VPS_USER@$VPS_IP:$VPS_DIR/"
    echo ""
    echo "🔍 Debug supplémentaire:"
    echo "Structure du répertoire VPS:"
    run_ssh "tree $VPS_DIR -L 2" || run_ssh "find $VPS_DIR -maxdepth 2 -type d"
    
    echo ""
    echo "Contenu de vite.config.ts sur le VPS:"
    run_ssh "cat $VPS_DIR/vite.config.ts" || echo "vite.config.ts non lisible"
fi

echo ""
echo "🏁 Diagnostic et correction terminés"
echo ""
echo "💡 RECOMMANDATION FINALE:"
echo "Si le build VPS ne fonctionne toujours pas, utilisez:"
echo "   ./deploy-docker-only.sh"
echo "Cette méthode évite tous les problèmes de build sur le VPS."
