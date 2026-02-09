.DEFAULT_GOAL := help
.PHONY: help build up down logs clean install dev restart stop create-project shell add-package tunnel web init test lint typecheck status

# Variables - MODIFIER ICI LE NOM DU PROJET
PROJECT_NAME ?= App

# Couleurs pour l'affichage
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m

help:
	@echo "$(BLUE)React Native / Expo Docker Commands$(NC)"
	@echo ""
	@echo "$(GREEN)Initialisation$(NC)"
	@echo "  make init                     # Setup complet one-shot"
	@echo "  make build                    # Construire l'image Docker"
	@echo "  make create-project           # Creer un nouveau projet Expo"
	@echo "  make install                  # Installer les dependances npm"
	@echo ""
	@echo "$(GREEN)Developpement$(NC)"
	@echo "  make up                       # Demarrer Expo en arriere-plan"
	@echo "  make dev                      # Demarrer Expo avec logs"
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
	@echo "  make shell                    # Shell dans le container Expo"
	@echo "  make logs                     # Voir les logs"
	@echo "  make status                   # Etat des containers + URLs"
	@echo "  make add-package PKG=name     # Ajouter un package npm"
	@echo "  make tunnel                   # Lancer en mode tunnel"
	@echo "  make web                      # Lancer en mode web"
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
	@$(MAKE) install
	@echo "$(GREEN)Init terminee! Lancer: make dev$(NC)"

# ==================== Build ====================

build:
	@echo "$(BLUE)Construction de l'image Docker...$(NC)"
	docker compose build
	@echo "$(GREEN)Image construite!$(NC)"

# ==================== Creation de projet ====================

create-project:
	@echo "$(BLUE)Creation du projet Expo: $(PROJECT_NAME)...$(NC)"
	docker compose run --rm create npx create-expo-app $(PROJECT_NAME) --template blank
	@echo "$(GREEN)Projet $(PROJECT_NAME) cree!$(NC)"
	@echo ""
	@echo "$(YELLOW)Prochaine etape: make install$(NC)"

# ==================== Installation ====================

install:
	@echo "$(BLUE)Installation des dependances npm...$(NC)"
	docker compose run --rm cli npm install
	@echo "$(GREEN)Dependances installees!$(NC)"

# ==================== Demarrage ====================

up:
	@echo "$(BLUE)Demarrage d'Expo en arriere-plan...$(NC)"
	docker compose up -d expo
	@echo "$(GREEN)Expo demarre!$(NC)"
	@echo ""
	@echo "Acces:"
	@echo "  - Expo DevTools: http://localhost:19002"
	@echo "  - Metro Bundler: http://localhost:8081"
	@echo "  - App Web: http://localhost:19006"
	@echo ""
	@echo "Voir les logs: make logs"

dev:
	@echo "$(BLUE)Demarrage d'Expo avec logs...$(NC)"
	docker compose up expo

down:
	@echo "$(YELLOW)Arret des services...$(NC)"
	docker compose down

stop:
	@echo "$(YELLOW)Pause des services...$(NC)"
	docker compose stop

restart:
	@echo "$(YELLOW)Redemarrage des services...$(NC)"
	docker compose restart expo
	@echo "$(GREEN)Services redemarres!$(NC)"

# ==================== Qualite ====================

test:
	@echo "$(BLUE)Lancement des tests...$(NC)"
	docker compose run --rm cli npm test

lint:
	@echo "$(BLUE)Linting...$(NC)"
	docker compose run --rm cli npx expo lint

typecheck:
	@echo "$(BLUE)Type checking...$(NC)"
	docker compose run --rm cli npx tsc --noEmit

# ==================== Utilitaires ====================

shell:
	@echo "$(BLUE)Shell interactif Expo...$(NC)"
	docker compose run --rm cli sh

logs:
	@echo "$(BLUE)Logs Expo (Ctrl+C pour quitter)...$(NC)"
	docker compose logs -f expo

status:
	@echo "$(BLUE)Etat des services:$(NC)"
	@docker compose ps
	@echo ""
	@echo "$(GREEN)URLs:$(NC)"
	@echo "  - Expo DevTools: http://localhost:19002"
	@echo "  - Metro Bundler: http://localhost:8081"
	@echo "  - App Web: http://localhost:19006"

add-package:
ifndef PKG
	@echo "$(YELLOW)Usage: make add-package PKG=nom-du-package$(NC)"
else
	@echo "$(BLUE)Installation de $(PKG)...$(NC)"
	docker compose run --rm cli npm install $(PKG)
	@echo "$(GREEN)$(PKG) installe!$(NC)"
endif

tunnel:
	@echo "$(BLUE)Lancement en mode tunnel...$(NC)"
	docker compose run --rm -p 19000:19000 -p 19001:19001 -p 19002:19002 cli npx expo start --tunnel

web:
	@echo "$(BLUE)Lancement en mode web...$(NC)"
	docker compose run --rm -p 19006:19006 -p 8081:8081 cli npx expo start --web

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
