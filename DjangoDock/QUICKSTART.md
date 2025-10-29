# ⚡ Quick Start - DjangoDock en 5 minutes

Créez un projet Django avec Docker en moins de 5 minutes.

---

## 🚀 Étape 1 : Lancer le script (2 min)

```bash
cd /Users/adjikpo/Documents/Projets/boxbox/DjangoDock
chmod +x setup.sh
./setup.sh
```

## 🎯 Étape 2 : Configuration interactif (1 min)

```bash
Nom du projet (défaut: django_project): ↵  (ou votre nom)
Port web Django (défaut: 8000): ↵
Port PostgreSQL (défaut: 5432): ↵
Version Django LTS (défaut: 4.2): ↵
Version Python (défaut: 3.11): ↵
Nom de la base de données (défaut: X_db): ↵
Utilisateur PostgreSQL (défaut: postgres): ↵
Mot de passe PostgreSQL (défaut: postgres): ↵

Continuer ? (y/n): y
```

## ✅ Étape 3 : Initialiser (2 min)

```bash
cd django_project
make init
```

*Cela lance automatiquement :*
- Build Docker image
- Démarrage PostgreSQL + Django
- Migrations BD
- Création superuser (interactive)

## 🌐 Étape 4 : Accéder

```
Django Admin : http://localhost:8000/admin
Django Home : http://localhost:8000
```

*Utilisez les credentials créés lors de `make init`*

---

## 📋 Commandes essentielles

```bash
make help              # Voir toutes les commandes
make up                # Démarrer
make down              # Arrêter
make logs              # Voir les logs
make shell             # Django shell
make migrate           # Migrations
make createsuperuser   # Nouvel admin
make test              # Tests
make clean             # Nettoyer (⚠️ supprime les données)
```

---

## 🔧 Changer le port

```bash
# Éditer .env
PORT=8080

# Redémarrer
make restart

# Accéder à
http://localhost:8080
```

---

## 🐛 Troubleshooting rapide

**"Port 8000 already in use"**
```bash
PORT=8080 make restart
```

**"Connection refused"**
```bash
make clean
make build
make up
```

**Module not found**
```bash
echo "module-name" >> requirements.txt
make build
make restart
```

---

## 📚 Documentation complète

- **README.md** : Documentation générale
- **GUIDE.md** : Guide détaillé pas-à-pas
- **RAPPORT_FINAL.txt** : Rapport complet

---

## ✨ Prochaines étapes

1. Consulter le README.md pour les options
2. Créer une app : `docker-compose exec web python manage.py startapp myapp`
3. Développer : `make dev` (logs en direct)
4. Lire GUIDE.md pour la gestion BD et dépendances

---

**DjangoDock - Créez des projets Django en 5 min ! 🐳**
