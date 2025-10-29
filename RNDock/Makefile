.DEFAULT_GOAL := help
.PHONY: help build up down logs clean install dev restart stop

# Couleurs pour l'affichage
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)📦 Commandes Docker Compose disponibles:$(NC)"
	@echo ""
	@echo "$(GREEN)Build & Démarrage$(NC)"
	@echo "  make build             # Construire les images Docker"
	@echo "  make up                # Démarrer tous les services"
	@echo "  make dev               # Démarrer en mode développement (foreground)"
	@echo "  make down              # Arrêter les services"
	@echo "  make stop              # Pause les services (sans les détruire)"
	@echo ""
	@echo "$(GREEN)Développement$(NC)"
	@echo "  make install           # Installer les dépendances (npm install)"
	@echo "  make shell-expo        # Shell interactif dans le container Expo"
	@echo "  make shell-api         # Shell interactif dans le container API"
	@echo "  make logs              # Afficher les logs de tous les services"
	@echo "  make logs-expo         # Logs du service Expo"
	@echo "  make logs-api          # Logs du service API"
	@echo "  make restart           # Redémarrer tous les services"
	@echo "  make restart-expo      # Redémarrer Expo"
	@echo "  make restart-api       # Redémarrer l'API"
	@echo ""
	@echo "$(GREEN)Nettoyage$(NC)"
	@echo "  make clean             # Arrêter et supprimer volumes (⚠️ données perdues)"
	@echo "  make prune             # Nettoyer images et volumes inutilisés"
	@echo ""
	@echo "$(YELLOW)⚠️  Attention:$(NC)"
	@echo "  - 'make clean' supprime tous les volumes (BD, cache npm, etc)"
	@echo "  - Toujours commiter .env.example, jamais .env"
	@echo ""

# ==================== Build et Démarrage ====================

build:
	@echo "$(BLUE)🏗️  Construction des images Docker...$(NC)"
	docker-compose build

up:
	@echo "$(BLUE)🚀 Démarrage des services en arrière-plan...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✅ Services lancés!$(NC)"
	@echo ""
	@echo "Accès:"
	@echo "  - Frontend Expo (Web): http://localhost:19006"
	@echo "  - Backend API: http://localhost:4000"
	@echo "  - QR Code Expo: voir 'make logs-expo'"

dev:
	@echo "$(BLUE)🎯 Démarrage en mode développement (foreground)...$(NC)"
	docker-compose up

stop:
	@echo "$(YELLOW)⏸️  Pause des services...$(NC)"
	docker-compose stop

down:
	@echo "$(YELLOW)🛑 Arrêt des services...$(NC)"
	docker-compose down

# ==================== Développement ====================

install:
	@echo "$(BLUE)📦 Installation des dépendances...$(NC)"
	docker-compose run --rm cli npm install
	@echo "$(GREEN)✅ Dépendances installées!$(NC)"

shell-expo:
	@echo "$(BLUE)🔧 Shell interactif Expo...$(NC)"
	docker-compose exec expo sh

shell-api:
	@echo "$(BLUE)🔧 Shell interactif API...$(NC)"
	docker-compose exec api sh

logs:
	@echo "$(BLUE)📋 Logs de tous les services (Ctrl+C pour quitter)...$(NC)"
	docker-compose logs -f

logs-expo:
	@echo "$(BLUE)📋 Logs Expo (Ctrl+C pour quitter)...$(NC)"
	docker-compose logs -f expo

logs-api:
	@echo "$(BLUE)📋 Logs API (Ctrl+C pour quitter)...$(NC)"
	docker-compose logs -f api

restart:
	@echo "$(YELLOW)🔄 Redémarrage de tous les services...$(NC)"
	docker-compose restart
	@echo "$(GREEN)✅ Services redémarrés!$(NC)"

restart-expo:
	@echo "$(YELLOW)🔄 Redémarrage Expo...$(NC)"
	docker-compose restart expo

restart-api:
	@echo "$(YELLOW)🔄 Redémarrage API...$(NC)"
	docker-compose restart api

# ==================== Nettoyage ====================

clean:
	@echo "$(YELLOW)⚠️  Suppression de TOUS les containers et volumes...$(NC)"
	docker-compose down -v
	@echo "$(RED)✅ Volumes supprimés (données perdues si pas de backup)$(NC)"

prune:
	@echo "$(YELLOW)🧹 Nettoyage des ressources inutilisées...$(NC)"
	docker-compose down
	docker volume prune -f
	docker system prune -f
	@echo "$(GREEN)✅ Nettoyage terminé!$(NC)"

# ==================== Utilitaires ====================

ps:
	@echo "$(BLUE)📊 État des containers:$(NC)"
	docker-compose ps

version:
	@echo "$(BLUE)📌 Versions:$(NC)"
	@echo "Docker: $$(docker --version)"
	@echo "Docker Compose: $$(docker-compose --version)"
	@echo "Node (dans le container): $$(docker-compose run --rm cli node --version)"
	@echo "npm (dans le container): $$(docker-compose run --rm cli npm --version)"

# Alias utiles
init: build up
	@echo "$(GREEN)✨ Initialisation complète!$(NC)"

status: ps
