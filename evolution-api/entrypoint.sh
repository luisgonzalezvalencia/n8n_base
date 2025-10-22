#!/bin/bash

# Agregar authtoken si está definido
if [[ -n "$NGROK_AUTHTOKEN" ]]; then
  echo "🔐 Autenticando ngrok..."
  ngrok config add-authtoken "$NGROK_AUTHTOKEN"
fi

# Iniciar ngrok con dominio personalizado en segundo plano
echo "🚀 Iniciando ngrok con dominio personalizado: $CUSTOM_DOMAIN"
ngrok http 8081 --domain="$CUSTOM_DOMAIN" > /tmp/ngrok.log &
sleep 3

# Verificar que el túnel esté activo
NGROK_URL=""
for i in {1..10}; do
  # Verificar si el dominio personalizado está activo
  NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o "https://$CUSTOM_DOMAIN" | head -n 1)
  if [[ -n "$NGROK_URL" ]]; then
    break
  fi
  echo "⌛ Esperando ngrok... intento $i"
  sleep 1
done

if [[ -z "$NGROK_URL" ]]; then
  echo "❌ No se pudo conectar con el dominio personalizado: $CUSTOM_DOMAIN"
  echo "📋 Log de ngrok:"
  cat /tmp/ngrok.log
  exit 1
fi

echo "✅ URL pública: $NGROK_URL"

export SERVER_URL="$NGROK_URL"


# --- Reintroduciendo Ejecutar migraciones de Prisma con el nombre de esquema correcto ---
echo "⏳ Esperando a que PostgreSQL esté completamente listo para la base de datos..."
# Espera activa para el servicio 'postgres'
until pg_isready -h postgres -p 5432 -U evolution -d evolution; do
  echo "PostgreSQL no está listo. Esperando..."
  sleep 2
done
echo "✅ PostgreSQL está listo. Sincronizando esquema de Prisma con la base de datos..."

# Cambiar al directorio de trabajo de la aplicación Evolution API
echo "📂 Cambiando al directorio de la aplicación: /evolution"
cd /evolution || { echo "❌ Error: No se pudo cambiar al directorio /evolution. Asegúrate de que la imagen base tenga el código en este path."; exit 1; }

# Ejecutar 'prisma db push' para sincronizar el esquema directamente con la base de datos
# Esto creará las tablas si no existen, basado en postgresql-schema.prisma
npx prisma db push --schema=./prisma/postgresql-schema.prisma || { echo "❌ Error al ejecutar 'prisma db push'. Verifica la configuración de la base de datos y los logs de Prisma."; exit 1; }
echo "✅ Esquema de Prisma sincronizado con la base de datos."

# Iniciar la aplicación Evolution API en primer plano
echo "🚀 Iniciando Evolution API con archivos compilados..."
exec node dist/main.js
