# Makefile — автоматизация DevOps-инфраструктуры

COMPOSE=docker-compose
PORTAINER_DIR=./portainer
MONITORING_DIR=./monitoring
NGINX_DIR=./nginx-proxy
BACKUP_DIR=./backups
MAINTENANCE_SCRIPT=./server_maintenance.sh
DATE=$(shell date +%F-%H%M)

.PHONY: up down restart logs backup maintenance \
        portainer-up prometheus-up grafana-up nginx-up \
        prometheus-reload

## 🔼 Запуск всех сервисов
up:
        $(COMPOSE) -f $(PORTAINER_DIR)/docker-compose.yml up -d
        $(COMPOSE) -f $(MONITORING_DIR)/docker-compose.yml up -d
        $(COMPOSE) -f $(NGINX_DIR)/docker-compose.yml up -d

## 🔽 Остановка всех сервисов
down:
        $(COMPOSE) -f $(PORTAINER_DIR)/docker-compose.yml down
        $(COMPOSE) -f $(MONITORING_DIR)/docker-compose.yml down
        $(COMPOSE) -f $(NGINX_DIR)/docker-compose.yml down

## 🔁 Перезапуск всех сервисов
restart: down up

## 📜 Логи всех сервисов
logs:
        $(COMPOSE) -f $(PORTAINER_DIR)/docker-compose.yml logs -f
        $(COMPOSE) -f $(MONITORING_DIR)/docker-compose.yml logs -f
        $(COMPOSE) -f $(NGINX_DIR)/docker-compose.yml logs -f

## 📦 Резервное копирование
backup:
    mkdir -p $(BACKUP_DIR)
    docker run --rm -v portainer_data:/data -v $(BACKUP_DIR):/backup alpine \
        sh -c "cp /data/portainer.db /backup/portainer.db.$(DATE)"
    cp $(MONITORING_DIR)/prometheus.yml $(BACKUP_DIR)/prometheus.yml.$(DATE)

## 🧼 Системное обслуживание
maintenance:
    bash $(MAINTENANCE_SCRIPT)

## 🔁 Перезагрузка Prometheus (без остановки контейнера)
prometheus-reload:
    docker exec prometheus kill -HUP 1

## 🔼 Запуск отдельных сервисов
portainer-up:
        $(COMPOSE) -f $(PORTAINER_DIR)/docker-compose.yml up -d

prometheus-up:
        $(COMPOSE) -f $(MONITORING_DIR)/docker-compose.yml up -d prometheus

grafana-up:
        $(COMPOSE) -f $(MONITORING_DIR)/docker-compose.yml up -d grafana

nginx-up:
        $(COMPOSE) -f $(NGINX_DIR)/docker-compose.yml up -d
