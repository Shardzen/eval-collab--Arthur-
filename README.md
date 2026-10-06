# eval-collab-arthur

Projet d'entraînement infra : une petite stack conteneurisée (reverse proxy, application, base de données) gérée avec Docker Compose, documentée et versionnée selon un workflow GitHub Flow.

## Contexte

Le dépôt sert de base pour pratiquer un workflow de contribution complet : protection de branche, issues, revue de code et documentation, sur un projet d'infrastructure à base de conteneurs Docker.

## Architecture

La stack définie dans [`docker-compose.yml`](./docker-compose.yml) comprend trois services :

- **`reverse-proxy`** (`nginx:alpine`) : point d'entrée HTTP/HTTPS, expose les ports `80` et `443`.
- **`app`** : l'application, construite depuis `./app` (build local), exposée en interne sur le port `3000`.
- **`db`** (`postgres:16-alpine`) : base de données PostgreSQL, avec un volume persistant `db_data`.

Le choix du reverse proxy (Nginx vs Traefik) est documenté dans [`docs/adr/0001-reverse-proxy.md`](./docs/adr/0001-reverse-proxy.md).

> Note : le répertoire `./app` référencé par `docker-compose.yml` n'est pas encore présent dans ce dépôt d'entraînement — seule l'infrastructure (proxy, base de données, configuration) est modélisée ici.

## Prérequis

- Docker et Docker Compose (`docker compose version`)
- Git

## Installation

```bash
git clone https://github.com/Shardzen/eval-collab--Arthur-.git
cd eval-collab--Arthur-
```

## Lancer le projet

```bash
docker compose up -d
```

Vérifier que les services démarrent correctement :

```bash
docker compose ps
```

## Tests / vérifications

La CI (`.github/workflows/ci.yml`, si présente) valide le lint YAML et la configuration Docker Compose :

```bash
docker compose config
```

## Déploiement

Le déploiement n'est pas encore automatisé dans ce dépôt d'entraînement ; voir les pull requests ouvertes sur la branche `feature/deploy` pour les travaux en cours sur le reverse proxy et le script de déploiement.

## Contribuer

Le workflow de contribution (branches, commits, pull requests) est décrit dans [`AGENTS.md`](./AGENTS.md). En résumé :

1. Ouvrir une issue décrivant le besoin (bug ou évolution).
2. Créer une branche depuis `main` (`feature/…`, `fix/…`, `docs/…`).
3. Committer au format [Conventional Commits](https://www.conventionalcommits.org/).
4. Ouvrir une pull request vers `main` avec `Closes #<numéro>`.
5. Merger en **squash** une fois la revue terminée.
