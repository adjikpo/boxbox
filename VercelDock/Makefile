.DEFAULT_GOAL := help
.PHONY: help build up down logs clean install dev restart stop create-project shell add-package build-prod db-shell init test lint typecheck status db-dump db-restore

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
	@echo "  make init                     # Setup complet one-shot"
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
	@echo "$(GREEN)Qualite$(NC)"
	@echo "  make test                     # Lancer les tests"
	@echo "  make lint                     # Linter le code"
	@echo "  make typecheck                # Verifier les types TypeScript"
	@echo ""
	@echo "$(GREEN)Utilitaires$(NC)"
	@echo "  make shell                    # Shell dans le container"
	@echo "  make logs                     # Voir tous les logs"
	@echo "  make status                   # Etat des containers + URLs"
	@echo "  make add-package PKG=name     # Ajouter un package pnpm"
	@echo "  make build-prod               # Build de production"
	@echo "  make db-shell                 # Acceder a PostgreSQL"
	@echo "  make db-dump                  # Dump de la base de donnees"
	@echo "  make db-restore SQL=file.sql  # Restaurer la base de donnees"
	@echo ""
	@echo "$(GREEN)Nettoyage$(NC)"
	@echo "  make clean                    # Supprimer containers et volumes"
	@echo "  make prune                    # Nettoyage complet Docker"
	@echo ""
	@echo "$(YELLOW)Note: Modifier PROJECT_NAME dans le Makefile$(NC)"
	@echo ""

# ==================== Initialisation ====================

init:
	@echo "$(BLUE)Setup complet one-shot...$(NC)"
	@$(MAKE) build
	@$(MAKE) create-project
	@echo "$(BLUE)Copie des fichiers Docker dans $(PROJECT_NAME)/...$(NC)"
	cp Dockerfile Dockerfile.dev docker-compose.yml Makefile .dockerignore .env.local.example $(PROJECT_NAME)/ 2>/dev/null || true
	@echo "$(YELLOW)→ cd $(PROJECT_NAME) && make install && make dev$(NC)"
	@echo "$(GREEN)Init terminee!$(NC)"

# ==================== Build ====================

build:
	@echo "$(BLUE)Construction des images Docker...$(NC)"
	docker compose build
	@echo "$(GREEN)Images construites!$(NC)"

# ==================== Creation de projet ====================

create-project:
	@echo "$(BLUE)Creation du projet Next.js: $(PROJECT_NAME)...$(NC)"
	docker compose run --rm create npx create-next-app@latest $(PROJECT_NAME) --typescript --tailwind --eslint --app --src-dir --use-pnpm
	@echo "$(GREEN)Projet $(PROJECT_NAME) cree!$(NC)"

# ==================== Installation ====================

install:
	@echo "$(BLUE)Installation des dependances pnpm...$(NC)"
	docker compose run --rm cli pnpm install
	@echo "$(GREEN)Dependances installees!$(NC)"

# ==================== Demarrage ====================

up:
	@echo "$(BLUE)Demarrage des services en arriere-plan...$(NC)"
	docker compose up -d
	@echo "$(GREEN)Services demarres!$(NC)"
	@echo ""
	@echo "Acces:"
	@echo "  - Next.js App: http://localhost:3000"
	@echo "  - PostgreSQL: localhost:5432"
	@echo "  - Studio (--profile full): http://localhost:3001"
	@echo ""
	@echo "Voir les logs: make logs"

dev:
	@echo "$(BLUE)Demarrage avec logs...$(NC)"
	docker compose up

down:
	@echo "$(YELLOW)Arret des services...$(NC)"
	docker compose down

stop:
	@echo "$(YELLOW)Pause des services...$(NC)"
	docker compose stop

restart:
	@echo "$(YELLOW)Redemarrage des services...$(NC)"
	docker compose restart
	@echo "$(GREEN)Services redemarres!$(NC)"

# ==================== Qualite ====================

test:
	@echo "$(BLUE)Lancement des tests...$(NC)"
	docker compose run --rm cli pnpm test

lint:
	@echo "$(BLUE)Linting...$(NC)"
	docker compose run --rm cli pnpm lint

typecheck:
	@echo "$(BLUE)Type checking...$(NC)"
	docker compose run --rm cli pnpm tsc --noEmit

# ==================== Utilitaires ====================

shell:
	@echo "$(BLUE)Shell interactif...$(NC)"
	docker compose run --rm cli sh

logs:
	@echo "$(BLUE)Logs de tous les services (Ctrl+C pour quitter)...$(NC)"
	docker compose logs -f

logs-web:
	@echo "$(BLUE)Logs Next.js (Ctrl+C pour quitter)...$(NC)"
	docker compose logs -f web

logs-db:
	@echo "$(BLUE)Logs PostgreSQL (Ctrl+C pour quitter)...$(NC)"
	docker compose logs -f supabase-db

status:
	@echo "$(BLUE)Etat des services:$(NC)"
	@docker compose ps
	@echo ""
	@echo "$(GREEN)URLs:$(NC)"
	@echo "  - Next.js App: http://localhost:3000"
	@echo "  - PostgreSQL: localhost:5432"
	@echo "  - Studio (--profile full): http://localhost:3001"

add-package:
ifndef PKG
	@echo "$(YELLOW)Usage: make add-package PKG=nom-du-package$(NC)"
else
	@echo "$(BLUE)Installation de $(PKG)...$(NC)"
	docker compose run --rm cli pnpm add $(PKG)
	@echo "$(GREEN)$(PKG) installe!$(NC)"
endif

build-prod:
	@echo "$(BLUE)Build de production...$(NC)"
	docker compose run --rm cli pnpm build
	@echo "$(GREEN)Build termine!$(NC)"

db-shell:
	@echo "$(BLUE)Acces a PostgreSQL...$(NC)"
	docker compose exec supabase-db psql -U postgres -d postgres

db-dump:
	@echo "$(BLUE)Dump de la base de donnees...$(NC)"
	docker compose exec supabase-db pg_dump -U postgres postgres > dump_$$(date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)Dump cree!$(NC)"

db-restore:
ifndef SQL
	@echo "$(YELLOW)Usage: make db-restore SQL=fichier.sql$(NC)"
else
	@echo "$(BLUE)Restauration de la base de donnees...$(NC)"
	cat $(SQL) | docker compose exec -T supabase-db psql -U postgres -d postgres
	@echo "$(GREEN)Base restauree!$(NC)"
endif

# ==================== Nettoyage ====================

clean:
	@echo "$(YELLOW)Suppression des containers et volumes...$(NC)"
	docker compose down -v
	@echo "$(GREEN)Nettoyage termine!$(NC)"

prune:
	@echo "$(YELLOW)Nettoyage complet Docker...$(NC)"
	docker compose down -v
	docker system prune -f
	@echo "$(GREEN)Nettoyage termine!$(NC)"

# ==================== Alias ====================

ps:
	@echo "$(BLUE)Etat des containers:$(NC)"
	docker compose ps

# ==================== Supabase ====================

supabase-install:
	@echo "$(BLUE)Installation du client Supabase...$(NC)"
	docker compose run --rm cli pnpm add @supabase/supabase-js
	@echo "$(GREEN)Supabase client installe!$(NC)"
