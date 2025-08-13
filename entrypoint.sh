#!/bin/bash

# Agregar authtoken si está definido
if [[ -n "$NGROK_AUTHTOKEN" ]]; then
  echo "🔐 Autenticando ngrok..."
  ngrok config add-authtoken "$NGROK_AUTHTOKEN"
fi

# Iniciar ngrok con dominio personalizado en segundo plano
echo "🚀 Iniciando ngrok con dominio personalizado: $CUSTOM_DOMAIN"
ngrok http 5678 --domain="$CUSTOM_DOMAIN" > /tmp/ngrok.log &
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

export WEBHOOK_URL="$NGROK_URL"

# Iniciar n8n
n8n