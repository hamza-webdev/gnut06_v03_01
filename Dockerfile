# Servir l'application avec Nginx (build déjà fait localement)
FROM nginx:stable-alpine

# Copier le build depuis le répertoire local
COPY dist /usr/share/nginx/html

# Copier la configuration Nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
