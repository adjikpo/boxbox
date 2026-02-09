#!/usr/bin/env bash
# BoxBox CLI - Scaffolding rapide de projets Docker
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
    echo -e "${BLUE}BoxBox CLI${NC} - Templates Docker cle en main"
    echo ""
    echo "Usage:"
    echo "  boxbox new <nom> --template <vercel|django|rn>    Creer un nouveau projet"
    echo "  boxbox list                                        Lister les templates"
    echo "  boxbox help                                        Afficher cette aide"
    echo ""
}

cmd_list() {
    echo -e "${BLUE}Templates disponibles:${NC}"
    echo ""
    echo -e "  ${GREEN}vercel${NC}    Next.js + Supabase (VercelDock)"
    echo -e "  ${GREEN}django${NC}    Django + PostgreSQL (DjangoDock)"
    echo -e "  ${GREEN}rn${NC}        React Native + Expo (RNDock)"
    echo ""
}

cmd_new() {
    local name="$1"
    local template=""

    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --template|-t) template="$2"; shift 2 ;;
            *) echo -e "${RED}Option inconnue: $1${NC}"; exit 1 ;;
        esac
    done

    if [[ -z "$name" ]]; then
        echo -e "${RED}Erreur: nom du projet requis${NC}"
        usage; exit 1
    fi
    if [[ -z "$template" ]]; then
        echo -e "${RED}Erreur: --template requis (vercel|django|rn)${NC}"
        usage; exit 1
    fi

    local src_dir=""
    case "$template" in
        vercel)  src_dir="$SCRIPT_DIR/VercelDock" ;;
        django)  src_dir="$SCRIPT_DIR/DjangoDock" ;;
        rn)      src_dir="$SCRIPT_DIR/RNDock" ;;
        *)       echo -e "${RED}Template inconnu: $template${NC}"; cmd_list; exit 1 ;;
    esac

    echo -e "${BLUE}Creation du projet '$name' avec le template '$template'...${NC}"
    mkdir -p "$name"
    cp -r "$src_dir"/. "$name"/
    
    # Remplacer les placeholders
    if command -v sed &>/dev/null; then
        find "$name" -type f \( -name "*.yml" -o -name "*.yaml" -o -name "Makefile" \) -exec sed -i '' "s/\[NOM_DU_PROJET\]/$name/g" {} + 2>/dev/null || true
    fi

    echo -e "${GREEN}Projet '$name' cree dans ./$name/${NC}"
    echo ""
    echo -e "${YELLOW}Prochaines etapes:${NC}"
    echo "  cd $name"
    case "$template" in
        vercel)  echo "  make init" ;;
        django)  echo "  chmod +x setup.sh && ./setup.sh" ;;
        rn)      echo "  make init" ;;
    esac
}

# Main
case "${1:-help}" in
    new)   shift; cmd_new "$@" ;;
    list)  cmd_list ;;
    help)  usage ;;
    *)     usage; exit 1 ;;
esac
