# 📖 Guide détaillé DjangoDock

Guide pas-à-pas pour utiliser DjangoDock et créer vos projets Django.

---

## 🎯 Table des matières

1. [Démarrage rapide (5 min)](#démarrage-rapide)
2. [Configuration des ports](#configuration-des-ports)
3. [Commandes Docker](#commandes-docker)
4. [Développement local](#développement-local)
5. [Gestion de la base de données](#gestion-de-la-base-de-données)
6. [Dépendances et modules](#dépendances-et-modules)
7. [Troubleshooting](#troubleshooting)
8. [Bonnes pratiques](#bonnes-pratiques)

---

## 🚀 Démarrage rapide

### Étape 1 : Prérequis

```bash
# Vérifier Docker
docker --version   # v20.10+
docker-compose --version  # v2.0+

# Vérifier Git
git --version
```

### Étape 2 : Exécuter le setup

```bash
cd /Users/adjikpo/Documents/Projets/boxbox/DjangoDock
chmod +x setup.sh
./setup.sh
```

### Étape 3 : Répondre aux questions

```
Nom du projet (défaut: django_project): my_app
Port web Django (défaut: 8000): 8000
Port PostgreSQL (défaut: 5432): 5432
Version Django LTS (défaut: 4.2): 4.2
Version Python (défaut: 3.11): 3.11
Nom de la base de données (défaut: my_app_db): my_app_db
Utilisateur PostgreSQL (défaut: postgres): postgres
Mot de passe PostgreSQL (défaut: postgres): postgres

Continuer avec cette configuration? (y/n): y
```

### Étape 4 : Initialiser le projet

```bash
cd my_app
make init
```

### Étape 5 : Accéder à Django

```
http://localhost:8000        # Site web
http://localhost:8000/admin  # Admin (avec superuser créé)
```

---

## 🔧 Configuration des ports

### Pourquoi configurer les ports ?

**Port web (8000)** : Django Gunicorn WSGI server
**Port BD (5432)** : PostgreSQL

Vous devez les changer si :
- Un autre service utilise déjà ces ports
- Vous avez plusieurs projets Django simultanés
- Vous utilisez PostgreSQL localement

### Changer le port web Django

**Avant le démarrage** :
```bash
# Dans le fichier setup.sh, lors de la création du projet:
Port web Django (défaut: 8000): 8080
```

**Après la création** :
```bash
cd my_app

# Éditer .env
echo "PORT=8080" >> .env

# Ou modifier directement
nano .env  # PORT=8080

# Redémarrer
make restart

# Accéder à
http://localhost:8080
```

### Changer le port PostgreSQL

```bash
cd my_app

# Éditer .env
DB_PORT=5433

# Reconstruire l'image
make build

# Redémarrer
make restart

# Accéder à PostgreSQL avec DBeaver:
localhost:5433
```

### Vérifier les ports utilisés

```bash
# macOS / Linux
lsof -i :8000
lsof -i :5432

# Windows
netstat -ano | findstr :8000
netstat -ano | findstr :5432
```

---

## 🐳 Commandes Docker

### Via Makefile (Recommandé)

```bash
# Initialiser complètement
make init
# = build + migrate + createsuperuser

# Démarrer les services
make up
# Docker Compose: up -d

# Arrêter les services
make down
# Docker Compose: down

# Redémarrer
make restart

# Voir l'état
make ps
# Docker Compose: ps

# Mode développement (logs en direct)
make dev
# Docker Compose: up (foreground)
```

### Django Management

```bash
# Exécuter les migrations
make migrate
# = docker-compose exec web python manage.py migrate

# Créer les migrations
make migrations
# = docker-compose exec web python manage.py makemigrations

# Créer un superutilisateur
make createsuperuser

# Collecter les fichiers statiques
make collectstatic

# Django shell interactif
make shell

# Exécuter les tests
make test
# = docker-compose exec web pytest
```

### Logs

```bash
# Tous les services
make logs

# Seulement Django
make logs-web

# Seulement PostgreSQL
make logs-db

# Arrêter les logs
Ctrl+C
```

### Accès direct

```bash
# Shell Django container
make bash-web

# PostgreSQL psql
make bash-db
```

---

## 📝 Développement local

### Structure du projet créé

```
my_app/
├── .docker/
│   └── Dockerfile              # Image Django
├── config/
│   ├── __init__.py
│   ├── settings.py             # Configurations Django
│   ├── urls.py                 # Routes
│   └── wsgi.py                 # WSGI entry
├── app/                        # Applications Django
│   └── (vos apps ici)
├── static/                     # CSS, JS, images
├── media/                      # Uploads utilisateurs
├── templates/                  # HTML templates
├── manage.py                   # Django CLI
├── requirements.txt            # Dépendances
├── docker-compose.yml          # Services
├── Makefile                    # Commandes
├── .env                        # Secrets (ne pas committer)
├── .env.example                # Template .env
├── .gitignore                  # Exclusions Git
├── .dockerignore               # Exclusions Docker
└── README.md                   # Doc du projet
```

### Créer une app Django

```bash
docker-compose exec web python manage.py startapp users
```

Fichiers créés :
```
users/
├── migrations/
├── __init__.py
├── admin.py
├── apps.py
├── models.py
├── tests.py
├── views.py
└── urls.py
```

### Créer un modèle

```bash
# 1. Éditer app/users/models.py
nano app/users/models.py

# Ajouter:
# class User(models.Model):
#     name = models.CharField(max_length=100)
#     email = models.EmailField()

# 2. Créer la migration
make migrations

# 3. Appliquer la migration
make migrate

# 4. Vérifier dans la BD
make bash-db
# \dt  (list tables)
```

### Éditer settings.py

```bash
nano config/settings.py

# Points importants:
# - INSTALLED_APPS : Ajouter vos apps
# - DATABASES : Déjà configuré (PostgreSQL)
# - ALLOWED_HOSTS : Pour production
# - STATIC_ROOT / MEDIA_ROOT : Fichiers
```

### Mode développement

```bash
# Démarrer avec logs en direct
make dev

# Django recharge automatiquement les changements de code
# Voir les erreurs en temps réel dans les logs

# Pour arrêter
Ctrl+C
```

---

## 🗄️ Gestion de la base de données

### Structure PostgreSQL

```
Container : my_app_db
Image : postgres:15-alpine
Port : 5432 (ou personnalisé)
Volume : postgres_data (persistant)
```

### Accéder à PostgreSQL

#### Option 1 : Via Makefile

```bash
make bash-db
# psql prompt (my_app_db=# )
```

#### Option 2 : Via docker-compose

```bash
docker-compose exec db psql -U postgres -d my_app_db
```

#### Option 3 : Via GUI (DBeaver)

```
Host: localhost
Port: 5432
Database: my_app_db
User: postgres
Password: postgres
```

### Commandes PostgreSQL utiles

```bash
# Dans le psql:

# Lister les tables
\dt

# Voir le schéma d'une table
\d app_users

# Exécuter SQL
SELECT * FROM auth_user;

# Quitter
\q
```

### Sauvegarder la base

```bash
# Dump SQL
docker-compose exec db pg_dump -U postgres my_app_db > backup.sql

# Dump binaire
docker-compose exec db pg_dump -Fc -U postgres my_app_db > backup.dump
```

### Restaurer la base

```bash
# Depuis SQL
docker-compose exec -T db psql -U postgres my_app_db < backup.sql

# Depuis dump binaire
docker-compose exec db pg_restore -U postgres -d my_app_db /path/to/backup.dump
```

### Réinitialiser la base

```bash
# Attention: Supprime TOUTES les données !
make clean
make build
make up
make migrate
```

---

## 📦 Dépendances et modules

### Ajouter une dépendance

```bash
# 1. Éditer requirements.txt
echo "django-celery==5.0.0" >> requirements.txt

# 2. Reconstruire l'image
make build

# 3. Redémarrer
make restart

# 4. Vérifier
docker-compose exec web pip list | grep celery
```

### Dépendances courantes à ajouter

```bash
# API REST
djangorestframework

# Authentication JWT
djangorestframework-simplejwt

# Images
Pillow

# Email
django-anymail

# Uploads S3
django-storages

# Celery (tâches async)
celery
redis

# Admin amélioré
django-admin-interface

# Monitoring
sentry-sdk

# Data validation
marshmallow
```

### Voir les dépendances installées

```bash
docker-compose exec web pip list

# Ou dans le shell Django
make shell
# >>> import django; django.VERSION
# >>> import rest_framework; rest_framework.__version__
```

---

## 🔍 Troubleshooting

### "Port 8000 already in use"

```bash
# Voir quel processus utilise le port
lsof -i :8000

# Tuer le processus
kill -9 <PID>

# Ou utiliser un autre port dans .env
PORT=8080
make restart
```

### "Connection refused" (BD)

```bash
# 1. Vérifier l'état
make ps

# 2. Voir les logs
make logs-db

# 3. Reconstruire complètement
make clean
make build
make up

# 4. Vérifier la connexion
make bash-db
\dt
```

### "Module not found" ou "ImportError"

```bash
# 1. Vérifier dans requirements.txt
grep module_name requirements.txt

# 2. Si absent, l'ajouter
echo "module-name==1.0.0" >> requirements.txt

# 3. Reconstruire
make build
make restart

# 4. Vérifier
docker-compose exec web pip list | grep module
```

### "Static files not found"

```bash
# Collecter les statiques
make collectstatic

# Ou redémarrer (inclus dans make up)
make restart
```

### "Permission denied"

```bash
# Rendre le script exécutable
chmod +x setup.sh

# Ou si c'est un conteneur
docker-compose exec web chmod +x manage.py
```

### "django.core.exceptions.ImproperlyConfigured"

```bash
# Voir les erreurs complètes
make logs-web

# Éditer settings.py
nano config/settings.py

# Vérifier INSTALLED_APPS
# Vérifier DATABASES
# Vérifier SECRET_KEY
```

### Réinitialiser complètement

```bash
# Option nucléaire (supprime tout)
make clean
make build
make up -d
make migrate
make createsuperuser
```

---

## 💡 Bonnes pratiques

### .env et secrets

```bash
# ✅ À faire
- Éditer .env avec les secrets locaux
- Committer .env.example (sans secrets)
- Ignorer .env en .gitignore

# ❌ À éviter
- Committer .env
- Hardcoder les secrets en code
- Utiliser les mêmes secrets partout
```

### Gestion des migrations

```bash
# ✅ À faire
- Créer les migrations après chaque changement de model
- Committer les migrations
- Appliquer les migrations avant de déployer

# ❌ À éviter
- Modifier directement la BD
- Ignorer les fichiers de migration
- Réinitialiser la BD en production
```

### Logs et debugging

```bash
# ✅ À faire
make logs-web        # Pour voir les erreurs
make shell           # Pour debug interactif
print()              # Pour debug classique

# ❌ À éviter
- Ignorer les logs
- Utiliser des print() en production
- Ne pas vérifier les erreurs Django
```

### Dépendances

```bash
# ✅ À faire
- Fixer les versions dans requirements.txt
- Committer requirements.txt
- Regénérer après ajouter une dépendance

# ❌ À éviter
- Utiliser des versions flottantes (==)
- Ne pas documentar les nouvelles dépendances
- Installer localement sans requirements.txt
```

### Base de données

```bash
# ✅ À faire
- Faire des backups réguliers
- Tester les migrations sur une copie
- Utiliser les volumes Docker

# ❌ À éviter
- Modifier directement les données
- Réinitialiser la BD sans backup
- Ignorer les erreurs de migration
```

---

## 🔗 Ressources supplémentaires

- [Django Official Docs](https://docs.djangoproject.com/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Django Best Practices](https://docs.djangoproject.com/en/stable/misc/design-philosophies/)

---

## 🎓 Exemples pratiques

### Exemple 1 : Créer une API simple

```bash
# 1. Créer une app
docker-compose exec web python manage.py startapp api

# 2. Créer un modèle (api/models.py)
# class Article(models.Model):
#     title = models.CharField(max_length=200)
#     content = models.TextField()

# 3. Créer une migration
make migrations

# 4. Appliquer
make migrate

# 5. Créer une vue API (api/views.py)
# from rest_framework import viewsets
# class ArticleViewSet(viewsets.ModelViewSet):
#     queryset = Article.objects.all()

# 6. Enregistrer en admin (api/admin.py)
# admin.site.register(Article)

# 7. Accéder à http://localhost:8000/admin
```

### Exemple 2 : Ajouter une dépendance

```bash
# 1. Besoin : Django Celery
echo "celery==5.3.0" >> requirements.txt
echo "redis==4.5.0" >> requirements.txt

# 2. Reconstruire
make build

# 3. Redémarrer
make restart

# 4. Configurer dans settings.py
# CELERY_BROKER_URL = 'redis://redis:6379'
```

### Exemple 3 : Lancer les tests

```bash
# 1. Écrire un test (app/tests.py)
# from django.test import TestCase
# class ModelTest(TestCase):
#     def test_create(self):
#         assert True

# 2. Exécuter
make test

# 3. Voir le coverage
docker-compose exec web pytest --cov
```

---

**DjangoDock Guide v1.0**  
*Oct 2024*
