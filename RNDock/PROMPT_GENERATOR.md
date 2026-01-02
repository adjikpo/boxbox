# Prompt - Generateur d'Architecture Docker pour React Native/Expo

Utilise ce prompt avec un assistant IA pour generer l'architecture Docker complete.

---

## PROMPT A COPIER

```
Cree une architecture Docker pour containeriser un projet React Native avec Expo.

### Nom du projet : [NOM_DU_PROJET]

### Structure de fichiers a generer :

1. **Dockerfile** - Image Node 20 Alpine avec :
   - Dependances : git, bash, curl, python3, make, g++
   - Workdir : /app
   - Ports exposes : 8081, 19000, 19001, 19002, 19006
   - CMD par defaut : sh

2. **docker-compose.yml** - Services :
   - **expo** : service principal React Native/Expo
     - Build depuis le Dockerfile local
     - Working_dir : /app/[NOM_DU_PROJET]
     - Command : npx expo start --lan
     - Volumes : code source + node_modules persiste
     - Ports : 19000, 19001, 19002, 19006, 8081
     - Environment : EXPO_DEVTOOLS_LISTEN_ADDRESS=0.0.0.0, REACT_NATIVE_PACKAGER_HOSTNAME=0.0.0.0
     - stdin_open et tty : true

   - **cli** : service pour commandes ponctuelles (npm install, etc.)
     - Meme image que expo
     - Working_dir : /app
     - Volumes partages avec expo (incluant node_modules)

   - **create** : service dedie a la creation de projet (IMPORTANT)
     - Meme image que expo
     - Working_dir : /app
     - Volumes : SEULEMENT le code source (PAS de volume node_modules)
     - Ce service evite le conflit avec le volume node_modules lors de la creation

   - Network : app-network (bridge)
   - Volume nomme : expo_node_modules

3. **Makefile** avec commandes :
   - help : affiche l'aide
   - build : docker-compose build
   - up : docker-compose up -d
   - dev : docker-compose up (foreground)
   - down : docker-compose down
   - stop : docker-compose stop
   - install : docker-compose run --rm cli sh -c "cd [NOM_DU_PROJET] && npm install"
   - shell : docker-compose exec expo sh
   - logs : docker-compose logs -f
   - clean : docker-compose down -v
   - prune : nettoyage complet
   - create-project : docker-compose run --rm create npx create-expo-app (utilise le service "create")
   - add-package : ajouter un package npm
   - tunnel : lancer en mode tunnel
   - web : lancer en mode web
   - restart : redemarrer les services

4. **.dockerignore** - Exclure :
   - .git, node_modules, .env, logs, build, dist, .expo, IDE files

5. **.gitignore** - Exclure :
   - node_modules, .env, .expo, coverage, dist, build, IDE files, OS files

### Commandes Docker pour creer le projet :

Genere aussi les commandes a executer dans l'ordre :

1. Construire l'image Docker
2. Nettoyer les volumes existants si necessaire (make clean)
3. Creer un nouveau projet Expo via le service "create" (sans volume node_modules)
4. Installer les dependances
5. Lancer le serveur de developpement

Format des commandes :
- Utiliser docker-compose run --rm create pour la creation de projet
- Utiliser docker-compose run --rm cli pour les commandes npm
- Utiliser make pour simplifier l'usage quotidien
```

---

## EXEMPLE D'UTILISATION

Remplace `[NOM_DU_PROJET]` par le nom de ton projet, exemple : `App`

---

## COMMANDES DOCKER DE BASE

Une fois l'architecture generee, voici les commandes a executer :

```bash
# 1. Construire l'image Docker
make build

# 2. Nettoyer les volumes et dossiers existants (si necessaire)
make clean && rm -rf [NOM_DU_PROJET]

# 3. Creer un nouveau projet Expo (utilise le service "create" sans volume node_modules)
make create-project

# 4. Installer les dependances
make install

# 5. Lancer le serveur de dev
make dev
```

---

## COMMANDES UTILES AU QUOTIDIEN

```bash
# Demarrer en arriere-plan
make up

# Voir les logs
make logs

# Acceder au shell du container
make shell

# Arreter les services
make down

# Nettoyer tout (attention : supprime node_modules)
make clean

# Installer un package npm
make add-package PKG=nom-du-package

# Lancer Expo en mode tunnel (si LAN ne fonctionne pas)
make tunnel

# Lancer en mode web
make web

# Redemarrer les services
make restart
```

---

## POURQUOI UN SERVICE "CREATE" SEPARE ?

Le volume `expo_node_modules` est monte sur `/app/[NOM_DU_PROJET]/node_modules` pour persister les dependances.

**Probleme** : Si ce volume existe deja lors de la creation du projet, `create-expo-app` detecte un dossier `node_modules` et refuse de creer le projet.

**Solution** : Le service `create` ne monte PAS le volume `node_modules`, permettant une creation propre du projet.

---

## ACCES

- **Expo DevTools (Web)** : http://localhost:19002
- **Metro Bundler** : http://localhost:8081
- **App Web** : http://localhost:19006

Scanner le QR code dans les logs pour ouvrir sur mobile (Expo Go).
