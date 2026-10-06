# AGENTS.md

Instructions pour tout agent (humain ou IA) travaillant sur ce dépôt.

## Contexte du projet

Ce dépôt modélise une petite stack infra conteneurisée (reverse proxy Nginx, application, base de données PostgreSQL) gérée avec Docker Compose. Voir [README.md](./README.md) pour l'architecture et [docs/adr/](./docs/adr/) pour les décisions techniques (notamment le choix du reverse proxy).

## Commandes de vérification

Avant de proposer une modification, vérifier que :

```bash
# La configuration Docker Compose est valide
docker compose config

# Le YAML respecte les règles du dépôt (si .yamllint.yml est présent)
yamllint .
```

Toute modification de `docker-compose.yml` ou de la configuration du reverse proxy doit être validée avec `docker compose config` avant commit.

## Conventions

- **Branches** : `type/numero-issue-description-courte`, avec `type` parmi `feature`, `fix`, `docs`, `infra`.
- **Commits** : format [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, `chore:`, `infra:`…).
- **Pull requests** : toujours ouvertes vers `main`, avec le modèle de description rempli et `Closes #<numéro>` quand une issue est concernée.
- **Merge** : squash merge uniquement, branche supprimée après merge.
- Toute modification touchant à l'infrastructure (`docker-compose.yml`, configuration du reverse proxy, scripts de déploiement) doit être relue en priorité par le CODEOWNER infra du dépôt.

## Interdits

- **Aucun secret en clair** dans le dépôt (mots de passe, clés API, tokens, identifiants d'accès serveur). Utiliser des variables d'environnement non versionnées (`.env`, ignoré par `.gitignore`) ou un gestionnaire de secrets.
- **Aucun commit direct sur `main`** : tout changement passe par une pull request.
- **Aucun port de base de données publié** sur l'hôte dans `docker-compose.yml` (`db` ne doit pas avoir de `ports:` exposant `5432`) : l'accès doit rester interne au réseau Docker.
- Ne pas désactiver ou contourner la CI pour faire passer une pull request.
- Ne pas déployer en se connectant en `root` sur les serveurs ; utiliser un compte de service dédié à droits limités.
