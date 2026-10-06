#!/bin/bash
ssh root@203.0.113.10 "cd /srv/app && git pull && docker compose up -d --build"
