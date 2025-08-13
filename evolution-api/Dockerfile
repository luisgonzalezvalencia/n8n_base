FROM atendai/evolution-api:latest

# Establecer el directorio de trabajo para todas las instrucciones siguientes
WORKDIR /evolution

USER root

# Instalar herramientas necesarias, incluyendo postgresql-client para pg_isready
RUN apk add --no-cache \
    wget \
    unzip \
    curl \
    bash \
    postgresql-client

RUN wget -q -O /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip \
    && unzip /tmp/ngrok.zip -d /usr/local/bin \
    && rm /tmp/ngrok.zip \
    && chmod +x /usr/local/bin/ngrok

# Copiar el entrypoint.sh ANTES de cambiar el usuario para poder manipular permisos
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Asegurarse de que el usuario 'node' tenga permisos para el directorio 'prisma'
# Esto es crucial para que Prisma pueda encontrar su schema.prisma si la aplicación lo necesita
RUN chown -R node:node /evolution/prisma || true
RUN chmod -R 755 /evolution/prisma || true

USER node

EXPOSE 8080 4040

ENTRYPOINT ["/entrypoint.sh"]
