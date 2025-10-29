# Multi-stage build pour React Native + Expo
FROM node:20-alpine

# Dépendances utiles pour développement et compilation native
RUN apk add --no-cache \
    git \
    bash \
    curl \
    python3 \
    make \
    g++

WORKDIR /app

# Expose ports Expo
EXPOSE 8081 19000 19001 19002 19006

# Mode par défaut : shell interactif
CMD ["sh"]
