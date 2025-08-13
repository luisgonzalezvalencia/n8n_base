# Construir la imagen personalizada
```bash
# Levantar en modo detached (segundo plano)
docker-compose up -d

# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f n8n
```

En la configuracion de docker compose se maneja un volumen 
volumes:
      - n8n_data:/home/node/.n8n

Se recomienda realizar backups sobre este volumen ya que todos los flujos desarrollados se almacenan en disco.