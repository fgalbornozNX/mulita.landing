#!/bin/bash

# Script de deploy para mulita.landing
# Este script se ejecuta automáticamente desde GitHub Actions

set -e  # Detener si hay algún error

echo "🚀 Iniciando deploy de mulita.landing..."

# Navegar al directorio del proyecto
cd ~/landing

# Guardar cambios locales si los hay (por seguridad)
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  Hay cambios locales, guardando stash..."
    git stash
fi

# Actualizar código desde GitHub
echo "📥 Descargando últimos cambios..."
git pull origin main

# Cargar NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Usar la versión correcta de Node
echo "🔧 Usando Node.js v20.14.0..."
nvm use 20.14.0

# Instalar dependencias
echo "📦 Instalando dependencias..."
npm install --production=false

# Construir el proyecto
echo "🏗️  Construyendo proyecto..."
npm run build

# Reiniciar o iniciar PM2
echo "🔄 Reiniciando aplicación con PM2..."
if pm2 describe mulita-landing > /dev/null 2>&1; then
    pm2 restart mulita-landing
    echo "✅ Aplicación reiniciada"
else
    pm2 start npm --name "mulita-landing" -- start -- --port 2388
    echo "✅ Aplicación iniciada"
fi

# Guardar configuración de PM2
pm2 save

echo "✨ Deploy completado exitosamente!"
echo "🌐 La aplicación está corriendo en mulita.app (puerto 2388)"
