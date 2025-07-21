#!/bin/bash

# Script de diagnostic pour identifier les problèmes de connexion
# Usage: ./diagnose.sh

VPS_IP="167.86.93.157"
VPS_USER="vpsadmin"
APP_DIR="gnut06"

echo "🔍 Diagnostic de connexion pour gnut06..."
echo ""

echo "1️⃣ Test de ping vers le VPS..."
if ping -c 3 $VPS_IP; then
    echo "✅ VPS accessible via ping"
else
    echo "❌ VPS non accessible via ping"
fi
echo ""

echo "2️⃣ Test de connexion SSH simple..."
if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "echo 'SSH OK'"; then
    echo "✅ Connexion SSH basique fonctionne"
else
    echo "❌ Connexion SSH basique échoue"
fi
echo ""

echo "3️⃣ Test de connexion SSH avec verbose..."
echo "Tentative de connexion SSH avec détails..."
ssh -v -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "echo 'SSH verbose OK'" 2>&1 | head -20
echo ""

echo "4️⃣ Test de l'espace disque sur le VPS..."
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "df -h" || echo "❌ Impossible de vérifier l'espace disque"
echo ""

echo "5️⃣ Test de la mémoire sur le VPS..."
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "free -h" || echo "❌ Impossible de vérifier la mémoire"
echo ""

echo "6️⃣ Vérification du répertoire home..."
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "pwd && ls -la ~/" || echo "❌ Impossible d'accéder au répertoire home"
echo ""

echo "7️⃣ Test de création d'un petit fichier..."
echo "test" > /tmp/test_file.txt
if scp -o ConnectTimeout=10 -o StrictHostKeyChecking=no /tmp/test_file.txt "$VPS_USER@$VPS_IP:~/test_upload.txt"; then
    echo "✅ Upload de petit fichier réussi"
    ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "rm -f ~/test_upload.txt"
else
    echo "❌ Upload de petit fichier échoué"
fi
rm -f /tmp/test_file.txt
echo ""

echo "8️⃣ Vérification de la taille du dossier dist..."
if [ -d "./dist" ]; then
    echo "Taille du dossier dist:"
    du -sh ./dist
    echo "Nombre de fichiers dans dist:"
    find ./dist -type f | wc -l
else
    echo "❌ Dossier dist non trouvé - exécutez 'npm run build' d'abord"
fi
echo ""

echo "9️⃣ Test de connexion SSH avec keepalive..."
ssh -o ConnectTimeout=10 -o ServerAliveInterval=60 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "echo 'SSH avec keepalive OK'" || echo "❌ SSH avec keepalive échoué"
echo ""

echo "🔟 Vérification des limites SSH du serveur..."
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VPS_USER@$VPS_IP" "sudo grep -i 'maxsessions\|maxstartups\|clientalive' /etc/ssh/sshd_config || echo 'Impossible de vérifier la config SSH'"
echo ""

echo "📊 Résumé du diagnostic terminé."
echo ""
echo "💡 Solutions possibles si des tests échouent:"
echo "   - Si ping échoue: Vérifier l'IP et la connectivité réseau"
echo "   - Si SSH échoue: Vérifier les identifiants et le service SSH"
echo "   - Si upload échoue: Problème d'espace disque ou de permissions"
echo "   - Si dist est trop gros: Essayer de copier par petits morceaux"
