# Proyecto n8n con Evolution API

Este proyecto integra **n8n** (herramienta de automatización de flujos de trabajo), **Evolution API** (API de WhatsApp) y **ngrok** (túneles seguros) utilizando Docker para crear un entorno completo de automatización de mensajería.

## 🚀 Características

- ✅ Automatización de flujos de trabajo con n8n
- ✅ Integración con WhatsApp a través de Evolution API
- ✅ Exposición segura de servicios con ngrok
- ✅ Containerización completa con Docker
- ✅ Persistencia de datos con volúmenes Docker
- ✅ Configuración lista para producción

## 📋 Requisitos previos

- Docker y Docker Compose instalados
- Cuenta de ngrok (para exposición pública)
- Puerto 5678 disponible (n8n)
- Puerto 8080 disponible (Evolution API)

## 🛠️ Instalación y configuración

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd <nombre-del-proyecto>
```

### 2. Configurar Evolution API

**⚠️ IMPORTANTE**: La carpeta `evolution-api/` tiene su propia configuración independiente.

```bash
cd evolution-api/
# Sigue las instrucciones del README.md dentro de esta carpeta
# Configura su docker-compose.yml según sus especificaciones
cd ..
```

### 3. Configurar variables de entorno del proyecto principal

Copia el archivo de ejemplo y configura tus variables:

```bash
cp .env.example .env
```

Edita el archivo `.env` con tus configuraciones específicas.

### 4. Levantar los servicios

```bash
# PRIMERO: Levantar Evolution API (desde su carpeta)
cd evolution-api/
docker-compose up -d
cd ..

# SEGUNDO: Levantar n8n y otros servicios
docker-compose up -d

# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico (ejemplo: n8n)
docker-compose logs -f n8n
```

## 📁 Estructura del proyecto

```
.
├── evolution-api/          # ⚠️ CARPETA INDEPENDIENTE con su propio README.md y docker-compose.yml
│   ├── README.md          # ← SEGUIR ESTAS INSTRUCCIONES PRIMERO
│   ├── docker-compose.yml # ← Configuración independiente de Evolution API
│   └── ...                # Otros archivos de Evolution API
├── docker-compose.yml      # Configuración de servicios Docker (n8n, ngrok, etc.)
├── Dockerfile             # Imagen personalizada (si aplica)
├── entrypoint.sh          # Script de inicialización
├── .env.example           # Plantilla de variables de entorno
├── .gitignore            # Archivos a ignorar en Git
└── README.md             # Este archivo
```

## 🔧 Servicios incluidos

### n8n (Puerto 5678)
- **Descripción**: Plataforma de automatización de flujos de trabajo
- **Acceso local**: http://localhost:5678
- **Volumen**: `n8n_data:/home/node/.n8n` (persistencia de datos)

### Evolution API (Puerto 8080)
- **Descripción**: API para integración con WhatsApp
- **Acceso local**: http://localhost:8080
- **Documentación**: Disponible en `/docs`
- **⚠️ Configuración especial**: La carpeta `evolution-api/` contiene su propio README.md y docker-compose.yml. **Sigue las instrucciones específicas de su README** antes de continuar.

### ngrok
- **Descripción**: Túneles seguros para exposición pública
- **Configuración**: Automática para n8n y Evolution API

## 📡 Comandos útiles

### Docker Compose

```bash
# IMPORTANTE: Evolution API tiene sus propios comandos
# Para Evolution API, ejecutar desde evolution-api/:
cd evolution-api/
docker-compose up -d        # Iniciar Evolution API
docker-compose down         # Detener Evolution API
docker-compose logs -f      # Ver logs de Evolution API
cd ..

# Para n8n y otros servicios (desde raíz del proyecto):
docker-compose up -d        # Iniciar servicios principales
docker-compose down         # Detener servicios principales
docker-compose restart n8n  # Reiniciar n8n
docker-compose ps          # Ver estado de servicios principales
docker-compose logs -f     # Ver logs de servicios principales

# Acceder al contenedor de n8n
docker-compose exec n8n bash
```

### Gestión de datos

```bash
# Backup del volumen de n8n
docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n_backup.tar.gz -C /data .

# Restaurar backup
docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine tar xzf /backup/n8n_backup.tar.gz -C /data
```

## 🔗 URLs de acceso

- **n8n Local**: http://localhost:5678
- **Evolution API Local**: http://localhost:8080
- **n8n Público**: Se obtiene de ngrok tras el inicio
- **Evolution API Público**: Se obtiene de ngrok tras el inicio

## 🛡️ Seguridad

- Utiliza variables de entorno para credenciales sensibles
- ngrok proporciona HTTPS automáticamente
- Considera usar autenticación básica en n8n para producción
- Mantén actualizadas las imágenes Docker

## 📊 Monitoreo

### Ver logs específicos
```bash
# Logs de n8n
docker-compose logs -f n8n

# Logs de Evolution API
docker-compose logs -f evolution-api

# Logs de ngrok
docker-compose logs -f ngrok
```

### Estado de los servicios
```bash
# Ver servicios activos
docker-compose ps

# Verificar uso de recursos
docker stats
```

## 🔄 Backup y restauración

### Backup recomendado

Se recomienda realizar backups regulares del volumen `n8n_data` ya que contiene todos los flujos desarrollados y configuraciones.

```bash
# Crear backup
./scripts/backup.sh

# Restaurar backup
./scripts/restore.sh backup_file.tar.gz
```

## 🐛 Troubleshooting

### Problemas comunes

1. **Puerto ocupado**: Verifica que los puertos 5678 y 8080 estén disponibles
2. **Permisos de volúmenes**: Asegúrate de que Docker tenga permisos de escritura
3. **Variables de entorno**: Verifica que el archivo `.env` esté correctamente configurado

### Logs de debugging
```bash
# Ver todos los logs
docker-compose logs

# Logs con timestamp
docker-compose logs -t

# Últimas 100 líneas
docker-compose logs --tail=100
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🆘 Soporte

Si encuentras algún problema o tienes preguntas:

1. Revisa los [issues existentes](../../issues)
2. Crea un nuevo issue si es necesario
3. Proporciona logs relevantes y descripción detallada del problema

---

**Nota**: Este proyecto es para desarrollo y testing. Para producción, considera implementar medidas adicionales de seguridad y monitoreo.