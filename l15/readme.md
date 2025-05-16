# Звіт про роботу з Docker Compose

## Встановлення та налаштування багатоконтейнерного застосунку

### Структура проекту
```
.
├── multi-container-app
│   ├── docker-compose.yml
│   └── web-data
│       └── index.html
└── readme.md
```

### Команди, які використовувались

#### Запуск застосунку
```bash
# Створення та запуск контейнерів у фоновому режимі
docker-compose up -d
```

#### Перевірка стану контейнерів
```bash
# Перегляд запущених контейнерів
docker-compose ps
```

#### Перевірка мереж і томів
```bash
# Перегляд створених мереж
docker network ls

# Перегляд створених томів
docker volume ls
```

#### Підключення до бази даних PostgreSQL
```bash
# Отримання ID контейнера з PostgreSQL
DB_CONTAINER=$(docker-compose ps -q db)

# Підключення до бази даних всередині контейнера
docker exec -it $DB_CONTAINER psql -U postgres -d appdb
```

#### Масштабування веб-сервера
```bash
# Масштабування веб-сервера до трьох екземплярів
docker-compose up -d --scale web=3
```


### Проблеми та рішення з якими я стикався
1. **Nginx показує стандартну сторінку, а не мій index.html**
   - змінено volume у docker-compose.yml на правильний шлях до папки з index.html (`../l15/web-data:/usr/share/nginx/html:ro`). Перезапущено контейнери.
2. **Повторення портів при запуску більше 1-го екземпляру**
   - прибрав зовнішній порт в docker-compose, тепер докер встановлюе його самостійно.
