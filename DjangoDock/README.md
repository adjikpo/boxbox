# 🐳 DjangoDock - Django Docker Automation

Template complet et automatisé pour créer des projets Django avec Docker/Docker Compose.

**DjangoDock** automatise entièrement la création d'un projet Django containerisé via des commandes Docker. Aucune installation locale de Python/Pip requise.

---

## ✨ Caractéristiques

- ✅ **Automatisation complète** : Script interactif `setup.sh`
- ✅ **Docker-first** : Tout via Docker (pas d'installation locale Python)
- ✅ **Configuration interactive** : Ports, versions, BD personnalisables
- ✅ **Django LTS** : Support Django 4.2 LTS et versions personnalisées
- ✅ **PostgreSQL** : Base de données production-ready
- ✅ **Makefile** : 20+ commandes raccourcis
- ✅ **Prêt à développer** : Structure complète incluse
- ✅ **Documentation** : README et guides complets

---

## 🚀 Démarrage rapide

### 1️⃣ Cloner ou copier DjangoDock

```bash
# Option A : Copier le dossier
cp -r /Users/adjikpo/Documents/Projets/boxbox/DjangoDock ~/DjangoDock
cd ~/DjangoDock

# Option B : Utiliser depuis le location actuel
cd /Users/adjikpo/Documents/Projets/boxbox/DjangoDock
```

### 2️⃣ Exécuter le script d'initialisation

```bash
chmod +x setup.sh
./setup.sh
```

### 3️⃣ Suivre les prompts interactifs

Le script demandera :
- **Nom du projet** (défaut: `django_project`)
- **Port web Django** (défaut: `8000`)
- **Port PostgreSQL** (défaut: `5432`)
- **Version Django** (défaut: `4.2`)
- **Version Python** (défaut: `3.11`)
- **Informations BD** (nom, user, password)

### 4️⃣ Initialiser le projet créé

```bash
cd <PROJECT_NAME>
make init
```

### 5️⃣ Accéder à Django

- **Django Admin** : http://localhost:PORT/admin
- **Site web** : http://localhost:PORT

---

## 📦 Ce que le script crée

### Dossier de projet

```
project_name/
├── .docker/
│   └── Dockerfile                 # Image Django + dependencies
├── config/                        # Configuration Django
│   ├── settings.py               # Django settings
│   ├── urls.py                   # URL routing
│   └── wsgi.py                   # WSGI app
├── app/                          # Applications Django
├── static/                       # Fichiers statiques
├── media/                        # Fichiers uploadés
├── docker-compose.yml            # Orchestration services
├── requirements.txt              # Dépendances Python
├── manage.py                     # Django management
├── Makefile                      # Commandes raccourcis
├── .env                          # Variables d'environnement
├── .env.example                  # Template .env
├── .gitignore                    # Exclusions Git
├── .dockerignore                 # Exclusions Docker
└── README.md                     # Documentation du projet
```

### Services Docker

**PostgreSQL** (Port configurable)
- Base de données production-ready
- Volume persistant
- Health checks

**Django Web** (Port configurable)
- Gunicorn WSGI server
- Django 4.2 LTS
- Migrations automatiques
- Collecte des statiques

---

## 🔧 Configuration des ports

### Changer le port web Django

```bash
# Éditer .env
PORT=8080

# Redémarrer
make restart
```

### Changer le port PostgreSQL

```bash
# Éditer .env
DB_PORT=5433

# Reconstruire et redémarrer
make build
make restart
```

---

## 📋 Commandes Makefile

### Initialisation

```bash
make init           # Build + migrate + createsuperuser
```

### Gestion des services

```bash
make build          # Builder les images Docker
make up             # Démarrer les services
make down           # Arrêter les services
make restart        # Redémarrer les services
make ps             # État des containers
make dev            # Mode développement (logs en direct)
```

### Commandes Django

```bash
make migrate        # Exécuter les migrations
make migrations     # Créer les migrations
make createsuperuser # Créer un admin
make collectstatic  # Collecter les fichiers statiques
make shell          # Django shell interactif
make test           # Exécuter les tests
```

### Accès

```bash
make bash-web       # Shell du container Django
make bash-db        # PostgreSQL psql
```

### Logs

```bash
make logs           # Tous les logs
make logs-web       # Logs Django
make logs-db        # Logs PostgreSQL
```

### Nettoyage

```bash
make clean          # Arrêter et supprimer les volumes
```

---

## 🔗 Commandes Docker Compose directes

```bash
# Démarrer
docker-compose up -d

# Arrêter
docker-compose down

# Logs
docker-compose logs -f

# Exécuter Django command
docker-compose exec web python manage.py COMMAND

# Exécuter psql
docker-compose exec db psql -U USER -d DB_NAME

# État
docker-compose ps
```

---

## 📝 Variables d'environnement (.env)

Générées automatiquement par le script :

```bash
# Django Settings
DEBUG=True
SECRET_KEY=auto-generated
ALLOWED_HOSTS=localhost,127.0.0.1

# Database Configuration
DATABASE_URL=postgresql://user:password@db:5432/dbname
DB_ENGINE=django.db.backends.postgresql
DB_NAME=django_db
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=db
DB_PORT=5432

# Server
PORT=8000
DB_PORT=5432

# Versions
DJANGO_VERSION=4.2
PYTHON_VERSION=3.11
```

---

## 🗄️ Base de données PostgreSQL

### Accéder à PostgreSQL

```bash
# Via Makefile (recommandé)
make bash-db

# Via docker-compose
docker-compose exec db psql -U postgres -d django_db

# Via DBeaver/pgAdmin
- Hôte: localhost
- Port: 5432 (ou votre port personnalisé)
- User: postgres
- Password: postgres
```

### Sauvegarder la base de données

```bash
docker-compose exec db pg_dump -U postgres django_db > backup.sql
```

### Restaurer la base de données

```bash
docker-compose exec -T db psql -U postgres django_db < backup.sql
```

---

## 📚 Dépendances incluses

### Core
- Django 4.2 LTS
- Gunicorn 21.2
- psycopg2-binary 2.9

### Database
- dj-database-url 2.1
- django-environ 0.11

### API
- djangorestframework 3.14
- django-cors-headers 4.3
- django-filter 23.4

### Admin & Tools
- django-extensions 3.2
- django-debug-toolbar 4.1

### Utilities
- python-decouple 3.8
- requests 2.31
- whitenoise 6.6
- django-health-check 3.16

### Development
- black 23.12
- flake8 6.1
- isort 5.13
- pytest 7.4
- pytest-django 4.7
- factory-boy 3.3

Voir `requirements.txt` pour la liste complète.

---

## 🎓 Guide d'utilisation

### Créer un projet minimal

```bash
./setup.sh
# Accepter tous les défauts
# Accepter la configuration finale
```

### Créer un projet personnalisé

```bash
./setup.sh
# Saisir les infos :
# Nom: my_app
# Port: 8080
# Version Django: 4.2
# Etc.
```

### Ajouter une app Django

```bash
cd my_app
docker-compose exec web python manage.py startapp myapp
```

### Ajouter une dépendance

```bash
# Éditer requirements.txt
echo "django-celery==5.0.0" >> requirements.txt

# Reconstruire
make build

# Redémarrer
make restart
```

### Exécuter les tests

```bash
make test
```

### Accéder au Django shell

```bash
make shell

# Dans le shell
>>> from django.contrib.auth.models import User
>>> User.objects.all()
```

---

## 🔍 Debugging

### Voir les erreurs

```bash
make logs-web
```

### Accéder au container

```bash
make bash-web
```

### Réinitialiser la BD

```bash
make clean
make build
make up
make migrate
```

---

## ⚠️ Production

**NE PAS utiliser directement en production !**

Adaptations requises :

1. `DEBUG = False`
2. `SECRET_KEY` : Nouvelle clé forte
3. `ALLOWED_HOSTS` : Domaines réels
4. `SECURE_SSL_REDIRECT = True`
5. `SESSION_COOKIE_SECURE = True`
6. `CSRF_COOKIE_SECURE = True`
7. HTTPS/SSL certificate
8. Serveur web (Nginx/Apache)
9. Sauvegarde automatique BD
10. Monitoring & logs centralisés

---

## 📂 Fichiers du script setup.sh

Le script `setup.sh` crée automatiquement :

| Fichier | Rôle |
|---------|------|
| `.docker/Dockerfile` | Image Django |
| `docker-compose.yml` | Orchestration services |
| `.env` | Variables personnalisées |
| `.env.example` | Template .env |
| `requirements.txt` | Dépendances Python |
| `Makefile` | Commandes raccourcis |
| `.gitignore` | Exclusions Git |
| `.dockerignore` | Exclusions Docker |
| `config/settings.py` | Django settings |
| `config/urls.py` | URL routing |
| `config/wsgi.py` | WSGI application |
| `manage.py` | Django CLI |
| `README.md` | Documentation du projet |

---

## 🐛 Troubleshooting

### "Port 8000 already in use"

```bash
# Changer le port dans .env
echo "PORT=8080" >> .env

# Redémarrer
make restart
```

### "Connection refused" (BD)

```bash
# Vérifier l'état
make ps

# Voir les logs
make logs-db

# Recréer
make clean
make build
make up
```

### "Module not found"

```bash
# Ajouter la dépendance
echo "module-name" >> requirements.txt

# Reconstruire
make build
make restart
```

---

## 📚 Ressources

- [Django Documentation](https://docs.djangoproject.com/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

## 📜 License

MIT

---

## 🤝 Contribution

Les améliorations et corrections sont bienvenues !

---

**DjangoDock v1.0** - Automatise la création de projets Django avec Docker  
*Oct 2024*

Pour démarrer : `./setup.sh`
