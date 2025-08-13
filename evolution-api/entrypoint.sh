#!/bin/bash

echo "🏁 Entrypoint iniciado"

# Autenticar ngrok si hay token
if [[ -n "$NGROK_AUTHTOKEN" ]]; then
  echo "🔐 Autenticando ngrok..."
  ngrok config add-authtoken "$NGROK_AUTHTOKEN"
else
  echo "⚠️ NGROK_AUTHTOKEN no configurado. ngrok podría no funcionar correctamente."
fi

# Iniciar ngrok en segundo plano y redirigir su salida a un archivo de log
echo "🚀 Iniciando ngrok..."
ngrok http 8080 --log=stdout > /tmp/ngrok.log 2>&1 &

# Esperar un poco para que ngrok se inicie y el túnel comience a establecerse
sleep 5

# Obtener la URL pública
NGROK_URL=""
for i in {1..15}; do
  NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[a-zA-Z0-9.-]*\.ngrok-free\.app' | head -n 1)
  
  if [[ -n "$NGROK_URL" ]]; then
    break
  fi
  echo "⌛ Esperando ngrok... intento $i"
  sleep 2
done

if [[ -n "$NGROK_URL" ]]; then
  export SERVER_URL="$NGROK_URL"
  echo "✅ URL pública obtenida: $NGROK_URL"
  echo "🌐 Evolution API estará disponible en: $NGROK_URL"
else
  echo "❌ No se pudo obtener la URL de ngrok después de varios intentos."
  echo "⚠️ La Evolution API se iniciará con la URL predeterminada: http://localhost:8080"
  export SERVER_URL="http://localhost:8080"
fi

# Mostrar el contenido del log de ngrok para depuración
echo "--- Log de ngrok ---"
cat /tmp/ngrok.log
echo "--------------------"

# Diagnóstico: Listar contenido del directorio /evolution
echo "--- Contenido de /evolution ---"
ls -l /evolution
echo "-------------------------------"

# Diagnóstico: Listar contenido del directorio /evolution/src (si existe)
echo "--- Contenido de /evolution/src ---"
ls -l /evolution/src 2>/dev/null || echo "Directorio /evolution/src no encontrado o vacío."
echo "-----------------------------------"

# Diagnóstico: Listar contenido del directorio /evolution/dist (si existe)
echo "--- Contenido de /evolution/dist ---"
ls -l /evolution/dist 2>/dev/null || echo "Directorio /evolution/dist no encontrado o vacío."
echo "------------------------------------"

# Diagnóstico: Listar contenido del directorio /evolution/prisma (si existe)
echo "--- Contenido de /evolution/prisma ---"
ls -l /evolution/prisma 2>/dev/null || echo "Directorio /evolution/prisma no encontrado o vacío."
echo "--------------------------------------"


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
