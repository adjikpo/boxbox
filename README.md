# 🏎️ BoxBox - Automation Templates pour Docker 🐳

Templates complets et automatisés pour lancer rapidement des projets **React Native** et **Django** avec **Docker/Docker Compose**.

---

## 🎯 Vue d'ensemble

**BoxBox** contient deux templates production-ready :

### 🚀 **RNDock** - React Native + Docker
Template complet pour créer des projets **React Native + Express.js** avec Docker.
- ✅ Frontend Expo (React Native)
- ✅ Backend Express.js
- ✅ PostgreSQL
- ✅ Documentation exhaustive
- ✅ Makefile 20+ commandes

**Localisation** : `./RNDock/`

### 🐍 **DjangoDock** - Django + Docker
Script d'automatisation pour créer des projets **Django** containerisés.
- ✅ Django 4.2 LTS
- ✅ PostgreSQL 15
- ✅ Gunicorn
- ✅ Configuration interactive
- ✅ Makefile 20+ commandes

**Localisation** : `./DjangoDock/`

---

## 📂 Structure du dépôt

```
boxbox/
├── RNDock/                    # Template React Native + Docker
│   ├── README.md             # Documentation
│   ├── QUICKSTART.md         # Démarrage rapide
│   ├── ARCHITECTURE.md       # Architecture détaillée
│   ├── TEMPLATE_NEW_PROJECT.md
│   ├── INDEX.md              # Guide de navigation
│   ├── SUMMARY.md            # Synthèse
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── Makefile
│   └── (fichiers config)
│
├── DjangoDock/                # Template Django + Docker
│   ├── setup.sh              # Script d'initialisation (exécutable)
│   ├── README.md             # Documentation
│   ├── QUICKSTART.md         # Démarrage en 5 min
│   ├── GUIDE.md              # Guide détaillé
│   ├── RAPPORT_FINAL.txt     # Rapport technique
│   ├── INDEX.md              # Guide de navigation
│   └── (configuration)
│
└── README.md                  # Ce fichier
```

---

## 🚀 Démarrage rapide

### Créer un projet React Native + Docker

```bash
cd RNDock
lsof QUICKSTART.md
```

**Les 4 étapes** :
1. Lire `QUICKSTART.md` (5 min)
2. Adapter la structure (5 min)
3. `docker-compose build` (3-5 min)
4. `docker-compose up` (1 min)

→ Accéder à http://localhost:19006

### Créer un projet Django + Docker

```bash
cd DjangoDock
chmod +x setup.sh
./setup.sh
```

**Les 4 étapes** :
1. Configuration interactive (2 min)
2. `cd mon_projet` (1 min)
3. `make init` (3-5 min)
4. Accéder à http://localhost:8000 (1 min)

---

## 📖 Documentation

### RNDock
| Document | Taille | Contenu |
|----------|--------|----------|
| **QUICKSTART.md** ⚡ | 4.7 KB | Démarrage 5 min |
| **README.md** 📖 | 12 KB | Documentation complète |
| **ARCHITECTURE.md** | 15 KB | Vue technique |
| **TEMPLATE_NEW_PROJECT.md** | 7.5 KB | Guide nouveaux projets |
| **INDEX.md** | 8.9 KB | Navigation |
| **SUMMARY.md** | 10 KB | Synthèse |

### DjangoDock
| Document | Taille | Contenu |
|----------|--------|----------|
| **QUICKSTART.md** ⚡ | 2.3 KB | Démarrage 5 min |
| **README.md** 📖 | 9.2 KB | Documentation |
| **GUIDE.md** 📚 | 12 KB | Guide détaillé |
| **RAPPORT_FINAL.txt** | 14 KB | Rapport technique |
| **INDEX.md** | 6.2 KB | Navigation |
| **setup.sh** 🐳 | 27 KB | Script d'automatisation |

---

## 🔧 Comparaison

| Feature | RNDock | DjangoDock |
|---------|--------|------------|
| **Stack** | React Native + Express | Django + PostgreSQL |
| **Frontend** | Expo (mobile + web) | Django admin |
| **Backend** | Express.js | Django REST Framework |
| **DB** | PostgreSQL | PostgreSQL |
| **Setup** | Manuel (adapter structure) | Automatisé (setup.sh) |
| **Temps de mise en place** | 10-15 min | 5 min |
| **Commandes** | 20+ Makefile | 20+ Makefile |
| **Cas d'usage** | Apps mobiles | APIs web, admin |

---

## ✨ Caractéristiques communes

### ✅ Docker-First
- Aucune installation locale requise
- Reproduisible partout
- Versions figées
- Volumes persistants

### ✅ Production-Ready
- Alpine images (légères)
- Health checks
- Gunicorn/Nginx
- Security headers
- Environment config

### ✅ Bien documenté
- README complets
- Guides détaillés
- Troubleshooting
- Exemples pratiques
- Navigation claire

### ✅ Développement facile
- Makefile 20+ commandes
- Hot reload
- Logs en direct
- Shells interactifs
- Tests intégrés

---

## 📦 Dépendances requises

**Pour tous les projets** :
- Docker Desktop (v20.10+)
- Docker Compose (v2.0+)
- Git
- Terminal/CLI

**Optionnel** :
- Node.js / Python (si développement local)
- DBeaver / pgAdmin (pour gérer PostgreSQL)

---

## 🎓 Guide de sélection

### J'aimerais faire une **app mobile**
→ Utilisez **RNDock**
- React Native cross-platform
- Expo Go pour tests sur mobile
- Backend Node.js

### J'aimerais faire une **API REST / web app**
→ Utilisez **DjangoDock**
- Django mature et stable
- Admin interface incluse
- REST Framework

### J'aimerais faire les **deux**
→ Combinez **RNDock** (frontend) + **DjangoDock** (backend)
- Frontend mobile/web avec RNDock
- Backend API avec DjangoDock
- Communication HTTP entre services

---

## 💻 Exemples de projets possibles

### Avec RNDock
- App de budgeting (comme LedgerTrack)
- App d'e-commerce
- App de messagerie
- App de productivité
- App de santé/fitness

### Avec DjangoDock
- Blog / CMS
- API REST pour mobile
- Dashboard admin
- Système de gestion
- Backend e-commerce

### Avec les deux
- Système complet (frontend + backend)
- API mobile + admin web
- Multi-plateforme

---

## 🚀 Workflow typique

### Avec RNDock
```bash
1. Copier RNDock en nouveau projet
2. Adapter docker-compose.yml (ports, noms)
3. docker-compose build
4. docker-compose up
5. Développer avec make dev
```

### Avec DjangoDock
```bash
1. Exécuter setup.sh
2. Répondre aux prompts
3. cd mon_projet
4. make init
5. Développer avec make dev
```

---

## 📊 Statistiques

### RNDock
- **6 fichiers** de documentation
- **2290+ lignes** documentées
- **112 KB** total
- **3 services** Docker
- **20+ commandes** Makefile

### DjangoDock
- **6 fichiers** (5 docs + setup.sh)
- **3500+ lignes** de code
- **84 KB** total
- **2 services** Docker
- **20+ commandes** Makefile

### Total
- **12 fichiers** de documentation
- **~6000 lignes** de code
- **~200 KB** total
- **Services prêts** à l'emploi

---

## 🔗 Ressources

- [Docker Documentation](https://docs.docker.com)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [React Native Docs](https://reactnative.dev)
- [Expo Documentation](https://docs.expo.dev)
- [Django Documentation](https://docs.djangoproject.com)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)

---

## 🐛 Troubleshooting

### Port déjà utilisé
```bash
# RNDock
PORT=8081 make dev

# DjangoDock
PORT=8081 make restart
```

### Erreur de connexion BD
```bash
make clean
make build
make up
```

### Module/dépendance manquant
```bash
# RNDock
echo "module" >> LedgerTrack/package.json
make build

# DjangoDock
echo "module" >> requirements.txt
make build
```

Consultez les **README** respectifs pour le troubleshooting complet.

---

## 📝 Changelog

### v1.0 - Oct 2024 (Initial Release)

#### RNDock ✨
- ✅ Template React Native complet
- ✅ Structure Docker avec Expo + Express + PostgreSQL
- ✅ 6 fichiers de documentation (2290+ lignes)
- ✅ Makefile 20+ commandes
- ✅ Guide complet (README, QUICKSTART, ARCHITECTURE, etc)
- ✅ Template pour nouveaux projets
- ✅ Volumes persistants
- ✅ Health checks
- ✅ Production-ready (Gunicorn, WhiteNoise)

#### DjangoDock ✨
- ✅ Script setup.sh interactif (1147 lignes)
- ✅ Automatisation complète de création projet
- ✅ Configuration personnalisable (ports, versions)
- ✅ Django 4.2 LTS + PostgreSQL 15
- ✅ 6 fichiers de documentation (3500+ lignes)
- ✅ Makefile 20+ commandes
- ✅ Template Django complet (settings, urls, wsgi)
- ✅ Requirements.txt pré-configuré
- ✅ Environment variables gérées
- ✅ .gitignore et .dockerignore

#### Documentation 📖
- ✅ README principal (ce fichier)
- ✅ Guides de démarrage rapide
- ✅ Architecture détaillée
- ✅ Troubleshooting complet
- ✅ Bonnes pratiques
- ✅ Exemples pratiques

### Prochaines versions (Roadmap)

#### v1.1 (À venir)
- [ ] Support Redis pour caching
- [ ] Monitoring avec Prometheus/Grafana
- [ ] CI/CD templates (GitHub Actions)
- [ ] Scripts de backup automatiques
- [ ] Support production (Nginx, SSL)

#### v1.2 (À venir)
- [ ] Template GraphQL
- [ ] Support Celery (tâches async)
- [ ] Scripts migration BD
- [ ] Docker Swarm support
- [ ] Kubernetes deployment configs

#### v2.0 (À long terme)
- [ ] Web UI pour configuration
- [ ] CLI tool (Python/Node)
- [ ] Marketplace de templates
- [ ] Support multi-cloud
- [ ] Intégration IDE

---

## 🤝 Contribution

Les améliorations et corrections sont bienvenues !

### Comment contribuer
1. Fork le dépôt
2. Créer une branche (`git checkout -b feature/amazing`)
3. Committer les changements
4. Push vers la branche
5. Ouvrir une Pull Request

### Suggestions
- Bug reports
- Améliorations documentation
- Nouveaux templates
- Optimisations Docker

---

## 📜 Licence

MIT - Libre d'utilisation

---

## 📞 Support

Consultez les **README** respectifs de chaque template :
- `RNDock/README.md` pour React Native
- `DjangoDock/README.md` pour Django

Ou les guides détaillés :
- `RNDock/QUICKSTART.md` / `RNDock/GUIDE.md`
- `DjangoDock/QUICKSTART.md` / `DjangoDock/GUIDE.md`

---

## ✅ Quick Checklist

- [ ] Docker Desktop installé
- [ ] Git installé
- [ ] Terminal prêt
- [ ] Naviguer dans RNDock ou DjangoDock
- [ ] Lire le QUICKSTART.md approprié
- [ ] Lancer le projet
- [ ] Accéder à l'application
- [ ] Développer ! 🚀

---

**BoxBox v1.0** - Templates d'automatisation Docker pour React Native et Django  
*Oct 2024*

🌟 **Créez des projets professionnels en minutes, pas en heures !**
