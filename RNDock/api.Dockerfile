# Dockerfile pour le backend API Node.js/Express
FROM node:22-alpine

# Tools pour compiler les modules natifs (better-sqlite3, etc)
RUN apk add --no-cache \
    python3 \
    make \
    g++

WORKDIR /app

# Copier package.json et package-lock.json
COPY package.json package-lock.json* ./

# Installer les dépendances
RUN npm ci || npm install

# Copier le reste du code
COPY . .

# Expose API port
EXPOSE 4000

# Démarrer le serveur
CMD ["npm", "run", "start"]
