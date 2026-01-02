# Quick Start - DjangoDock en 5 minutes

Creez un projet Django avec Docker en moins de 5 minutes.

---

## Etape 1 : Lancer le script

```bash
# Copier DjangoDock dans votre dossier
cp -r DjangoDock ~/mon-projet
cd ~/mon-projet

# Lancer le script
chmod +x setup.sh
./setup.sh
```

## Etape 2 : Configuration interactive

```bash
Nom du projet (defaut: django_project): [NOM_DU_PROJET]
Port web Django (defaut: 8000): 8000
Port PostgreSQL (defaut: 5432): 5432
Version Django LTS (defaut: 4.2): 4.2
Version Python (defaut: 3.11): 3.11
Nom de la base de donnees (defaut: X_db): [NOM_DU_PROJET]_db
Utilisateur PostgreSQL (defaut: postgres): postgres
Mot de passe PostgreSQL (defaut: postgres): ****

Continuer ? (y/n): y
```

## Etape 3 : Initialiser le projet

```bash
cd [NOM_DU_PROJET]
make init
```

Cela lance automatiquement :
- Build de l'image Docker
- Demarrage PostgreSQL + Django
- Migrations BD
- Creation superuser (interactive)

## Etape 4 : Acceder a l'application

```
Django Admin : http://localhost:8000/admin
Django Home  : http://localhost:8000
```

---

## Commandes essentielles

```bash
make help              # Voir toutes les commandes
make up                # Demarrer
make down              # Arreter
make dev               # Demarrer avec logs
make logs              # Voir les logs
make shell             # Django shell
make migrate           # Migrations
make createsuperuser   # Nouvel admin
make test              # Tests
make clean             # Nettoyer (supprime les donnees)
```

---

## Alternative : Utiliser le prompt IA

Si tu preferes generer l'architecture via une IA, voir [PROMPT_GENERATOR.md](PROMPT_GENERATOR.md).

---

## Troubleshooting rapide

**"Port 8000 already in use"**
```bash
# Modifier PORT dans .env puis :
make restart
```

**"Connection refused"**
```bash
make clean && make build && make up
```

**Module not found**
```bash
echo "module-name" >> requirements.txt
make build && make restart
```

---

**DjangoDock** - Creez des projets Django containerises en 5 min !
