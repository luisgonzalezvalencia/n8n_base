# Evolution API Completa - PostgreSQL + Redis + Docker

## 🏗️ **Arquitectura completa:**

- **Evolution API** - Servidor principal (puerto 8080)
- **PostgreSQL** - Base de datos persistente (puerto 5432)
- **Redis** - Cache y gestión de sesiones (puerto 6379)
- **Volúmenes Docker** - Persistencia garantizada
- **Health checks** - Verificación automática de servicios

## 🚀 **Instalación paso a paso:**

### 1. Levantar todos los servicios
```bash
# Levantar en modo detached (segundo plano)
docker-compose up -d

# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f evolution-api
```

### 2. Verificar que todo funciona
```bash
# Ver estado de servicios
docker-compose ps

# Debería mostrar 3 servicios "Up"
```


## 🛠️ **Comandos de gestión:**

### Servicios:
```bash
# Reiniciar un servicio específico
docker-compose restart evolution-api

# Ver recursos utilizados
docker stats

# Escalar servicios (si es necesario)
docker-compose up -d --scale evolution-api=2
```

### Base de datos:
```bash
# Backup completo
docker-compose exec postgres pg_dump -U evolution evolution > backup_$(date +%Y%m%d).sql

# Restaurar backup
docker-compose exec -T postgres psql -U evolution evolution < backup_20240727.sql

# Ver tamaño de la base de datos
docker-compose exec postgres psql -U evolution -d evolution -c "SELECT pg_size_pretty(pg_database_size('evolution'));"
```

## 📈 **Monitoreo y logs:**

### Ver logs en tiempo real:
```bash
# Todos los servicios
docker-compose logs -f --tail=100

# Solo Evolution API
docker-compose logs -f evolution-api --tail=50

# Solo errores
docker-compose logs -f | grep -i error
```

### Métricas de rendimiento:
```bash
# Uso de recursos
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Espacio en disco de volúmenes
docker system df -v
```

## 🔐 **Seguridad avanzada:**

### Contraseñas generadas:
- **Evolution API**: `EVO_XXXX`
- **PostgreSQL**: `PgSql_Secure_XXXX`
- **Redis**: `Redis_Cache_XXXX`

### Red aislada:
- Todos los servicios en red privada `evolution_network`
- Solo Evolution API expuesto al exterior (puerto 8080)
- PostgreSQL y Redis solo accesibles internamente

## 🚨 **Solución de problemas:**

### Si Evolution API no conecta a PostgreSQL:
```bash
# Ver logs de PostgreSQL
docker-compose logs postgres

# Verificar que la BD esté lista
docker-compose exec postgres pg_isready -U evolution
```

### Si Redis falla:
```bash
# Verificar conexión
docker-compose exec redis redis-cli -a Redis_Cache_2024_zX8vB5nH1yU4 ping

# Ver logs de Redis
docker-compose logs redis
```

### Reinicio completo:
```bash
# Parar todo
docker-compose down

# Limpiar y reiniciar
docker-compose up -d --force-recreate
```

## 📋 **Estructura final del proyecto:**

La configuración empresarial completa:

```
evolution-api-complete/
├── docker-compose.yml    (3 servicios + volúmenes + red)
├── .env                 (contraseñas seguras)
├── .gitignore          (protección automática)
└── Datos en volúmenes Docker:
    ├── postgres_data/
    ├── redis_data/
    ├── evolution_instances/
    └── evolution_store/
```