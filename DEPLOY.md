# Deploy Automático - Guía de Configuración

Esta guía te ayudará a configurar el deploy automático de mulita.landing a tu droplet de DigitalOcean usando GitHub Actions.

## 📋 Requisitos Previos

- Repositorio en GitHub (fgalbornozNX/mulita.landing)
- Acceso SSH al droplet de DigitalOcean
- Node.js v20.14.0 con NVM instalado en el droplet
- PM2 instalado en el droplet
- Nginx configurado

## 🔐 Paso 1: Configurar GitHub Secrets

Ve a tu repositorio en GitHub y configura los siguientes secrets:

**GitHub → Settings → Secrets and variables → Actions → New repository secret**

Crea estos 4 secrets:

### 1. `DROPLET_HOST`
- **Valor**: La IP de tu droplet (ej: `123.45.67.89`)

### 2. `DROPLET_USERNAME`
- **Valor**: Tu usuario SSH (probablemente `root` o tu usuario personalizado)

### 3. `SSH_PRIVATE_KEY`
- **Valor**: Tu clave privada SSH completa
- Para obtenerla, en tu máquina local ejecuta:
  ```bash
  cat ~/.ssh/id_rsa
  ```
  o el archivo que uses para conectarte al droplet
- Copia TODO el contenido, incluyendo:
  ```
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...
  -----END OPENSSH PRIVATE KEY-----
  ```

### 4. `SSH_PASSPHRASE`
- **Valor**: La passphrase de tu clave SSH

## 🖥️ Paso 2: Preparar el Droplet

Conéctate a tu droplet por SSH y ejecuta estos comandos:

### 2.1 Inicializar repositorio Git en el droplet

```bash
cd ~/landing

# Si no es un repositorio git aún
git init

# Configurar el remote (reemplaza con tu URL)
git remote add origin git@github.com:fgalbornozNX/mulita.landing.git

# O si usas HTTPS
git remote add origin https://github.com/fgalbornozNX/mulita.landing.git

# Hacer fetch inicial
git fetch origin main

# Resetear a la rama main
git reset --hard origin/main
```

### 2.2 Configurar SSH para GitHub en el droplet

Si usas SSH para clonar, necesitas agregar la clave SSH del droplet a GitHub:

```bash
# Generar clave SSH en el droplet (si no tienes)
ssh-keygen -t ed25519 -C "tu-email@ejemplo.com"

# Mostrar la clave pública
cat ~/.ssh/id_ed25519.pub
```

Copia esa clave y agrégala en:
**GitHub → Settings → SSH and GPG keys → New SSH key**

### 2.3 Configurar PM2 para inicio automático

```bash
# Ver procesos de PM2
pm2 list

# Si ya tienes la app corriendo, guárdala
pm2 save

# Configurar PM2 para iniciar al reiniciar el servidor
pm2 startup
# Ejecuta el comando que te muestra PM2
```

### 2.4 Verificar permisos

```bash
# Asegurarte de que puedes escribir en la carpeta
ls -la ~/landing

# Dar permisos si es necesario
chmod -R u+w ~/landing
```

## 🚀 Paso 3: Hacer el Primer Deploy

Una vez configurado todo:

1. Haz commit de los cambios en tu rama `dev`:
   ```bash
   git add .github/workflows/deploy.yml deploy.sh
   git commit -m "feat: add automatic deployment workflow"
   git push origin dev
   ```

2. Mergea a `main`:
   ```bash
   git checkout main
   git merge dev
   git push origin main
   ```

3. Ve a GitHub Actions:
   - **GitHub → Actions → Deploy to DigitalOcean**
   - Verás el workflow ejecutándose
   - Si todo está bien, verás ✅ en cada paso

## 🔍 Verificación

### En GitHub
- Ve a **Actions** y verifica que el workflow se completó exitosamente
- Revisa los logs si hay algún error

### En el Droplet
```bash
# Ver estado de PM2
pm2 status

# Ver logs de la aplicación
pm2 logs mulita-landing

# Ver logs en tiempo real
pm2 logs mulita-landing --lines 100
```

### En el navegador
- Visita https://mulita.app
- Verifica que los cambios se reflejen

## ⚠️ Troubleshooting

### Error: "Permission denied (publickey)"
- Verifica que agregaste la clave SSH del droplet a GitHub
- Verifica que los secrets están correctos

### Error: "git pull failed"
- Conéctate al droplet y verifica el estado del repositorio:
  ```bash
  cd ~/landing
  git status
  git remote -v
  ```

### Error: "pm2 command not found"
- Verifica que PM2 está instalado globalmente:
  ```bash
  npm install -g pm2
  ```

### La aplicación no se reinicia
- Verifica el nombre del proceso en PM2:
  ```bash
  pm2 list
  ```
- Si tiene otro nombre, actualiza el workflow

## 📝 Notas Importantes

1. **Solo se deploya cuando hay push a `main`**: Los cambios en `dev` u otras ramas no activarán el deploy
2. **El proceso toma ~2-5 minutos**: Dependiendo del tamaño de las dependencias
3. **Downtime mínimo**: PM2 reinicia la app en segundos
4. **Logs disponibles**: Puedes ver todo en GitHub Actions y en PM2

## 🔄 Flujo de Trabajo Recomendado

```bash
# 1. Desarrollar en dev
git checkout dev
# ... hacer cambios ...
git add .
git commit -m "feat: nueva funcionalidad"
git push origin dev

# 2. Cuando esté listo para producción
git checkout main
git merge dev
git push origin main  # 🚀 Esto activará el deploy automático

# 3. GitHub Actions hará el resto automáticamente
```

## 🎉 ¡Listo!

Ahora cada vez que hagas push a `main`, tu aplicación se deployará automáticamente a mulita.app.
