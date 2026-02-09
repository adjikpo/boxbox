#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Couleurs
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
    echo -e "${BLUE}BoxBox CLI${NC} — Docker Templates Collection"
    echo ""
    echo "Usage:"
    echo "  ./boxbox.sh list                              Liste les templates disponibles"
    echo "  ./boxbox.sh new <nom> --template <template>   Crée un nouveau projet"
    echo ""
    echo "Templates: vercel, django, rn"
    echo ""
    echo "Exemple:"
    echo "  ./boxbox.sh new myapp --template vercel"
}

cmd_list() {
    echo -e "${BLUE}Templates disponibles :${NC}"
    echo ""
    echo -e "  ${GREEN}vercel${NC}    Next.js + Supabase (VercelDock)"
    echo -e "  ${GREEN}django${NC}    Django + PostgreSQL (DjangoDock)"
    echo -e "  ${GREEN}rn${NC}        React Native + Expo (RNDock)"
}

cmd_new() {
    local name="$1"
    local template=""

    if [ -z "$name" ]; then
        echo -e "${RED}Erreur: nom du projet requis${NC}"
        usage
        exit 1
    fi

    shift
    while [ $# -gt 0 ]; do
        case "$1" in
            --template) template="$2"; shift 2 ;;
            *) echo -e "${RED}Option inconnue: $1${NC}"; exit 1 ;;
        esac
    done

    if [ -z "$template" ]; then
        echo -e "${RED}Erreur: --template requis${NC}"
        usage
        exit 1
    fi

    local dock_dir=""
    case "$template" in
        vercel) dock_dir="VercelDock" ;;
        django) dock_dir="DjangoDock" ;;
        rn)     dock_dir="RNDock" ;;
        *) echo -e "${RED}Template inconnu: $template${NC}"; cmd_list; exit 1 ;;
    esac

    echo -e "${BLUE}Création du projet '$name' avec le template '$template'...${NC}"

    cd "$SCRIPT_DIR/$dock_dir"

    if [ "$template" = "django" ]; then
        echo -e "${YELLOW}Lancement du setup interactif Django...${NC}"
        chmod +x setup.sh
        ./setup.sh
    else
        PROJECT_NAME="$name" make create-project

        echo -e "${BLUE}Copie des fichiers Docker dans $name/...${NC}"
        for f in Dockerfile Dockerfile.dev docker-compose.yml Makefile .dockerignore .node-version; do
            [ -f "$f" ] && cp "$f" "$name/"
        done

        echo -e "${GREEN}Projet '$name' créé dans $dock_dir/$name/${NC}"
        echo ""
        echo -e "${YELLOW}Prochaines étapes :${NC}"
        echo "  cd $dock_dir/$name"
        echo "  make install"
        echo "  make dev"
    fi
}

case "${1:-}" in
    list) cmd_list ;;
    new)  shift; cmd_new "$@" ;;
    *)    usage ;;
esac
