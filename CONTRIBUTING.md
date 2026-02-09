# Contributing to BoxBox

Merci de contribuer à BoxBox ! Voici comment ajouter un nouveau Dock.

## Ajouter un nouveau template (Dock)

1. **Créer un dossier** `NomDock/` à la racine du repo
2. **Fichiers requis** :
   - `docker-compose.yml` — services Docker (pas de `version:`, c'est deprecated)
   - `Dockerfile` — image de production
   - `Makefile` — commandes standard (build, up, dev, down, logs, clean, install, status, test, lint, typecheck)
   - `README.md` — documentation du template
   - `PROMPT_GENERATOR.md` — prompt IA pour générer l'architecture
   - `.dockerignore`
3. **Conventions Makefile** :
   - Inclure les targets : `help`, `build`, `up`, `dev`, `down`, `logs`, `clean`, `install`, `status`, `test`, `lint`, `typecheck`
   - Utiliser les couleurs (BLUE, GREEN, YELLOW, NC)
   - Variable `PROJECT_NAME` configurable
4. **Mettre à jour** :
   - `README.md` racine — ajouter le template dans le tableau
   - `CHANGELOG.md` — documenter l'ajout
   - `boxbox.sh` — ajouter le template dans le CLI
5. **Tester** : `make build && make create-project` doit fonctionner

## Conventions

- Pas de `version:` dans docker-compose.yml (Compose V2)
- Node 22 Alpine pour les images Node.js
- Healthchecks sur les services principaux
- Placeholders `[NOM_DU_PROJET]` uniformisés

## Pull Request

1. Fork + branche feature
2. Appliquer les changements
3. Tester le template end-to-end
4. PR avec description claire
