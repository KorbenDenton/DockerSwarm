## Part 1. Запуск нескольких docker-контейнеров с использованием docker compose

1) Пишем `Dockerfile` для каждого отдельного сервиса

- `Database` \
Для базы данных пишем простой докерфайл на основе стабильной версии постгреса, который инициализирует при сборке заданные базы данных
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.49.45.png>)

- `Others services` \
Для session-service и всех последующих сервисов пишем подобный multi-stage докерфайл, который выполняет две задачи:
- На 1 этапе копирует файлы зависимости и выполняет установку этих зависимостей \
  На 2 этапе выполняет сборку проекта и его запуск 
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.48.44.png>)

Итоговые размеры образов, выведенные командой `docker images` получился небольшим благодаря multi-stage сборке
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.53.11.png>)

2) Далее пишем `docker-compose.yml` файл, для корректной сборки и взаимодействия всех образов
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.56.31.png>)
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.56.25.png>)

3) После сборки `docker-compose` убеждаемся, сервисы доступны 
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.57.20.png>)
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.58.31.png>)
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.58.50.png>)

- Далее собранные и запущенные образы, выведенные при помощи `docker ps`
![Alt text](<screenshots/docker ps .png>)

4) Теперь нам нужно прогнать заготовленные тесты через `postman` и удостовериться, что все они проходят успешно 
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 13.55.43.png>)

## Part 2. Создание виртуальных машин

- Скачиваем, устанавливаем `vagrant`, затем инициализируем его в `src` при помощи `vagrant init`
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 14.06.59.png>)

- Пишем `Vagrantfile` для одной ВМ и прописываем перенос исходного кода веб-сервиса
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 14.09.09.png>)

- Поднимаем ВМ при помощи `vagrant up`
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 14.11.39.png>)

- Подключаемся к созданной машине при `vagrant ssh` и смотрим, что исходный код проекта встал, как надо
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 14.12.19.png>)
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 14.19.01.png>)

- Останавливаем и уничтожаем ВМ
![Alt text](<screenshots/Снимок экрана 2025-07-05 в 14.20.16.png>)

## Part 3. Создание простейшего docker swarm

1) 
- Модифицируем Vagrantfile для создания трех машин
![Alt text](screenshots/image-6.png)

- Пишем скрипт для: \
  установки `docker` внутрь ВМ, \
  инициализации `swarm` для `manager01`, \
  подключения к `swarm` для `worker01/02`
![Alt text](screenshots/image-7.png)

2) 
- Грузим наши образы на докерхаб при помощи `docker push s21laneryel/<name-service>`
![Alt text](screenshots/image-5.png) 

- Модифицируем `docker-compose.yml` для подгрузки образов с `docker hub`, для этого нам нужно:\
1.Поменять у всех сервисов строки `build` на `image` и указать имена, как в докерхабе\
2.Везде убрать строку `ports`, дабы сделать сервисы недоступными снаружи напрямую\
3.Добавить образ `nginx`, чтобы использовать его в качестве прокси-сервера для доступа к сервисам снаружи\
![Alt text](screenshots/image-3.png)
![Alt text](screenshots/image-4.png)

3) 
- Поднимаем ВМ при помощи `vagrant up` и смотрим статус машин
![Alt text](screenshots/image-8.png)
![Alt text](screenshots/image-9.png)

- Подключаемся к `manager01` при помощи `vagrant ssh manager01` и смотрим инициализировался ли `docker swarm` и перенесся ли `docker-compose.yml`
![Alt text](screenshots/image-11.png)

- Далее тут же в `manager01` запускаем стек сервисов при помощи `docker stack deploy` и смотрим сервисы
![Alt text](screenshots/image-12.png)
![Alt text](screenshots/image-13.png)

4) 
- Пишем кастомный `nginx.conf` для проксирования запросов черех `nginx`, при этом сами сервисы gateway service и session service недоступны напрямую. 
![Alt text](screenshots/image-15.png)

- Блок с образом `nginx` уже добавлен в модифицированный `docker-compose.yml`
![Alt text](screenshots/image-16.png)

5) 
- Прогоним тесты через `postman`
![Alt text](screenshots/image-17.png)

6) 
- Посмотрим распределение контейнеров по узлам
![Alt text](screenshots/image-18.png)

7) 
- Устанавливаем отдельным стеком `portainer` внутри кластера
![Alt text](screenshots/image-19.png)

- Собственно, `portainer`
![Alt text](screenshots/image-20.png)
![Alt text](screenshots/image-21.png)
![Alt text](screenshots/image-22.png)
![Alt text](screenshots/image-23.png)