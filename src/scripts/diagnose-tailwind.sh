#!/bin/bash

# Script de diagnostic pour les problèmes Tailwind CSS
# Usage: ./diagnose-tailwind.sh

set -e

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
VPS_PASSWORD="Besmillah2025"
VPS_DIR="/home/vpsadmin/gnut06"

echo "🔍 Diagnostic des problèmes Tailwind CSS"
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

echo "🔗 Connexion au VPS..."
run_ssh "echo 'Connexion réussie'"

echo ""
echo "📊 DIAGNOSTIC LOCAL"
echo "==================="

echo ""
echo "1️⃣ Vérification de la configuration Tailwind locale:"
if [ -f "./tailwind.config.ts" ]; then
    echo "✅ tailwind.config.ts trouvé"
    echo "Contenu:"
    cat ./tailwind.config.ts
else
    echo "❌ tailwind.config.ts manquant"
fi

echo ""
echo "2️⃣ Vérification des dépendances Tailwind:"
if [ -f "./package.json" ]; then
    echo "Dépendances Tailwind dans package.json:"
    grep -E "(tailwind|@tailwindcss)" ./package.json || echo "Aucune dépendance Tailwind trouvée"
else
    echo "❌ package.json non trouvé"
fi

echo ""
echo "3️⃣ Vérification du fichier CSS principal:"
if [ -f "./src/index.css" ]; then
    echo "✅ src/index.css trouvé"
    echo "Contenu (premières lignes):"
    head -10 ./src/index.css
else
    echo "❌ src/index.css manquant"
fi

echo ""
echo "4️⃣ Test de build local:"
if [ -d "./dist" ]; then
    echo "✅ Dossier dist existe"
    echo "Fichiers CSS dans le build:"
    find ./dist -name "*.css" -exec ls -la {} \; || echo "Aucun fichier CSS trouvé"
    
    echo ""
    echo "Contenu d'un fichier CSS (premières lignes):"
    find ./dist -name "*.css" -exec head -5 {} \; || echo "Impossible de lire les fichiers CSS"
else
    echo "❌ Dossier dist manquant - faites npm run build"
fi

echo ""
echo "📊 DIAGNOSTIC VPS"
echo "================="

echo ""
echo "1️⃣ Vérification du container Docker:"
run_ssh "docker ps | grep gnut06" || echo "Container gnut06 non trouvé"

echo ""
echo "2️⃣ Vérification du port:"
run_ssh "netstat -tuln | grep :3002" || echo "Port 3002 non ouvert"
run_ssh "netstat -tuln | grep :8080" || echo "Port 8080 non ouvert"

echo ""
echo "3️⃣ Test de connectivité du container:"
run_ssh "curl -I http://localhost:3002 2>/dev/null | head -3" || echo "Container non accessible"

echo ""
echo "4️⃣ Vérification des fichiers dans le container:"
run_ssh "docker exec gnut06-app ls -la /usr/share/nginx/html/ | head -10" || echo "Impossible d'accéder au container"

echo ""
echo "5️⃣ Vérification des fichiers CSS dans le container:"
run_ssh "docker exec gnut06-app find /usr/share/nginx/html -name '*.css' -exec ls -la {} \;" || echo "Aucun fichier CSS dans le container"

echo ""
echo "6️⃣ Test de récupération d'une page:"
run_ssh "curl -s http://localhost:3002/ | head -20" || echo "Impossible de récupérer la page"

echo ""
echo "7️⃣ Recherche des liens CSS dans la page:"
run_ssh "curl -s http://localhost:3002/ | grep -o 'href=\"[^\"]*\.css[^\"]*\"'" || echo "Aucun lien CSS trouvé dans la page"

echo ""
echo "8️⃣ Vérification de la configuration Nginx du container:"
run_ssh "docker exec gnut06-app cat /etc/nginx/conf.d/default.conf" || echo "Configuration Nginx non accessible"

echo ""
echo "9️⃣ Logs du container:"
echo "Derniers logs du container:"
run_ssh "docker logs gnut06-app --tail 20" || echo "Logs non accessibles"

echo ""
echo "🔟 Test depuis l'extérieur:"
echo "Test HTTPS du site:"
curl -I https://gnut06.zidani.org 2>/dev/null | head -5 || echo "Site non accessible depuis l'extérieur"

echo ""
echo "Test de récupération de la page principale:"
curl -s https://gnut06.zidani.org 2>/dev/null | grep -o 'href=\"[^\"]*\.css[^\"]*\"' | head -3 || echo "Aucun CSS trouvé sur le site public"

echo ""
echo "📋 RÉSUMÉ DU DIAGNOSTIC"
echo "======================"

echo ""
echo "🔍 Points à vérifier:"
echo "   1. Le container Docker fonctionne-t-il sur le bon port ?"
echo "   2. Les fichiers CSS sont-ils présents dans le container ?"
echo "   3. La configuration Nginx sert-elle correctement les fichiers CSS ?"
echo "   4. Y a-t-il des erreurs dans les logs du container ?"
echo "   5. Le build local contient-il bien les styles Tailwind ?"

echo ""
echo "💡 Solutions possibles:"
echo "   - Si le container n'est pas sur le port 3002: ./fix-tailwind-deployment.sh"
echo "   - Si les CSS manquent dans le build: vérifier tailwind.config.ts et src/index.css"
echo "   - Si les CSS ne se chargent pas: problème de configuration Nginx"
echo "   - Si le site n'est pas accessible: problème de proxy Nginx VPS"

echo ""
echo "🏁 Diagnostic terminé"
