#!/usr/bin/env bash
export ADMIN_USER=admin
export ADMIN_PASSWORD=admin
export SLACK_URL=https://hooks.slack.com/services/
export SLACK_CHANNEL=otus
export SLACK_USER=incoming-webhook
chmod -R 775 /swarm/swarmprom/
docker stack deploy --compose-file=<(docker-compose -f docker-compose.yml config 2>/dev/null) PROD
docker stack deploy --compose-file=<(docker-compose -f swarmprom/docker-compose.yml config 2>/dev/null) PROD
