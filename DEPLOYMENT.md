# Guide de Déploiement - Application gnut06

## 📋 Prérequis

### Sur votre machine locale
- Node.js 18+ installé
- npm ou yarn
- sshpass installé (pour le déploiement automatique)
- Git

### Sur le VPS (167.86.93.157)
- ✅ Docker installé
- ✅ Docker Compose installé  
- ✅ Nginx installé
- ✅ Certbot (Let's Encrypt) installé
- Accès sudo pour l'utilisateur vpsadmin

## 🚀 Déploiement Rapide

### Option 1: Déploiement automatique avec sshpass
```bash
# Installer sshpass si nécessaire (Ubuntu/Debian)
sudo apt-get install sshpass

# Lancer le déploiement
./deploy.sh
```

### Option 2: Déploiement interactif (sans sshpass)
```bash
# Si sshpass n'est pas disponible
./deploy-interactive.sh
# Vous devrez saisir le mot de passe plusieurs fois
```

### Option 3: Déploiement sécurisé avec clé SSH (Recommandé)
```bash
# 1. Configurer la clé SSH (une seule fois)
ssh-copy-id vpsadmin@167.86.93.157

# 2. Lancer le déploiement sécurisé
./deploy-secure.sh
```

## 📁 Structure des Fichiers

```
gnut06/
├── Dockerfile              # Configuration Docker multi-stage
├── docker-compose.yml      # Orchestration des services
├── nginx.conf              # Config Nginx pour le container
├── nginx-vps.conf          # Config Nginx pour le VPS avec SSL
├── deploy.sh               # Script de déploiement automatique (avec sshpass)
├── deploy-interactive.sh   # Script de déploiement interactif (sans sshpass)
├── deploy-secure.sh        # Script de déploiement sécurisé (clé SSH)
├── maintenance.sh          # Script de maintenance
├── healthcheck.sh          # Script de vérification
├── setup-local.sh          # Installation des prérequis
├── .env.production         # Variables d'environnement
├── .dockerignore           # Fichiers ignorés par Docker
└── DEPLOYMENT.md           # Cette documentation
```

## 🔧 Configuration Manuelle (si nécessaire)

### 1. Configuration DNS
Assurez-vous que `gnut06.zidani.org` pointe vers `167.86.93.157`

### 2. Configuration Nginx sur le VPS
```bash
# Copier la configuration
sudo cp nginx-vps.conf /etc/nginx/sites-available/gnut06.zidani.org

# Activer le site
sudo ln -s /etc/nginx/sites-available/gnut06.zidani.org /etc/nginx/sites-enabled/

# Tester la configuration
sudo nginx -t

# Recharger Nginx
sudo systemctl reload nginx
```

### 3. Configuration SSL
```bash
# Obtenir le certificat SSL
sudo certbot --nginx -d gnut06.zidani.org --email admin@zidani.org

# Vérifier le renouvellement automatique
sudo certbot renew --dry-run
```

## 🐳 Commandes Docker Utiles

```bash
# Se connecter au VPS
ssh vpsadmin@167.86.93.157

# Voir les containers en cours
docker ps

# Voir les logs de l'application
cd gnut06 && docker-compose logs -f

# Redémarrer l'application
cd gnut06 && docker-compose restart

# Arrêter l'application
cd gnut06 && docker-compose down

# Reconstruire et redémarrer
cd gnut06 && docker-compose up -d --build

# Nettoyer les images inutilisées
docker system prune -f
```

## 🔍 Vérification et Monitoring

### Script de vérification automatique
```bash
./healthcheck.sh
```

### Vérifications manuelles
```bash
# Test de l'application
curl -I https://gnut06.zidani.org

# Vérifier le certificat SSL
openssl s_client -connect gnut06.zidani.org:443 -servername gnut06.zidani.org

# Vérifier les logs Nginx
sudo tail -f /var/log/nginx/gnut06.zidani.org.access.log
sudo tail -f /var/log/nginx/gnut06.zidani.org.error.log
```

## 🛠️ Dépannage

### L'application ne démarre pas
```bash
# Vérifier les logs Docker
cd gnut06 && docker-compose logs

# Vérifier l'espace disque
df -h

# Vérifier la mémoire
free -h
```

### Problèmes SSL
```bash
# Renouveler le certificat
sudo certbot renew

# Vérifier la configuration Nginx
sudo nginx -t
```

### Port 3002 non accessible
```bash
# Vérifier que le port est ouvert
netstat -tuln | grep 3002

# Vérifier le firewall
sudo ufw status
```

## 📊 Informations de Déploiement

- **Domaine**: gnut06.zidani.org
- **IP VPS**: 167.86.93.157
- **Port interne**: 3002
- **Utilisateur**: vpsadmin
- **Répertoire**: ~/gnut06
- **SSL**: Let's Encrypt (renouvellement automatique)

## 🔄 Mise à Jour

Pour mettre à jour l'application :
1. Modifier le code localement
2. Relancer `./deploy.sh` ou `./deploy-secure.sh`
3. Le script s'occupe de tout automatiquement

## 🔐 Sécurité

### Recommandations de sécurité
- Utilisez `deploy-secure.sh` avec clés SSH plutôt que des mots de passe
- Changez régulièrement les mots de passe
- Surveillez les logs d'accès
- Mettez à jour régulièrement le système et Docker

### Sauvegarde
```bash
# Sauvegarder la configuration
scp -r vpsadmin@167.86.93.157:~/gnut06 ./backup-$(date +%Y%m%d)
```

## 📞 Support

En cas de problème, vérifiez :
1. Les logs Docker : `docker-compose logs`
2. Les logs Nginx : `/var/log/nginx/gnut06.zidani.org.error.log`
3. L'état des services : `systemctl status nginx docker`
4. Utilisez le script `./healthcheck.sh` pour un diagnostic complet
