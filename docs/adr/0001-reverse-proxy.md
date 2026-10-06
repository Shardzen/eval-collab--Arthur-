# ADR 0001 — Choix du reverse proxy : Nginx

## Statut

Accepté

## Contexte

L'équipe infra héberge une quinzaine de services en conteneurs Docker, répartis sur deux serveurs. De nouveaux services sont ajoutés environ chaque mois, ce qui demande d'éditer régulièrement la configuration du reverse proxy. Le renouvellement des certificats TLS est aujourd'hui fait à la main, et un oubli a déjà provoqué une coupure de service.

Il faut choisir le reverse proxy qui servira de point d'entrée HTTP/HTTPS pour l'ensemble des services : **Nginx** ou **Traefik**.

Contraintes principales :

- L'équipe infra connaît bien Nginx (plusieurs années de pratique) et ne connaît pas Traefik.
- Le rythme d'ajout de services (environ un par mois) rend souhaitable une configuration qui demande le moins d'intervention manuelle possible.
- Le renouvellement de certificat TLS manuel est un point de défaillance avéré (incident déjà survenu) : la solution retenue doit réduire ce risque.

## Décision

On retient **Nginx**, avec **Certbot** (ou un conteneur dédié type `nginx-proxy` + `acme-companion`) pour automatiser l'émission et le renouvellement des certificats TLS via Let's Encrypt.

## Alternatives considérées

- **Traefik**
  - Avantages : découverte automatique des services via les labels Docker (pas de fichier de config à éditer à chaque nouveau service), gestion native et automatique des certificats TLS via Let's Encrypt, tableau de bord intégré.
  - Inconvénients : l'équipe ne connaît pas l'outil, ce qui implique une courbe d'apprentissage et un risque accru d'erreur de configuration sur une brique critique (point d'entrée de tous les services) ; moins de retour d'expérience en interne pour diagnostiquer un incident en production.

- **Nginx + automatisation du TLS (retenu)**
  - Avantages : l'équipe maîtrise déjà l'outil (configuration, débogage, performances connues), large documentation et communauté, permet de corriger le vrai problème (renouvellement manuel du certificat) sans changer d'outil ni réapprendre un nouveau système.
  - Inconvénients : contrairement à Traefik, Nginx ne découvre pas automatiquement les nouveaux conteneurs ; chaque nouveau service demande toujours un minimum de configuration explicite (bloc `server`), sauf à ajouter un outil complémentaire type `nginx-proxy` qui lit les labels Docker.

## Conséquences

- L'équipe garde un outil qu'elle maîtrise déjà, ce qui limite le risque d'erreur sur un composant critique et ne demande pas de formation.
- Le renouvellement manuel des certificats, identifié comme cause de l'incident précédent, est éliminé par l'automatisation (Certbot / ACME), indépendamment du choix Nginx vs Traefik.
- L'ajout d'un nouveau service nécessite toujours une action explicite (ajouter un bloc `server`), à documenter dans le processus d'onboarding d'un nouveau service ; si ce point devient un frein notable, le passage à `nginx-proxy` (labels Docker) ou une réévaluation de Traefik pourra être reconsidéré dans un futur ADR.
