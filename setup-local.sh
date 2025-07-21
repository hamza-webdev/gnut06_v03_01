#!/bin/bash

# Script d'installation des prérequis pour le déploiement de gnut06
# Usage: ./setup-local.sh

echo "🔧 Installation des prérequis pour le déploiement de gnut06..."

# Détection de l'OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    echo "📱 Système Linux détecté"
    
    # Ubuntu/Debian
    if command -v apt-get &> /dev/null; then
        echo "📦 Installation via apt-get..."
        sudo apt-get update
        sudo apt-get install -y sshpass curl openssl
    
    # CentOS/RHEL/Fedora
    elif command -v yum &> /dev/null; then
        echo "📦 Installation via yum..."
        sudo yum install -y sshpass curl openssl
    
    # Arch Linux
    elif command -v pacman &> /dev/null; then
        echo "📦 Installation via pacman..."
        sudo pacman -S --noconfirm sshpass curl openssl
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "🍎 Système macOS détecté"
    
    # Vérifier si Homebrew est installé
    if ! command -v brew &> /dev/null; then
        echo "🍺 Installation de Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    echo "📦 Installation via Homebrew..."
    brew install sshpass curl openssl

elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows (Git Bash/Cygwin)
    echo "🪟 Système Windows détecté"
    echo "⚠️  Pour Windows, vous devez installer manuellement :"
    echo "   - Git Bash (déjà installé si vous voyez ce message)"
    echo "   - OpenSSL (généralement inclus avec Git Bash)"
    echo "   - sshpass peut être remplacé par l'utilisation de clés SSH"
    echo ""
    echo "💡 Recommandation : Utilisez deploy-secure.sh avec des clés SSH"
fi

# Vérification des installations
echo ""
echo "🔍 Vérification des installations..."

if command -v sshpass &> /dev/null; then
    echo "✅ sshpass installé"
else
    echo "❌ sshpass non trouvé - utilisez deploy-secure.sh avec clés SSH"
fi

if command -v curl &> /dev/null; then
    echo "✅ curl installé"
else
    echo "❌ curl non trouvé"
fi

if command -v openssl &> /dev/null; then
    echo "✅ openssl installé"
else
    echo "❌ openssl non trouvé"
fi

if command -v node &> /dev/null; then
    echo "✅ Node.js installé ($(node --version))"
else
    echo "❌ Node.js non trouvé - veuillez l'installer depuis https://nodejs.org"
fi

if command -v npm &> /dev/null; then
    echo "✅ npm installé ($(npm --version))"
else
    echo "❌ npm non trouvé"
fi

echo ""
echo "🎯 Configuration des clés SSH (recommandé)..."
echo "Pour configurer l'authentification par clé SSH :"
echo "1. Générer une clé SSH : ssh-keygen -t rsa -b 4096"
echo "2. Copier la clé sur le VPS : ssh-copy-id vpsadmin@167.86.93.157"
echo "3. Utiliser deploy-secure.sh au lieu de deploy.sh"

echo ""
echo "✅ Configuration terminée !"
echo "🚀 Vous pouvez maintenant lancer le déploiement avec :"
echo "   ./deploy.sh (avec mot de passe)"
echo "   ou"
echo "   ./deploy-secure.sh (avec clé SSH - recommandé)"
