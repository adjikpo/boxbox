# 🚀 Quick Start - Démarrage en 5 minutes

Guide rapide pour lancer le projet React Native + Docker pour la première fois.

---

## ⏱️ Prérequis (2 min)

Assurez-vous d'avoir :
- ✅ Docker Desktop installé ([lien](https://www.docker.com/products/docker-desktop))
- ✅ Git installé
- ✅ Terminal/CMD opérationnel

Vérifier :
```bash
docker --version
# Docker version 20.10+

docker-compose --version
# Docker Compose version 2.0+
```

---

## 🎯 5 étapes pour lancer l'app

### 1️⃣ Cloner le projet (30 sec)

```bash
git clone <URL_DU_REPO>
cd <PROJECT_NAME>
```

### 2️⃣ Configurer l'API (1 min)

```bash
# Copier le template .env
cp api/.env.example api/.env

# (Optionnel) Éditer les variables
nano api/.env  # ou open api/.env sur macOS
```

### 3️⃣ Builder Docker (2-3 min)

```bash
docker-compose build
```

*Cela peut prendre du temps la première fois (télécharge images, installe dépendances)*

### 4️⃣ Lancer les services (30 sec)

```bash
# Option A : Arrière-plan (recommandé)
docker-compose up -d
echo "Attendre 10 secondes pour que les services démarre..."
sleep 10
docker-compose logs -f

# Option B : Foreground (pour voir les logs en direct)
docker-compose up
```

### 5️⃣ Accéder à l'app (30 sec)

**Sur le web** : http://localhost:19006

**Sur téléphone** :
1. Installer **Expo Go** (App Store ou Play Store)
2. Voir le QR code dans les logs :
   ```bash
   docker-compose logs expo | grep "QR Code"
   ```
3. Scannez le QR code avec votre téléphone

---

## 📊 Status check

Vérifier que tout fonctionne :

```bash
# Voir les containers
docker-compose ps

# Résultat attendu:
# NAME              STATUS          PORTS
# <project>-expo-1  Up 2 minutes    0.0.0.0:19006->19006/tcp
# <project>-api-1   Up 2 minutes    0.0.0.0:4000->4000/tcp

# Vérifier API
curl http://localhost:4000/health

# Vérifier les logs
docker-compose logs -f --tail=20
```

---

## 🔧 Commandes essentielles

| Besoin | Commande |
|--------|----------|
| **Redémarrer tout** | `docker-compose restart` |
| **Voir les logs** | `docker-compose logs -f` |
| **Arrêter** | `docker-compose stop` |
| **Nettoyer volumes** | `docker-compose down -v` |
| **Shell interactif** | `docker-compose exec expo sh` |
| **Installer lib** | `docker-compose run --rm cli npm install <LIB>` |

Ou utiliser les raccourcis Makefile :
```bash
make help      # Liste toutes les commandes
make dev       # Démarrage foreground
make logs      # Voir les logs
make clean     # Nettoyer
```

---

## 🐛 Problèmes courants

### ❌ "Port 19006 is already in use"

```bash
# Trouver le processus
lsof -i :19006

# Tuer
kill -9 <PID>

# Ou changer le port dans docker-compose.yml
```

### ❌ "Cannot connect to API"

Vérifier l'IP locale :
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
# Résultat: inet 192.168.1.27

# Mettre à jour docker-compose.yml:
# EXPO_PUBLIC_API_URL=http://192.168.1.27:4000
```

### ❌ "npm install fails"

```bash
docker-compose down -v
docker-compose build --no-cache
docker-compose up
```

### ❌ "Permission denied on api/data"

```bash
mkdir -p api/data
chmod 755 api/data
```

---

## ✅ Checklist premier démarrage

- [ ] Prérequis installés (`docker -v`, `git -v`)
- [ ] Repo cloné
- [ ] `api/.env` créé (depuis `.env.example`)
- [ ] `docker-compose build` réussi
- [ ] `docker-compose up` sans erreurs
- [ ] API répond : http://localhost:4000
- [ ] Frontend visible : http://localhost:19006
- [ ] QR Code affiché dans terminal
- [ ] App charge sur téléphone

---

## 📱 Tester sur téléphone

1. **Installer Expo Go**
   - iOS : App Store
   - Android : Google Play

2. **Scanner QR code**
   ```bash
   docker-compose logs expo | tail -20
   # Chercher: "Scan this QR code"
   ```

3. **Vérifier connexion API**
   - Adapter `EXPO_PUBLIC_API_URL` si besoin
   - Redémarrer : `docker-compose restart expo`

---

## 🎓 Prochaines étapes

- Lire [README.md](./README.md) pour documentation complète
- Lire [ARCHITECTURE.md](./ARCHITECTURE.md) pour comprendre la structure
- Consulter [Makefile](./Makefile) pour tous les raccourcis disponibles
- Explorer les logs : `docker-compose logs -f`

---

## 💡 Astuces

```bash
# Redémarrage rapide
docker-compose restart

# Voir uniquement les logs d'erreur
docker-compose logs | grep -i error

# Nettoyer en profondeur (WARNING: supprime tous les volumes)
docker-compose down -v
rm -rf api/data
docker-compose up --build

# Entrer dans le container pour debug
docker-compose exec expo sh
cd LedgerTrack
npm list  # voir les packages installés
```

---

**Vous êtes prêt ! 🎉**

En cas de problème, consultez :
- [Troubleshooting dans README](./README.md#-troubleshooting)
- [Documentation Docker](https://docs.docker.com)
- Logs détaillés : `docker-compose logs -f`
