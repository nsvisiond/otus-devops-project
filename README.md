# OTUS DevOps-2023-09 #

## Проектная работа:
## Создание процесса непрерывной поставки для приложения с применением Практик CI/CD и быстрой обратной связью ##

### Требования ###
* Автоматизированные процессы создания и управления платформой
  * Ресурсы Ya.cloud
  * Инфраструктура для CI/CD
  * Инфраструктура для сбора обратной связи
* Использование практики IaC (Infrastructure as Code) для управления
конфигурацией и инфраструктурой
* Настроен процесс CI/CD
* Все, что имеет отношение к проекту хранится в Git
* Настроен процесс сбора обратной связи
  * Мониторинг (сбор метрик, алертинг, визуализация)
* Документация
  * README по работе с репозиторием
    * Описание приложения и его архитектуры 
    * How to start?
    * ScreenCast


### Исходные данные:
* Готовое приложение, которое включает: 
  * метрики 
  * логи приложения 
  * unit-тесты
* База данных MongoDB
* Менеджер очередей сообщений (RabbitMQ)

Вся инфраструктура развернута в Yandex Cloud.

### Используемые инструменты
1. Создание инфраструктуры — [Terraform](https://www.terraform.io/).
2. Конфигурирование инфраструктуры — [Ansible](https://www.ansible.com/).
3. Процесс CI/CD — [Gitlab](https://about.gitlab.com/).
4. Процесс сбора обратной связи:
    - сбор метрик — [Prometheus](https://prometheus.io/);
    - визуализация — [Grafana](https://grafana.com/);
    - алертинг — [Alertmanager](https://prometheus.io/docs/alerting/alertmanager/) + [Telegram](https://telegram.org/).

### Общая архитектура проекта
1. Инфраструктура Yandex Cloud:
    - Load Balancer;
    - Bastion Server;
    - NAT-VM;
    - Docker Swarm cluster: 3 worker nodes и 1 master node
    - GitLab CE
    - GitLab Docker Runner VM
2. Системы и сервисы:
    - Crawler, Crawler UI, MongoDB, RabbitMQ;
    - Gitlab CI/CD;
    - Prometheus, Grafana, Alertmanager.
3. Настроенный процесс CI/CD:
    - Dockerfiles для создания docker-образов Crawler и UI в DockerHub;
    - Gitlab сервер с Crawler и UI + GitLab Runner;
    - в процессе CI/CD производится:
        - сборка docker-образа приложения в DockerHub;
        - тестирование работы приложения;
        - если предыдущие шаги прошли успешно - возможен ручной запуск деплоя кластера docker swarm с приложением на production окружение из ветки **master**.
4. Настроенный процесс сбора обратной связи:
    - сбор метрик при помощи Prometheus;
    - визуализация при помощи Grafana;
    - алертинг и отправка оповещений в группу Telegram.

## Запуск проекта (How to start?)

### Используемые локальные инструменты

Рабочая станция (проверялось на MacOS Sonoma и Ubuntu 22.04) c установленными:

* Yandex Cloud CLI (проверялось на 0.112.0)
* Terraform (проверялось на v1.5.7)
* Ansible (проверялось на core 2.15.6)
* git (проверялось на 2.33.0)
    
### Предварительная подготовка для запуска инфраструктуры проекта

**Необходимо иметь действующий аккаунт в Yandex Cloud**
https://cloud.yandex.ru/docs/cli/quickstart

### Подготовка рабочей машины

```commandline
git clone https://github.com/nsvisiond/otus-devops-project.git
cd otus-devops-project
```

### Подготовка облака

Используется Yandex Cloud https://console.cloud.yandex.ru/

1. Для доступа к созываемым ресурсам сгенерировать пару ключей

```commandline
ssh-keygen -t rsa -C ubuntu
```

2. Создать профиль для работы через Yandex CLI: 
https://cloud.yandex.ru/docs/cli/operations/profile/profile-create

3. Создать сервисный аккаунт в Yandex.Cloud

```commandline
yc config list
yc vpc network list
yc vpc subnet list
```

сохранить полученные данные (token, cloud-id, folder-id, network_id, subnet_id) для подготовки конфигов

```commandline
SVC_ACCT="<название аккаунта>"
FOLDER_ID="<folder-id>" 
yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
ACCT_ID=$(yc iam service-account get $SVC_ACCT | \
grep ^id | \
awk '{print $2}') 
 ```

4. Дать права аккаунту:

```commandline
yc resource-manager folder add-access-binding --id $FOLDER_ID \
    --role editor \ 
    --service-account-id $ACCT_ 
```
Создать IAM key и экспортировать его в файл

```commandline
yc iam key create --service-account-id $ACCT_ID --output «путь к файлу»/key.json
```

### Подготовка конфигов

1. Копируем и проставляем актуальные значения в infra/terraform/terraform.tfvars

```commandline
cp infra/terraform/terraform.tfvars.example infra/terraform/terraform.tfvars
```

2. Копируем и проставляем актуальные значения в infra/ansible/roles/swarm/files/.env

```commandline
cp infra/ansible/roles/swarm/files/.env.example infra/ansible/roles/swarm/files/.env
```

3) На рабочей машине создать файл ~/.ssh/config. <bastion_domain> - такой же как в terraform.tfvars
   ```
   Host    bastion
           hostname <bastion_domain>
   Host    master-*
           ProxyJump bastion
   Host    node-*
           ProxyJump bastion
   Host    *-runner
           ProxyJump bastion
   Host    gitlab
           ProxyJump bastion
   Host *
           user ubuntu
           ForwardAgent yes
           ControlMaster auto
           ControlPersist 5
           StrictHostKeyChecking no
           UserKnownHostsFile=/dev/null
   ```
   
### Сборка инфраструктуры

```commandline
cd infra/terraform
terraform init
terraform plan
terraform apply --auto-approve
```

Приложение будет доступно по адресу из переменной app_domain в terraform.tfvars
GitLab будет доступен по адресу из переменной gitlab_domain в terraform.tfvars

**Приложение**

http://<app_domain>

**RabbitMQ**

http://<app_domain>:15672

login: guest

password: guest

**Grafana**

http://<app_domain>:3000

login: admin

password: admin

**Prometheus**

http://<app_domain>:9090

login: admin

password: admin

**cAdvisor**

http://<app_domain>:8080

login: admin

password: admin

### CI/CD

Для запуска процесса CI/CD необходимо:

1. Залогиниться в GitLab: http://<gitlab_domain>
2. Cоздать группу и два проекта (crawler и ui)
3. Добавить две переменные в группу (Settings - CI/CD - Variables): DOCKER_REGISTRY_USER (пользователь dockerhub репозитория) и DOCKER_REGISTRY_PASSWORD (пароль dockerhub репозитория)
4. Создать раннер в разделе Settings - CI/CD - Runners. Запомнить URL и токен.
5. Установить значения этих переменных в infra/ansible/install_docker_gitlab_runner.yml и infra/ansible/install_shell_gitlab_runner.yml
6. Запустить регистрацию раннеров.
```commandline
cd infra/ansible
ansible-playbook install_docker_gitlab_runner.yml
ansible-playbook install_shell_gitlab_runner.yml
```
7. В каждом проекте (src/crawler и src/ui) выполнить

```commandline
git init
git add -A
git commit -m "Initial Commit"
git remote add origin <clone_url>
git push origin master
```

Проверить, что запустились процессы сборки.


