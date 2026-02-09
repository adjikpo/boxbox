# Contributing to BoxBox

Merci de contribuer a BoxBox ! 🐳

## Comment contribuer

### Signaler un bug
1. Verifier que le bug n'est pas deja signale dans les [Issues](../../issues)
2. Creer une issue avec un titre clair et les etapes pour reproduire

### Proposer une amelioration
1. Ouvrir une issue pour discuter de l'idee
2. Forker le repo et creer une branche (`git checkout -b feature/ma-feature`)
3. Commiter vos changements (`git commit -m "feat: description"`)
4. Pousser la branche (`git push origin feature/ma-feature`)
5. Ouvrir une Pull Request

## Conventions

### Commits
On utilise [Conventional Commits](https://www.conventionalcommits.org/) :
- `feat:` nouvelle fonctionnalite
- `fix:` correction de bug
- `docs:` documentation
- `chore:` maintenance

### Structure des templates
Chaque template doit contenir :
- `README.md` — Documentation du template
- `PROMPT_GENERATOR.md` — Prompt pour generation IA
- `Makefile` ou `setup.sh` — Commandes de setup
- `docker-compose.yml` — Services Docker
- Les commandes Makefile standard : `init`, `build`, `up`, `down`, `dev`, `test`, `lint`, `typecheck`, `status`, `clean`

### Tests
Avant de soumettre une PR :
```bash
# Verifier la syntaxe des scripts
bash -n DjangoDock/setup.sh
# Verifier que les Makefiles sont valides
make -n -f VercelDock/Makefile help
make -n -f RNDock/Makefile help
```

## Setup local

```bash
git clone https://github.com/adjikpo/boxbox.git
cd boxbox
git checkout -b feature/ma-feature
```

## Questions ?

Ouvrir une issue ou contacter les mainteneurs.

---

**BoxBox** - Templates Docker cle en main
