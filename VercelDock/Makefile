.DEFAULT_GOAL := help
.PHONY: help build up down logs clean install dev restart stop create-project shell add-package build-prod db-shell

# Variables - MODIFIER ICI LE NOM DU PROJET
PROJECT_NAME ?= myapp

# Couleurs pour l'affichage
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m

help:
	@echo "$(BLUE)Next.js / Vercel + Supabase Docker Commands$(NC)"
	@echo ""
	@echo "$(GREEN)Initialisation$(NC)"
	@echo "  make build                    # Construire les images Docker"
	@echo "  make create-project           # Creer un nouveau projet Next.js"
	@echo "  make install                  # Installer les dependances pnpm"
	@echo ""
	@echo "$(GREEN)Developpement$(NC)"
	@echo "  make up                       # Demarrer les services en arriere-plan"
	@echo "  make dev                      # Demarrer avec logs"
	@echo "  make down                     # Arreter les services"
	@echo "  make stop                     # Pause les services"
	@echo "  make restart                  # Redemarrer les services"
	@echo ""
	@echo "$(GREEN)Utilitaires$(NC)"
	@echo "  make shell                    # Shell dans le container"
	@echo "  make logs                     # Voir tous les logs"
	@echo "  make logs-web                 # Logs Next.js uniquement"
	@echo "  make logs-db                  # Logs PostgreSQL uniquement"
	@echo "  make add-package PKG=name     # Ajouter un package pnpm"
	@echo "  make build-prod               # Build de production"
	@echo "  make db-shell                 # Acceder a PostgreSQL"
	@echo ""
	@echo "$(GREEN)Nettoyage$(NC)"
	@echo "  make clean                    # Supprimer containers et volumes"
	@echo "  make prune                    # Nettoyage complet Docker"
	@echo ""
	@echo "$(YELLOW)Note: Modifier PROJECT_NAME dans le Makefile$(NC)"
	@echo ""

# ==================== Build ====================

build:
	@echo "$(BLUE)Construction des images Docker...$(NC)"
	docker-compose build
	@echo "$(GREEN)Images construites!$(NC)"

# ==================== Creation de projet ====================

create-project:
	@echo "$(BLUE)Creation du projet Next.js: $(PROJECT_NAME)...$(NC)"
	docker-compose run --rm create npx create-next-app@latest $(PROJECT_NAME) --typescript --tailwind --eslint --app --src-dir --use-pnpm
	@echo "$(GREEN)Projet $(PROJECT_NAME) cree!$(NC)"
	@echo ""
	@echo "$(YELLOW)Prochaines etapes:$(NC)"
	@echo "  1. cp Dockerfile Dockerfile.dev docker-compose.yml Makefile .dockerignore $(PROJECT_NAME)/"
	@echo "  2. cd $(PROJECT_NAME)"
	@echo "  3. make install"
	@echo "  4. make dev"

# ==================== Installation ====================

install:
	@echo "$(BLUE)Installation des dependances pnpm...$(NC)"
	docker-compose run --rm cli pnpm install
	@echo "$(GREEN)Dependances installees!$(NC)"

# ==================== Demarrage ====================

up:
	@echo "$(BLUE)Demarrage des services en arriere-plan...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)Services demarres!$(NC)"
	@echo ""
	@echo "Acces:"
	@echo "  - Next.js App: http://localhost:3000"
	@echo "  - PostgreSQL: localhost:5432"
	@echo ""
	@echo "Voir les logs: make logs"

dev:
	@echo "$(BLUE)Demarrage avec logs...$(NC)"
	docker-compose up

down:
	@echo "$(YELLOW)Arret des services...$(NC)"
	docker-compose down

stop:
	@echo "$(YELLOW)Pause des services...$(NC)"
	docker-compose stop

restart:
	@echo "$(YELLOW)Redemarrage des services...$(NC)"
	docker-compose restart
	@echo "$(GREEN)Services redemarres!$(NC)"

# ==================== Utilitaires ====================

shell:
	@echo "$(BLUE)Shell interactif...$(NC)"
	docker-compose run --rm cli sh

logs:
	@echo "$(BLUE)Logs de tous les services (Ctrl+C pour quitter)...$(NC)"
	docker-compose logs -f

logs-web:
	@echo "$(BLUE)Logs Next.js (Ctrl+C pour quitter)...$(NC)"
	docker-compose logs -f web

logs-db:
	@echo "$(BLUE)Logs PostgreSQL (Ctrl+C pour quitter)...$(NC)"
	docker-compose logs -f supabase-db

add-package:
ifndef PKG
	@echo "$(YELLOW)Usage: make add-package PKG=nom-du-package$(NC)"
else
	@echo "$(BLUE)Installation de $(PKG)...$(NC)"
	docker-compose run --rm cli pnpm add $(PKG)
	@echo "$(GREEN)$(PKG) installe!$(NC)"
endif

build-prod:
	@echo "$(BLUE)Build de production...$(NC)"
	docker-compose run --rm cli pnpm build
	@echo "$(GREEN)Build termine!$(NC)"

db-shell:
	@echo "$(BLUE)Acces a PostgreSQL...$(NC)"
	docker-compose exec supabase-db psql -U postgres -d postgres

# ==================== Nettoyage ====================

clean:
	@echo "$(YELLOW)Suppression des containers et volumes...$(NC)"
	docker-compose down -v
	@echo "$(GREEN)Nettoyage termine!$(NC)"

prune:
	@echo "$(YELLOW)Nettoyage complet Docker...$(NC)"
	docker-compose down -v
	docker system prune -f
	@echo "$(GREEN)Nettoyage termine!$(NC)"

# ==================== Alias ====================

init: build create-project
	@echo "$(GREEN)Initialisation terminee!$(NC)"
	@echo "Suivre les instructions ci-dessus pour continuer."

ps:
	@echo "$(BLUE)Etat des containers:$(NC)"
	docker-compose ps

# ==================== Supabase ====================

supabase-install:
	@echo "$(BLUE)Installation du client Supabase...$(NC)"
	docker-compose run --rm cli pnpm add @supabase/supabase-js
	@echo "$(GREEN)Supabase client installe!$(NC)"
