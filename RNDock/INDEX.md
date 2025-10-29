# 📑 INDEX - Documentation RNDock

Guide complet des ressources disponibles dans ce dossier.

---

## 🎯 Accès rapide par besoin

### Je suis nouveau, comment démarrer ?
1. **Lire** : [`QUICKSTART.md`](./QUICKSTART.md) (5-10 min) ⭐
2. **Exécuter** : Les 5 étapes du Quick Start
3. **Troubleshoot** : Consulter le Troubleshooting du README

### Je veux comprendre l'architecture
1. **Lire** : [`ARCHITECTURE.md`](./ARCHITECTURE.md) (15 min)
   - Vue d'ensemble du projet
   - Structure des fichiers
   - Flux de données
   - Services Docker
   - Configuration

### Je dois créer un nouveau projet
1. **Lire** : [`TEMPLATE_NEW_PROJECT.md`](./TEMPLATE_NEW_PROJECT.md) (10 min)
2. **Suivre** : La procédure complète (7 étapes)
3. **Adapter** : docker-compose.yml et .env
4. **Tester** : Vérifier la checklist

### Je dois maintenir un projet existant
1. **Consulter** : [`README.md`](./README.md) - Section "Commandes essentielles"
2. **Utiliser** : `make help` pour les raccourcis
3. **Chercher** : Section Troubleshooting au besoin

### Je dois migrer un projet
1. **Lire** : [`TEMPLATE_NEW_PROJECT.md`](./TEMPLATE_NEW_PROJECT.md) - Section "Migration d'un projet existant"
2. **Copier** : Les fichiers Docker
3. **Adapter** : Les chemins et variables

### Je dois déployer en production
1. **Lire** : [`ARCHITECTURE.md`](./ARCHITECTURE.md) - Section "Scalabilité future"
2. **Consulter** : [`TEMPLATE_NEW_PROJECT.md`](./TEMPLATE_NEW_PROJECT.md) - Section "Mode production"
3. **Créer** : `docker-compose.prod.yml`

---

## 📚 Documentation complète

### 1. **QUICKSTART.md** ⭐ (Premier document à lire)
**Durée** : 5-10 minutes  
**Pour qui** : Développeurs qui lancent le projet pour la première fois  
**Contenu** :
- ✅ Prérequis (2 min)
- ✅ 5 étapes pour lancer l'app
- ✅ Vérification du fonctionnement
- ✅ Commandes essentielles
- ✅ Problèmes courants
- ✅ Checklist premier démarrage

---

### 2. **README.md** (Documentation complète)
**Durée** : 30 minutes (complet)  
**Pour qui** : Tous les développeurs (référence)  
**Contenu** :
- 🔧 Prérequis (OS, logiciels, versions)
- 🏗️ Architecture détaillée du projet
- 🚀 Installation & Démarrage (étape par étape)
- ⚙️ Configuration (variables, ports, .env)
- 🎯 Commandes essentielles (Makefile + Docker Compose)
- 🐛 Troubleshooting complet (10+ problèmes courants)
- 📦 Ajouter des dépendances
- 🔄 Migration vers un nouveau projet
- 🎨 Template pour nouveaux projets
- 💡 Bonnes pratiques

---

### 3. **ARCHITECTURE.md** (Vue technique)
**Durée** : 20 minutes  
**Pour qui** : Développeurs voulant comprendre le système  
**Contenu** :
- 📐 Vue d'ensemble avec diagrammes
- 📁 Structure des fichiers détaillée
  - Frontend (LedgerTrack/)
  - Backend (api/)
  - Docker
- 🔄 Flux de données
- 🐳 Services Docker détaillés
- 🗄️ Gestion des données (volumes, BD)
- 🔐 Configuration & Secrets
- 🚀 Cycle de déploiement
- 🔧 Dépendances principales
- 📊 Schéma d'authentification
- 🐛 Debugging & DevTools
- 📈 Scalabilité future

---

### 4. **TEMPLATE_NEW_PROJECT.md** (Créer un nouveau projet)
**Durée** : 20-30 minutes  
**Pour qui** : Développeurs créant un nouveau projet  
**Contenu** :
- 📋 Fichiers à copier
- 🚀 Procédure complète (7 étapes)
- ✅ Checklist avant de committer
- 📝 Customisations courantes
  - Changer noms de dossiers
  - Changer les ports
  - Ajouter des services (PostgreSQL, Redis)
  - Mode production
- 🔄 Migration d'un projet existant
- 🎯 Prochaines étapes

---

## 🗂️ Fichiers de configuration

### Fichiers Docker
```
Dockerfile           # Build image Node 20 Alpine (frontend)
api.Dockerfile      # Build image API (backend)
docker-compose.yml  # Orchestration services
.dockerignore       # Exclusions build Docker
```

### Fichiers de configuration
```
Makefile            # Raccourcis commandes (make help)
.gitignore          # Exclusions Git
api.env.example     # Template variables API (.env)
```

### Documentation
```
README.md                    # Documentation complète ⭐⭐⭐
QUICKSTART.md                # Démarrage rapide ⭐⭐
ARCHITECTURE.md              # Vue technique ⭐
TEMPLATE_NEW_PROJECT.md      # Créer nouveau projet ⭐
INDEX.md                     # Ce fichier
```

---

## 🚀 Chemins d'utilisation

### Scénario 1: Je suis développeur junior, c'est mon premier projet
```
1. QUICKSTART.md (lire)
2. docker-compose up
3. README.md (section Troubleshooting si besoin)
4. Make help (pour commandes utiles)
```

### Scénario 2: Je dois créer un nouveau projet
```
1. TEMPLATE_NEW_PROJECT.md (lire en entier)
2. Suivre les 7 étapes
3. ARCHITECTURE.md (comprendre la structure)
4. Développer le code
```

### Scénario 3: Je dois maintenir un projet existant
```
1. QUICKSTART.md (5 min reminder)
2. make help (utiliser les raccourcis)
3. README.md > Commandes essentielles (référence)
4. README.md > Troubleshooting (si problème)
```

### Scénario 4: Je dois déployer en production
```
1. ARCHITECTURE.md > Scalabilité future
2. TEMPLATE_NEW_PROJECT.md > Mode production
3. Créer docker-compose.prod.yml
4. Tester localement d'abord
```

### Scénario 5: Je dois migrer un vieux projet
```
1. TEMPLATE_NEW_PROJECT.md > Migration d'un projet existant
2. Copier fichiers Docker
3. Adapter docker-compose.yml
4. docker-compose build && docker-compose up
```

---

## 📊 Résumé des commandes

### Raccourcis Makefile (Recommandé)
```bash
make help              # Voir toutes les commandes
make build             # Construire images
make up                # Démarrer services (background)
make dev               # Démarrer services (foreground)
make logs              # Voir les logs
make restart           # Redémarrer
make clean             # Nettoyer tout
make shell-expo        # Shell container Expo
make shell-api         # Shell container API
```

### Docker Compose direct
```bash
docker-compose build                   # Builder
docker-compose up                      # Démarrer (foreground)
docker-compose up -d                   # Démarrer (background)
docker-compose ps                      # Voir containers
docker-compose logs -f                 # Logs (tous)
docker-compose logs -f expo            # Logs (Expo)
docker-compose restart                 # Redémarrer
docker-compose down                    # Arrêter
docker-compose down -v                 # Arrêter + supprimer volumes
docker-compose exec expo sh            # Shell Expo
docker-compose run --rm cli npm ...    # Commande ponctuelle
```

---

## ✅ Checklist rapide

Avant de commencer chaque session :

- [ ] Docker Desktop actif (`docker ps` fonctionne)
- [ ] Repo cloné et `cd` dedans
- [ ] `api/.env` existe (créé depuis `.env.example`)
- [ ] `docker-compose build` n'a pas d'erreurs
- [ ] `docker-compose up` lance les services
- [ ] API répond : `curl http://localhost:4000`
- [ ] Frontend visible : http://localhost:19006

---

## 🔗 Flux de documentation recommandé

```
Nouveau dev ?
├─ Lire QUICKSTART.md (5 min)
├─ Exécuter les 5 étapes
└─ Troubleshooting au besoin

Besoin de comprendre ?
├─ Lire ARCHITECTURE.md (15 min)
├─ Regarder les diagrammes
└─ Voir README.md pour détails

Créer un nouveau projet ?
├─ Lire TEMPLATE_NEW_PROJECT.md
├─ Suivre les 7 étapes
└─ Adapter configurations

Maintenir le projet ?
├─ `make help` (commandes)
├─ README.md > Commandes essentielles
└─ README.md > Troubleshooting

Aller en production ?
├─ ARCHITECTURE.md > Scalabilité future
├─ TEMPLATE_NEW_PROJECT.md > Production
└─ Créer docker-compose.prod.yml
```

---

## 📞 Aide supplémentaire

### Si vous êtes bloqué
1. ✅ Consulter README.md > Troubleshooting
2. ✅ Exécuter `docker-compose logs -f` (voir les erreurs)
3. ✅ Vérifier la checklist QUICKSTART.md
4. ✅ Nettoyer : `docker-compose down -v && docker-compose up --build`

### Ressources externes
- [Docker Docs](https://docs.docker.com)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Expo Documentation](https://docs.expo.dev)
- [React Native Guide](https://reactnative.dev)
- [Express.js Docs](https://expressjs.com)

---

## 📝 Notes

- ⭐⭐⭐ = Lecture hautement recommandée pour débuter
- ⭐⭐ = Important pour développement courant
- ⭐ = Référence au besoin
- Tous les temps de lecture sont approximatifs
- Consulter `.gitignore` pour exclure fichiers sensibles

---

## 🎯 TL;DR (Too Long; Didn't Read)

**Je veux juste lancer le projet :**
```bash
cp api/.env.example api/.env
docker-compose build
docker-compose up
# Puis ouvrir http://localhost:19006
```

**Je veux créer un nouveau projet :**
```bash
cp -r RNDock ~/MonProjet
cd ~/MonProjet
# Suivre TEMPLATE_NEW_PROJECT.md (7 étapes)
```

**Je suis bloqué :**
```bash
docker-compose logs -f
# Voir l'erreur, puis consulter README.md > Troubleshooting
```

---

**Documentation RNDock v1.0**  
*Dernière mise à jour : Oct 2024*  
*Node 20 Alpine | Expo 54 | React Native 0.81*
