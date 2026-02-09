#!/bin/bash

################################################################################
#                    🐳 Django Docker Setup Script
#
# Automatise la création d'un projet Django avec Docker/Docker Compose
# Tous les outils (pip, python, etc) sont exécutés via Docker
#
# Usage: ./setup.sh [project_name]
#
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DEFAULT_PROJECT_NAME="django_project"
DEFAULT_PORT="8000"
DEFAULT_DB_PORT="5432"
DEFAULT_DJANGO_VERSION="4.2"
DEFAULT_PYTHON_VERSION="3.11"

################################################################################
# FUNCTIONS
################################################################################

print_header() {
    echo -e "${BLUE}=================================================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=================================================================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Docker is installed
check_docker() {
    print_info "Vérification de Docker..."
    if ! command -v docker &> /dev/null; then
        print_error "Docker n'est pas installé. Installez Docker Desktop."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose n'est pas installé."
        exit 1
    fi
    
    print_success "Docker et Docker Compose sont installés"
    docker --version
    docker-compose --version
}

# Prompt user for project configuration
get_user_input() {
    print_header "🎯 Configuration du Projet Django"
    
    # Project name
    read -p "Nom du projet (défaut: $DEFAULT_PROJECT_NAME): " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}
    
    # Web port
    read -p "Port web Django (défaut: $DEFAULT_PORT): " WEB_PORT
    WEB_PORT=${WEB_PORT:-$DEFAULT_PORT}
    
    # Database port
    read -p "Port PostgreSQL (défaut: $DEFAULT_DB_PORT): " DB_PORT
    DB_PORT=${DB_PORT:-$DEFAULT_DB_PORT}
    
    # Django version
    read -p "Version Django LTS (défaut: $DEFAULT_DJANGO_VERSION): " DJANGO_VERSION
    DJANGO_VERSION=${DJANGO_VERSION:-$DEFAULT_DJANGO_VERSION}
    
    # Python version
    read -p "Version Python (défaut: $DEFAULT_PYTHON_VERSION): " PYTHON_VERSION
    PYTHON_VERSION=${PYTHON_VERSION:-$DEFAULT_PYTHON_VERSION}
    
    # Database name
    read -p "Nom de la base de données (défaut: ${PROJECT_NAME}_db): " DB_NAME
    DB_NAME=${DB_NAME:-${PROJECT_NAME}_db}
    
    # Database user
    read -p "Utilisateur PostgreSQL (défaut: postgres): " DB_USER
    DB_USER=${DB_USER:-postgres}
    
    # Database password
    read -sp "Mot de passe PostgreSQL (défaut: postgres): " DB_PASSWORD
    echo
    DB_PASSWORD=${DB_PASSWORD:-postgres}
    
    # Django secret key (auto-generated)
    DJANGO_SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe(50))')
    
    # Confirmation
    echo -e "\n${BLUE}=== Résumé de la configuration ===${NC}"
    echo "Nom du projet       : $PROJECT_NAME"
    echo "Port web            : $WEB_PORT"
    echo "Port DB             : $DB_PORT"
    echo "Version Django      : $DJANGO_VERSION"
    echo "Version Python      : $PYTHON_VERSION"
    echo "Base de données     : $DB_NAME"
    echo "Utilisateur DB      : $DB_USER"
    echo ""
    
    read -p "Continuer avec cette configuration? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Annulé par l'utilisateur"
        exit 1
    fi
}

# Create project directory structure
create_project_structure() {
    print_header "📁 Création de la structure du projet"
    
    PROJECT_DIR="$PROJECT_NAME"
    
    if [ -d "$PROJECT_DIR" ]; then
        print_warning "Le répertoire $PROJECT_DIR existe déjà"
        read -p "Supprimer et recréer? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$PROJECT_DIR"
        else
            print_error "Opération annulée"
            exit 1
        fi
    fi
    
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"
    
    # Create subdirectories
    mkdir -p "app"
    mkdir -p ".docker"
    mkdir -p "static"
    mkdir -p "media"
    
    print_success "Structure du projet créée: $PROJECT_DIR"
}

# Create Dockerfile
create_dockerfile() {
    print_info "Création du Dockerfile..."
    
    cat > ".docker/Dockerfile" << 'EOF'
# syntax=docker/dockerfile:1
FROM python:${PYTHON_VERSION}-slim

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy project
COPY . .

# Create necessary directories
RUN mkdir -p /app/staticfiles /app/media

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health', timeout=2)"

# Default command
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "120", "config.wsgi:application"]
EOF

    print_success "Dockerfile créé: .docker/Dockerfile"
}

# Create docker-compose.yml
create_docker_compose() {
    print_info "Création du docker-compose.yml..."
    
    cat > "docker-compose.yml" << EOF
services:
  # PostgreSQL Database
  db:
    image: postgres:15-alpine
    container_name: ${PROJECT_NAME}_db
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "${DB_PORT}:5432"
    networks:
      - django_network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Django Web Application
  web:
    build:
      context: .
      dockerfile: .docker/Dockerfile
      args:
        PYTHON_VERSION: ${PYTHON_VERSION}
    container_name: ${PROJECT_NAME}_web
    command: >
      sh -c "python manage.py migrate &&
             python manage.py collectstatic --noinput &&
             gunicorn --bind 0.0.0.0:8000 --workers 4 --timeout 120 config.wsgi:application"
    environment:
      - DEBUG=\${DEBUG:-False}
      - SECRET_KEY=\${SECRET_KEY}
      - ALLOWED_HOSTS=\${ALLOWED_HOSTS:-localhost,127.0.0.1}
      - DATABASE_URL=postgresql://${DB_USER}:\${DB_PASSWORD}@db:5432/${DB_NAME}
      - DB_ENGINE=django.db.backends.postgresql
      - DB_NAME=${DB_NAME}
      - DB_USER=${DB_USER}
      - DB_PASSWORD=\${DB_PASSWORD}
      - DB_HOST=db
      - DB_PORT=5432
    volumes:
      - .:/app
      - static_volume:/app/staticfiles
      - media_volume:/app/media
    ports:
      - "${WEB_PORT}:8000"
    depends_on:
      db:
        condition: service_healthy
    networks:
      - django_network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8000/ || exit 1"]
      interval: 15s
      timeout: 5s
      retries: 3
      start_period: 30s

volumes:
  postgres_data:
    driver: local
  static_volume:
    driver: local
  media_volume:
    driver: local

networks:
  django_network:
    driver: bridge
EOF

    print_success "docker-compose.yml créé"
}

# Create .env file
create_env_file() {
    print_info "Création du fichier .env..."
    
    cat > ".env" << EOF
# Django Settings
DEBUG=True
SECRET_KEY=${DJANGO_SECRET_KEY}
ALLOWED_HOSTS=localhost,127.0.0.1,*.localhost

# Database Configuration
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@db:5432/${DB_NAME}
DB_ENGINE=django.db.backends.postgresql
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_HOST=db
DB_PORT=5432

# Server
PORT=${WEB_PORT}
DB_PORT=${DB_PORT}

# Django Version
DJANGO_VERSION=${DJANGO_VERSION}
PYTHON_VERSION=${PYTHON_VERSION}

# Email (optionnel)
EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend

# CORS (optionnel)
CORS_ALLOWED_ORIGINS=http://localhost:${WEB_PORT},http://127.0.0.1:${WEB_PORT}

# Security (à adapter pour production)
SECURE_SSL_REDIRECT=False
SESSION_COOKIE_SECURE=False
CSRF_COOKIE_SECURE=False
EOF

    cat > ".env.example" << EOF
# Django Settings
DEBUG=True
SECRET_KEY=your-secret-key-here-min-50-chars
ALLOWED_HOSTS=localhost,127.0.0.1,*.localhost

# Database Configuration
DATABASE_URL=postgresql://postgres:postgres@db:5432/django_db
DB_ENGINE=django.db.backends.postgresql
DB_NAME=django_db
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=db
DB_PORT=5432

# Server
PORT=8000
DB_PORT=5432

# Django Version
DJANGO_VERSION=4.2
PYTHON_VERSION=3.11

# Email (optionnel)
EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend

# CORS (optionnel)
CORS_ALLOWED_ORIGINS=http://localhost:8000,http://127.0.0.1:8000

# Security (à adapter pour production)
SECURE_SSL_REDIRECT=False
SESSION_COOKIE_SECURE=False
CSRF_COOKIE_SECURE=False
EOF

    print_success ".env et .env.example créés"
}

# Create requirements.txt
create_requirements() {
    print_info "Création du requirements.txt..."
    
    cat > "requirements.txt" << EOF
# Core
Django==${DJANGO_VERSION}.*
gunicorn==21.2.0
psycopg2-binary==2.9.9

# Database
dj-database-url==2.1.0
django-environ==0.11.2

# REST API (optionnel)
djangorestframework==3.14.0
django-cors-headers==4.3.1
django-filter==23.4

# Admin & Tools
django-extensions==3.2.3
django-debug-toolbar==4.1.0

# Utilities
python-decouple==3.8
requests==2.31.0

# Production
whitenoise==6.6.0
django-health-check==3.16.0

# Development
black==23.12.0
flake8==6.1.0
isort==5.13.2
pytest==7.4.3
pytest-django==4.7.0
factory-boy==3.3.0

# Monitoring (optionnel)
sentry-sdk==1.39.1
EOF

    print_success "requirements.txt créé"
}

# Create .gitignore
create_gitignore() {
    print_info "Création du .gitignore..."
    
    cat > ".gitignore" << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv
pip-log.txt
pip-delete-this-directory.txt
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
.hypothesis/
.pytest_cache/

# Django
*.log
local_settings.py
db.sqlite3
/media
/staticfiles
/static

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Environment
.env
.env.local
!.env.example

# Docker
docker-compose.override.yml

# Testing
.pytest_cache/
htmlcov/

# Misc
.git/
*.egg-info/
dist/
build/
EOF

    print_success ".gitignore créé"
}

# Create .dockerignore
create_dockerignore() {
    print_info "Création du .dockerignore..."
    
    cat > ".dockerignore" << 'EOF'
.git
.gitignore
.dockerignore
*.md
.env
.venv
env/
db.sqlite3
__pycache__
*.pyc
.pytest_cache
.coverage
htmlcov
.DS_Store
media/
staticfiles/
*.egg-info
.tox
.vscode
.idea
docker-compose.override.yml
EOF

    print_success ".dockerignore créé"
}

# Create Makefile
create_makefile() {
    print_info "Création du Makefile..."
    
    cat > "Makefile" << EOF
.DEFAULT_GOAL := help
.PHONY: help build up down logs migrate createsuperuser shell collectstatic clean restart ps init dev

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m

help:
	@echo "\$(BLUE)📦 Commandes Django Docker disponibles:\$(NC)"
	@echo ""
	@echo "\$(GREEN)Initialisation\$(NC)"
	@echo "  make init                  # Initialiser le projet (build + migrate + createsuperuser)"
	@echo ""
	@echo "\$(GREEN)Docker\$(NC)"
	@echo "  make build                 # Builder les images Docker"
	@echo "  make up                    # Démarrer les services"
	@echo "  make down                  # Arrêter les services"
	@echo "  make restart               # Redémarrer les services"
	@echo "  make ps                    # Afficher les containers actifs"
	@echo ""
	@echo "\$(GREEN)Django\$(NC)"
	@echo "  make migrate               # Exécuter les migrations"
	@echo "  make migrations            # Créer les migrations"
	@echo "  make createsuperuser       # Créer un superutilisateur"
	@echo "  make collectstatic         # Collecter les fichiers statiques"
	@echo "  make shell                 # Accéder au shell Django interactif"
	@echo "  make test                  # Exécuter les tests"
	@echo ""
	@echo "\$(GREEN)Logs\$(NC)"
	@echo "  make logs                  # Voir les logs de tous les services"
	@echo "  make logs-web              # Voir les logs du serveur Django"
	@echo "  make logs-db               # Voir les logs de la BD"
	@echo ""
	@echo "\$(GREEN)Nettoyage\$(NC)"
	@echo "  make clean                 # Arrêter et supprimer les volumes"
	@echo "  make dev                   # Démarrer en mode développement (logs en direct)"
	@echo ""

# Initialisation
init: build migrate createsuperuser
	@echo "\$(GREEN)✅ Projet initialisé avec succès!\$(NC)"

# Docker commands
build:
	@echo "\$(BLUE)🏗️  Construction des images Docker...\$(NC)"
	docker-compose build

up:
	@echo "\$(BLUE)🚀 Démarrage des services...\$(NC)"
	docker-compose up -d
	@echo "\$(GREEN)✅ Services démarrés!\$(NC)"
	@echo "Accédez à Django sur: http://localhost:${WEB_PORT}"

down:
	@echo "\$(YELLOW)🛑 Arrêt des services...\$(NC)"
	docker-compose down

restart:
	@echo "\$(YELLOW)🔄 Redémarrage des services...\$(NC)"
	docker-compose restart
	@echo "\$(GREEN)✅ Services redémarrés!\$(NC)"

ps:
	@echo "\$(BLUE)📊 État des containers:\$(NC)"
	docker-compose ps

dev:
	@echo "\$(BLUE)🎯 Démarrage en mode développement (logs en direct)...\$(NC)"
	docker-compose up

# Django commands
migrate:
	@echo "\$(BLUE)🔄 Exécution des migrations...\$(NC)"
	docker-compose exec web python manage.py migrate

migrations:
	@echo "\$(BLUE)📝 Création des migrations...\$(NC)"
	docker-compose exec web python manage.py makemigrations

createsuperuser:
	@echo "\$(BLUE)👤 Création d'un superutilisateur...\$(NC)"
	docker-compose exec web python manage.py createsuperuser

collectstatic:
	@echo "\$(BLUE)📦 Collection des fichiers statiques...\$(NC)"
	docker-compose exec web python manage.py collectstatic --noinput

shell:
	@echo "\$(BLUE)🔧 Accès au shell Django...\$(NC)"
	docker-compose exec web python manage.py shell

test:
	@echo "\$(BLUE)🧪 Exécution des tests...\$(NC)"
	docker-compose exec web pytest

# Logs
logs:
	@echo "\$(BLUE)📋 Logs de tous les services:\$(NC)"
	docker-compose logs -f

logs-web:
	@echo "\$(BLUE)📋 Logs du serveur Django:\$(NC)"
	docker-compose logs -f web

logs-db:
	@echo "\$(BLUE)📋 Logs de PostgreSQL:\$(NC)"
	docker-compose logs -f db

# Cleaning
clean:
	@echo "\$(YELLOW)🧹 Nettoyage des services et volumes...\$(NC)"
	docker-compose down -v
	@echo "\$(GREEN)✅ Services arrêtés et volumes supprimés!\$(NC)"

# Utilities
bash-web:
	@echo "\$(BLUE)🔧 Accès au shell du container web...\$(NC)"
	docker-compose exec web bash

bash-db:
	@echo "\$(BLUE)🔧 Accès au psql...\$(NC)"
	docker-compose exec db psql -U ${DB_USER} -d ${DB_NAME}

lint:
	@echo "\$(BLUE)🔍 Linting...\$(NC)"
	docker-compose exec web flake8 .

typecheck:
	@echo "\$(BLUE)🔍 Type checking...\$(NC)"
	docker-compose exec web mypy .

status:
	@echo "\$(BLUE)📊 Etat des services:\$(NC)"
	@docker-compose ps
	@echo ""
	@echo "\$(GREEN)URLs:\$(NC)"
	@echo "  - Django: http://localhost:${WEB_PORT}"
	@echo "  - PostgreSQL: localhost:${DB_PORT}"

db-dump:
	@echo "\$(BLUE)💾 Dump de la base de donnees...\$(NC)"
	docker-compose exec db pg_dump -U ${DB_USER} ${DB_NAME} > dump_\$\$(date +%Y%m%d_%H%M%S).sql
	@echo "\$(GREEN)✅ Dump cree!\$(NC)"

db-restore:
ifndef SQL
	@echo "\$(YELLOW)Usage: make db-restore SQL=fichier.sql\$(NC)"
else
	@echo "\$(BLUE)📥 Restauration de la base de donnees...\$(NC)"
	cat \$(SQL) | docker-compose exec -T db psql -U ${DB_USER} -d ${DB_NAME}
	@echo "\$(GREEN)✅ Base restauree!\$(NC)"
endif
EOF

    print_success "Makefile créé"
}

# Create README.md
create_readme() {
    print_info "Création du README.md..."
    
    cat > "README.md" << 'EOF'
# 🐳 Django Docker Project

Projet Django containerisé avec PostgreSQL et Docker Compose.

## 📋 Prérequis

- Docker Desktop (v20.10+)
- Docker Compose (v2.0+)
- Git

## 🚀 Démarrage rapide

### 1. Initialiser le projet

```bash
# Option 1 : Utiliser le Makefile (recommandé)
make init

# Option 2 : Étapes manuelles
docker-compose build
docker-compose up -d
make migrate
make createsuperuser
```

### 2. Accéder à l'application

- **Django Admin** : http://localhost:PORT_CONFIGURÉ/admin
- **API** : http://localhost:PORT_CONFIGURÉ

### 3. Commandes essentielles

```bash
# Démarrer les services
make up

# Arrêter les services
make down

# Voir les logs
make logs

# Accéder au shell Django
make shell

# Exécuter les migrations
make migrate

# Créer un superutilisateur
make createsuperuser

# Collectionner les fichiers statiques
make collectstatic

# Exécuter les tests
make test
```

## 📂 Structure du projet

```
.
├── .docker/
│   └── Dockerfile           # Configuration du container Django
├── app/                     # Application Django
├── static/                  # Fichiers statiques
├── media/                   # Fichiers uploadés
├── docker-compose.yml       # Orchestration services
├── requirements.txt         # Dépendances Python
├── manage.py                # Django management
├── .env                     # Variables d'environnement (généré)
├── .env.example             # Template .env
├── .gitignore               # Exclusions Git
├── Makefile                 # Commandes raccourcis
└── README.md               # Ce fichier
```

## 🔧 Configuration

### Variables d'environnement (.env)

Les variables principales :

- `DEBUG` : Mode débogage (True/False)
- `SECRET_KEY` : Clé secrète Django (générée automatiquement)
- `ALLOWED_HOSTS` : Hôtes autorisés
- `DATABASE_URL` : URL de connexion PostgreSQL
- `DB_NAME` : Nom de la base de données
- `DB_USER` : Utilisateur PostgreSQL
- `DB_PASSWORD` : Mot de passe PostgreSQL
- `PORT` : Port web Django

### Personnaliser le port

Pour utiliser un port différent :

1. Éditer `.env` :
   ```bash
   PORT=8080
   ```

2. Redémarrer :
   ```bash
   make restart
   ```

## 🐳 Commandes Docker Compose

```bash
# Démarrer les services
docker-compose up -d

# Arrêter les services
docker-compose down

# Voir les logs
docker-compose logs -f

# Exécuter une commande dans le container web
docker-compose exec web python manage.py COMMANDE

# Exécuter une commande dans le container db
docker-compose exec db psql -U USER -d DATABASE
```

## 🗄️ Base de données

PostgreSQL est configurée avec :

- **Port** : Configurable (défaut: 5432)
- **Données persistantes** : Volume Docker `postgres_data`
- **Sauvegarde** : À configurer manuellement pour production

### Accéder à PostgreSQL

```bash
# Via le Makefile
make bash-db

# Via docker-compose directement
docker-compose exec db psql -U postgres -d django_db
```

## 📦 Dépendances

Les dépendances principales sont :

- **Django 4.2 LTS** : Framework web
- **PostgreSQL 15** : Base de données
- **Gunicorn** : Serveur WSGI
- **Django REST Framework** : API REST (optionnel)
- **Pytest** : Tests

Voir `requirements.txt` pour la liste complète.

## 🧪 Tests

```bash
# Exécuter les tests
make test

# Voir les logs pendant les tests
make test

# Accéder au shell pour debug
make shell
```

## 📝 Développement

### Mode développement

```bash
# Démarrage avec logs en direct
make dev
```

### Ajouter une dépendance

```bash
# Éditer requirements.txt
echo "nouvelle-lib==1.0.0" >> requirements.txt

# Reconstruire l'image
make build

# Redémarrer
make up
```

### Créer une app Django

```bash
docker-compose exec web python manage.py startapp myapp
```

### Créer les migrations

```bash
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate
```

## 🔍 Debugging

### Voir les logs

```bash
# Tous les services
make logs

# Seulement Django
make logs-web

# Seulement PostgreSQL
make logs-db
```

### Accéder au shell

```bash
# Shell Django
make shell

# Bash du container
make bash-web
```

## 📚 Ressources

- [Django Documentation](https://docs.djangoproject.com/)
- [Docker Documentation](https://docs.docker.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## ⚠️ Production

**Ne pas utiliser en production directement !**

Pour production, adapter :

1. `DEBUG = False`
2. `SECRET_KEY` : Nouvelle clé forte
3. `ALLOWED_HOSTS` : Domaines réels
4. `SECURE_SSL_REDIRECT = True`
5. `SESSION_COOKIE_SECURE = True`
6. `CSRF_COOKIE_SECURE = True`
7. HTTPS / SSL certificate
8. Serveur web (Nginx/Apache)
9. Sauvegarde automatique BD
10. Monitoring & logs centralisés

EOF

    print_success "README.md créé"
}

# Create a basic Django settings template
create_django_template() {
    print_info "Création du template Django..."
    
    mkdir -p "config"
    
    # settings.py
    cat > "config/settings.py" << 'EOF'
import os
from pathlib import Path
from decouple import config, Csv

# Build paths
BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = config('SECRET_KEY', 'django-insecure-change-me-in-production')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = config('DEBUG', default=False, cast=bool)

ALLOWED_HOSTS = config('ALLOWED_HOSTS', default='localhost,127.0.0.1', cast=Csv())

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',
    'django_extensions',
    'health_check',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

if DEBUG:
    MIDDLEWARE.insert(0, 'django_extensions.management.commands.runserver_plus')

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'

# Database
DATABASES = {
    'default': {
        'ENGINE': os.environ.get('DB_ENGINE', 'django.db.backends.postgresql'),
        'NAME': os.environ.get('DB_NAME', 'django_db'),
        'USER': os.environ.get('DB_USER', 'postgres'),
        'PASSWORD': os.environ.get('DB_PASSWORD', 'postgres'),
        'HOST': os.environ.get('DB_HOST', 'localhost'),
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
}

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
LANGUAGE_CODE = 'fr-FR'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# Static files (CSS, JavaScript, Images)
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# Media files
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# REST Framework
REST_FRAMEWORK = {
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
}

# CORS
CORS_ALLOWED_ORIGINS = config('CORS_ALLOWED_ORIGINS', default='http://localhost:8000', cast=Csv())

# Security
SECURE_SSL_REDIRECT = config('SECURE_SSL_REDIRECT', default=False, cast=bool)
SESSION_COOKIE_SECURE = config('SESSION_COOKIE_SECURE', default=False, cast=bool)
CSRF_COOKIE_SECURE = config('CSRF_COOKIE_SECURE', default=False, cast=bool)

# Logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
}
EOF

    # urls.py
    cat > "config/urls.py" << 'EOF'
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('rest_framework.urls')),
    path('health/', include('health_check.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
EOF

    # wsgi.py
    cat > "config/wsgi.py" << 'EOF'
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
application = get_wsgi_application()
EOF

    # manage.py
    cat > "manage.py" << 'EOF'
#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed?"
        ) from exc
    execute_from_command_line(sys.argv)
EOF

    chmod +x "manage.py"

    print_success "Template Django créé: config/settings.py, urls.py, wsgi.py"
}

# Main execution
main() {
    clear
    print_header "🐳 Django Docker Setup Script"
    
    check_docker
    get_user_input
    create_project_structure
    create_dockerfile
    create_docker_compose
    create_env_file
    create_requirements
    create_gitignore
    create_dockerignore
    create_makefile
    create_readme
    create_django_template
    
    print_header "✅ Configuration Complète !"
    
    echo -e "${GREEN}Votre projet Django est prêt !${NC}"
    echo ""
    echo -e "${BLUE}Prochaines étapes:${NC}"
    echo ""
    echo "1. Accédez au répertoire du projet:"
    echo -e "   ${YELLOW}cd $PROJECT_NAME${NC}"
    echo ""
    echo "2. Initialisez le projet:"
    echo -e "   ${YELLOW}make init${NC}"
    echo ""
    echo "3. Accédez à Django:"
    echo -e "   ${YELLOW}http://localhost:${WEB_PORT}${NC}"
    echo ""
    echo "4. Accédez à l'admin Django:"
    echo -e "   ${YELLOW}http://localhost:${WEB_PORT}/admin${NC}"
    echo ""
    echo -e "${BLUE}Commandes utiles:${NC}"
    echo -e "   ${YELLOW}make help${NC}           # Voir toutes les commandes"
    echo -e "   ${YELLOW}make up${NC}             # Démarrer les services"
    echo -e "   ${YELLOW}make down${NC}           # Arrêter les services"
    echo -e "   ${YELLOW}make logs${NC}           # Voir les logs"
    echo -e "   ${YELLOW}make shell${NC}          # Shell Django"
    echo ""
    echo -e "${GREEN}Bonne chance ! 🚀${NC}"
}

# Run main function
main "$@"
