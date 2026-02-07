# 🚀 GUÍA COMPLETA: DESPLEGAR NOBLESTEP EN ORACLE CLOUD (GRATIS)

## 📋 LO QUE VAS A CONSEGUIR

Al terminar esta guía tendrás:
- ✅ Servidor en la nube **GRATIS PARA SIEMPRE**
- ✅ 4 vCPUs ARM + 24GB RAM + 200GB Storage
- ✅ Backend .NET 8 corriendo 24/7
- ✅ Frontend Admin + Ecommerce
- ✅ MySQL 8.0 Database
- ✅ SSL/HTTPS configurado
- ✅ Dominio propio (opcional)
- ✅ **Costo: $0 USD/mes permanente**

---

## ⚠️ REQUISITOS PREVIOS

### **Antes de empezar necesitas:**
1. **Tarjeta de crédito/débito** (NO se cobra, solo verificación)
2. **Correo electrónico** válido
3. **Teléfono móvil** para verificación
4. **Paciencia:** La configuración inicial toma ~30-45 minutos
5. **Conocimientos básicos de Linux** (te guío paso a paso)

### **Lo que Oracle pide:**
- Nombre completo
- Dirección física real
- Tarjeta de crédito (hace cargo de $1 USD y devuelve inmediatamente)
- Verificación por SMS

---

## 📝 PARTE 1: CREAR CUENTA ORACLE CLOUD

### **Paso 1: Registrarse**

1. Ve a: https://www.oracle.com/cloud/free/
2. Click en **"Start for free"**
3. Selecciona tu país (Perú)
4. Ingresa tu email

### **Paso 2: Información de la cuenta**

```
Country/Territory: Peru
Cloud Account Name: noblestep (o el que prefieras - será tu URL)
Home Region: Chile (Santiago) - ¡IMPORTANTE! No se puede cambiar después
```

**Regiones recomendadas para Perú:**
- 🥇 **Chile (Santiago)** - Más cercano, mejor latencia
- 🥈 **Brazil (Sao Paulo)** - Alternativa en LATAM
- 🥉 **US West (Phoenix)** - Si Chile no está disponible

### **Paso 3: Información personal**

```
First Name: Tu nombre
Last Name: Tu apellido
Address: Tu dirección real (importante para verificación)
City: Lima
State/Province: Lima
Postal Code: Tu código postal
Phone: +51 999 999 999
```

### **Paso 4: Verificación de tarjeta**

1. Ingresa datos de tarjeta (Visa/Mastercard)
2. Oracle hará un cargo de $1 USD
3. El cargo se revierte en 24-48 horas
4. **NO se hará ningún cobro posterior** en el tier gratuito

### **Paso 5: Confirmación**

1. Recibirás email de confirmación
2. Verifica tu email (click en el link)
3. Configura tu contraseña
4. ¡Listo! Ya tienes cuenta Oracle Cloud

---

## 🖥️ PARTE 2: CREAR TU SERVIDOR (COMPUTE INSTANCE)

### **Paso 1: Acceder a Oracle Cloud Console**

1. Ve a: https://cloud.oracle.com
2. Ingresa con tu email y contraseña
3. Llegarás al **Dashboard**

### **Paso 2: Crear VM (Virtual Machine)**

1. En el menú ☰ (hamburger) → **Compute** → **Instances**
2. Click **"Create Instance"**

### **Paso 3: Configurar la Instancia**

#### **Name (Nombre):**
```
noblestep-server
```

#### **Placement:**
- Availability Domain: AD-1 (dejar por defecto)

#### **Image and Shape (LO MÁS IMPORTANTE):**

**Image (Sistema Operativo):**
1. Click **"Change Image"**
2. Selecciona: **Ubuntu** → **22.04** (Canonical Ubuntu 22.04)
3. Click **"Select Image"**

**Shape (Recursos del servidor):**
1. Click **"Change Shape"**
2. Selecciona: **Ampere** (ARM processor)
3. Shape: **VM.Standard.A1.Flex**
4. Configura recursos:
   ```
   OCPU count: 4 (máximo gratis)
   Memory (GB): 24 (máximo gratis)
   ```
5. Click **"Select Shape"**

**⚠️ IMPORTANTE:** Si no ves la opción Ampere o dice "Out of capacity":
- Prueba cambiar de Availability Domain (AD-2 o AD-3)
- O intenta en diferentes horarios
- Chile (Santiago) suele tener mejor disponibilidad

### **Paso 4: Configurar Networking**

#### **Primary VNIC:**
- Virtual cloud network: Selecciona **Create new virtual cloud network**
- Subnet: **Create new public subnet**
- Public IPv4 address: **Assign a public IPv4 address** ✅

### **Paso 5: SSH Keys (MUY IMPORTANTE)**

**Opción A: Generar automáticamente (Más fácil)**
1. Selecciona: **"Generate a key pair for me"**
2. Click **"Save Private Key"** - Guárdala como `noblestep-key.key`
3. Click **"Save Public Key"** - Guárdala como `noblestep-key.pub`
4. **¡GUARDA ESTAS CLAVES EN LUGAR SEGURO!** Sin ellas no podrás acceder

**Opción B: Usar tus propias claves (Avanzado)**
```bash
# En tu computadora local (Git Bash en Windows o Terminal en Mac/Linux)
ssh-keygen -t rsa -b 4096 -f noblestep-key
# Presiona Enter 2 veces (sin contraseña)
# Esto genera: noblestep-key (privada) y noblestep-key.pub (pública)
```

### **Paso 6: Boot Volume**

- Dejar valores por defecto (50GB es suficiente)
- **NO seleccionar** "Use in-transit encryption"

### **Paso 7: Crear la instancia**

1. Click **"Create"**
2. Espera 2-3 minutos
3. Estado cambiará de "PROVISIONING" a "RUNNING" 🟢

---

## 🔓 PARTE 3: CONFIGURAR FIREWALL (ABRIR PUERTOS)

### **Paso 1: Configurar Security List**

1. En la página de tu instancia, ve a **Subnet** (link en azul)
2. En "Security Lists" → Click en **Default Security List**
3. Click **"Add Ingress Rules"**

### **Paso 2: Agregar reglas para HTTP, HTTPS, Backend**

**Regla 1: HTTP (Puerto 80)**
```
Source CIDR: 0.0.0.0/0
IP Protocol: TCP
Destination Port Range: 80
Description: HTTP
```

**Regla 2: HTTPS (Puerto 443)**
```
Source CIDR: 0.0.0.0/0
IP Protocol: TCP
Destination Port Range: 443
Description: HTTPS
```

**Regla 3: Backend API (Puerto 5000)**
```
Source CIDR: 0.0.0.0/0
IP Protocol: TCP
Destination Port Range: 5000
Description: Backend API
```

**Regla 4: MySQL (Puerto 3306 - OPCIONAL, solo si necesitas acceso externo)**
```
Source CIDR: TU_IP/32
IP Protocol: TCP
Destination Port Range: 3306
Description: MySQL
```

Click **"Add Ingress Rules"** para cada una.

---

## 🔌 PARTE 4: CONECTARTE AL SERVIDOR

### **Paso 1: Obtener IP pública**

1. En la página de tu instancia, copia la **Public IP Address**
2. Ejemplo: `132.145.123.45`

### **Paso 2: Conectar por SSH**

#### **En Windows (usando Git Bash o PowerShell):**

```bash
# Dar permisos a la clave privada
icacls noblestep-key.key /inheritance:r
icacls noblestep-key.key /grant:r "%username%":"(R)"

# Conectar
ssh -i noblestep-key.key ubuntu@132.145.123.45
```

#### **En Mac/Linux:**

```bash
# Dar permisos a la clave privada
chmod 400 noblestep-key.key

# Conectar
ssh -i noblestep-key.key ubuntu@132.145.123.45
```

### **Paso 3: Primera conexión**

```bash
# Te preguntará: "Are you sure you want to continue connecting?"
# Escribe: yes

# Deberías ver:
Welcome to Ubuntu 22.04.3 LTS
ubuntu@noblestep-server:~$
```

¡**Felicidades! Ya estás dentro de tu servidor**! 🎉

---

## 🔧 PARTE 5: CONFIGURAR EL SERVIDOR (Ubuntu)

### **Paso 1: Actualizar sistema**

```bash
sudo apt update
sudo apt upgrade -y
```

### **Paso 2: Configurar Firewall interno (UFW)**

```bash
# Permitir puertos necesarios
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 5000/tcp  # Backend API

# Habilitar firewall
sudo ufw enable

# Verificar estado
sudo ufw status
```

### **Paso 3: Instalar .NET 8 SDK**

```bash
# Agregar repositorio de Microsoft
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Instalar .NET 8 SDK
sudo apt update
sudo apt install -y dotnet-sdk-8.0

# Verificar instalación
dotnet --version
# Debería mostrar: 8.0.x
```

### **Paso 4: Instalar MySQL 8.0**

```bash
# Instalar MySQL Server
sudo apt install -y mysql-server

# Iniciar MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Configurar seguridad de MySQL
sudo mysql_secure_installation
```

**Configuración de mysql_secure_installation:**
```
Validate Password Plugin? N
Remove anonymous users? Y
Disallow root login remotely? Y
Remove test database? Y
Reload privilege tables? Y
```

### **Paso 5: Crear base de datos y usuario**

```bash
# Entrar a MySQL como root
sudo mysql

# Dentro de MySQL, ejecutar:
```

```sql
-- Crear base de datos
CREATE DATABASE noblestep_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Crear usuario
CREATE USER 'noblestep_user'@'localhost' IDENTIFIED BY 'TuPasswordSeguro123!';

-- Dar permisos
GRANT ALL PRIVILEGES ON noblestep_db.* TO 'noblestep_user'@'localhost';
FLUSH PRIVILEGES;

-- Verificar
SHOW DATABASES;

-- Salir
EXIT;
```

### **Paso 6: Instalar Nginx (Servidor web)**

```bash
# Instalar Nginx
sudo apt install -y nginx

# Iniciar Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Verificar
sudo systemctl status nginx
```

### **Paso 7: Instalar Node.js (para builds de Angular)**

```bash
# Instalar Node.js 20 LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verificar
node --version  # v20.x.x
npm --version   # 10.x.x
```

---

## 📦 PARTE 6: SUBIR TU PROYECTO AL SERVIDOR

### **Paso 1: Preparar tu proyecto localmente**

#### **Backend:**

```bash
# En tu computadora local, en la carpeta del proyecto
cd backend

# Editar appsettings.json - Connection String
# Cambiar a:
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=noblestep_db;User=noblestep_user;Password=TuPasswordSeguro123!;"
}

# Publicar para producción
dotnet publish -c Release -o publish
```

#### **Frontend Admin:**

```bash
cd frontend

# Build para producción
npm run build

# Esto genera: dist/noblestep-web/browser
```

#### **Frontend Ecommerce:**

```bash
# Build para producción
npm run build:ecommerce

# Esto genera: dist/ecommerce/browser
```

### **Paso 2: Subir archivos al servidor**

**Opción A: Usar SCP (Secure Copy)**

```bash
# Desde tu computadora local

# Backend
scp -i noblestep-key.key -r backend/publish ubuntu@132.145.123.45:~/backend

# Frontend Admin
scp -i noblestep-key.key -r frontend/dist/noblestep-web/browser ubuntu@132.145.123.45:~/frontend-admin

# Frontend Ecommerce
scp -i noblestep-key.key -r frontend/dist/ecommerce/browser ubuntu@132.145.123.45:~/frontend-ecommerce

# Base de datos SQL
scp -i noblestep-key.key database/BD_FINAL.sql ubuntu@132.145.123.45:~/database.sql
```

**Opción B: Usar Git (Recomendado)**

```bash
# En el servidor
cd ~
git clone https://github.com/TU_USUARIO/TU_REPO.git noblestep

# Si es privado:
git clone https://TU_TOKEN@github.com/TU_USUARIO/TU_REPO.git noblestep

cd noblestep

# Build backend
cd backend
dotnet publish -c Release -o ~/backend

# Build frontends
cd ../frontend
npm install
npm run build
npm run build:ecommerce

# Copiar builds
cp -r dist/noblestep-web/browser ~/frontend-admin
cp -r dist/ecommerce/browser ~/frontend-ecommerce
```

### **Paso 3: Importar base de datos**

```bash
# En el servidor
mysql -u noblestep_user -p noblestep_db < ~/database.sql

# Verificar
mysql -u noblestep_user -p
```

```sql
USE noblestep_db;
SHOW TABLES;
SELECT COUNT(*) FROM Products;
EXIT;
```

---

## 🔄 PARTE 7: CONFIGURAR SERVICIOS SYSTEMD

### **Paso 1: Crear servicio para Backend**

```bash
sudo nano /etc/systemd/system/noblestep-api.service
```

```ini
[Unit]
Description=NobleStep API (.NET 8)
After=network.target

[Service]
WorkingDirectory=/home/ubuntu/backend
ExecStart=/usr/bin/dotnet /home/ubuntu/backend/NobleStep.Api.dll
Restart=always
RestartSec=10
SyslogIdentifier=noblestep-api
User=ubuntu
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://localhost:5000

[Install]
WantedBy=multi-user.target
```

**Guardar:** `Ctrl + O`, Enter, `Ctrl + X`

### **Paso 2: Habilitar y arrancar servicio**

```bash
# Recargar systemd
sudo systemctl daemon-reload

# Habilitar servicio
sudo systemctl enable noblestep-api

# Iniciar servicio
sudo systemctl start noblestep-api

# Verificar estado
sudo systemctl status noblestep-api

# Ver logs
sudo journalctl -u noblestep-api -f
```

---

## 🌐 PARTE 8: CONFIGURAR NGINX

### **Paso 1: Crear configuración de Nginx**

```bash
sudo nano /etc/nginx/sites-available/noblestep
```

```nginx
# Backend API
server {
    listen 80;
    server_name TU_IP_PUBLICA;  # Cambiar por tu IP o dominio
    
    location /api/ {
        proxy_pass http://localhost:5000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # Frontend Admin
    location /admin {
        alias /home/ubuntu/frontend-admin;
        try_files $uri $uri/ /admin/index.html;
        index index.html;
    }
    
    # Frontend Ecommerce (root)
    location / {
        root /home/ubuntu/frontend-ecommerce;
        try_files $uri $uri/ /index.html;
        index index.html;
    }
}
```

**Guardar:** `Ctrl + O`, Enter, `Ctrl + X`

### **Paso 2: Habilitar configuración**

```bash
# Crear link simbólico
sudo ln -s /etc/nginx/sites-available/noblestep /etc/nginx/sites-enabled/

# Eliminar default
sudo rm /etc/nginx/sites-enabled/default

# Verificar configuración
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
```

---

## ✅ PARTE 9: VERIFICAR QUE TODO FUNCIONE

### **Paso 1: Verificar servicios**

```bash
# Backend
sudo systemctl status noblestep-api

# Nginx
sudo systemctl status nginx

# MySQL
sudo systemctl status mysql
```

### **Paso 2: Probar acceso**

```bash
# Backend API
curl http://localhost:5000/api/products

# Nginx
curl http://localhost
```

### **Paso 3: Acceder desde tu navegador**

1. **Backend API:** `http://TU_IP_PUBLICA/api/products`
2. **Frontend Ecommerce:** `http://TU_IP_PUBLICA/`
3. **Frontend Admin:** `http://TU_IP_PUBLICA/admin`

---

## 🔒 PARTE 10: CONFIGURAR SSL/HTTPS (OPCIONAL PERO RECOMENDADO)

### **Requisito: Tener un dominio**

Si tienes un dominio (ej: `noblestep.com`):

### **Paso 1: Apuntar dominio a tu IP**

En tu proveedor de dominio (GoDaddy, Namecheap, etc.):

```
Tipo: A
Host: @
Valor: TU_IP_PUBLICA
TTL: 3600

Tipo: A
Host: www
Valor: TU_IP_PUBLICA
TTL: 3600
```

### **Paso 2: Instalar Certbot**

```bash
# Instalar Certbot
sudo apt install -y certbot python3-certbot-nginx

# Obtener certificado SSL
sudo certbot --nginx -d tudominio.com -d www.tudominio.com

# Responder preguntas:
# Email: tu@email.com
# Términos: A (Agree)
# Compartir email: N (No)
# Redirect HTTP to HTTPS: 2 (Sí, redirigir)
```

### **Paso 3: Renovación automática**

```bash
# Certbot ya configura renovación automática
# Verificar:
sudo systemctl status certbot.timer

# Probar renovación:
sudo certbot renew --dry-run
```

---

## 📊 PARTE 11: MONITOREO Y MANTENIMIENTO

### **Comandos útiles:**

```bash
# Ver logs del backend
sudo journalctl -u noblestep-api -f

# Ver logs de Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Ver uso de recursos
htop  # (instalar: sudo apt install htop)

# Reiniciar servicios
sudo systemctl restart noblestep-api
sudo systemctl restart nginx
sudo systemctl restart mysql

# Ver espacio en disco
df -h

# Ver memoria
free -h
```

### **Backup de base de datos:**

```bash
# Crear backup
mysqldump -u noblestep_user -p noblestep_db > backup_$(date +%Y%m%d).sql

# Automatizar con cron (diario a las 2 AM)
crontab -e

# Agregar línea:
0 2 * * * mysqldump -u noblestep_user -pTuPassword noblestep_db > /home/ubuntu/backups/backup_$(date +\%Y\%m\%d).sql
```

---

## 🎯 CHECKLIST FINAL

- [ ] Cuenta Oracle Cloud creada
- [ ] VM Ampere (4 vCPUs, 24GB RAM) creada
- [ ] Puertos abiertos en Security List (80, 443, 5000)
- [ ] Conexión SSH funcionando
- [ ] .NET 8 instalado
- [ ] MySQL instalado y configurado
- [ ] Nginx instalado
- [ ] Base de datos importada
- [ ] Backend desplegado y corriendo
- [ ] Frontends desplegados
- [ ] Nginx configurado correctamente
- [ ] Todo accesible desde navegador
- [ ] (Opcional) SSL/HTTPS configurado
- [ ] (Opcional) Dominio configurado

---

## 🆘 TROUBLESHOOTING

### **Problema: "Out of capacity" al crear VM**

**Solución:**
- Cambiar Availability Domain (AD-2, AD-3)
- Intentar en diferente horario (madrugada funciona mejor)
- Cambiar región (Chile a Brazil)

### **Problema: No puedo conectar por SSH**

**Solución:**
```bash
# Verificar permisos de clave
chmod 400 noblestep-key.key

# Verificar que sea la clave correcta
ssh -i noblestep-key.key -v ubuntu@TU_IP
```

### **Problema: Backend no arranca**

**Solución:**
```bash
# Ver logs
sudo journalctl -u noblestep-api -n 50

# Verificar que el archivo existe
ls -la /home/ubuntu/backend/NobleStep.Api.dll

# Probar manualmente
cd /home/ubuntu/backend
dotnet NobleStep.Api.dll
```

### **Problema: 502 Bad Gateway en Nginx**

**Solución:**
```bash
# Verificar que backend esté corriendo
sudo systemctl status noblestep-api

# Ver logs de Nginx
sudo tail -f /var/log/nginx/error.log

# Verificar que el puerto 5000 esté escuchando
sudo netstat -tlnp | grep 5000
```

### **Problema: No puedo acceder a MySQL**

**Solución:**
```bash
# Verificar que MySQL esté corriendo
sudo systemctl status mysql

# Resetear contraseña de root
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'nueva_password';
FLUSH PRIVILEGES;
```

---

## 💡 OPTIMIZACIONES ADICIONALES

### **1. Configurar caché en Nginx**

```nginx
# En /etc/nginx/sites-available/noblestep
location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

### **2. Comprimir respuestas**

```nginx
# En /etc/nginx/nginx.conf (dentro de http {})
gzip on;
gzip_vary on;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
```

### **3. Limitar logs de MySQL**

```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

# Agregar:
slow_query_log = 0
general_log = 0
```

---

## 🎉 ¡FELICIDADES!

**Tu aplicación NobleStep está desplegada en Oracle Cloud GRATIS para siempre!**

**URLs:**
- 🌐 Ecommerce: `http://TU_IP/`
- 🔧 Admin: `http://TU_IP/admin`
- 🔌 API: `http://TU_IP/api/`

---

## 📚 RECURSOS ADICIONALES

- Oracle Cloud Docs: https://docs.oracle.com/en-us/iaas/
- .NET Deployment: https://learn.microsoft.com/aspnet/core/host-and-deploy/
- Nginx Docs: https://nginx.org/en/docs/
- Let's Encrypt: https://letsencrypt.org/

---

**¿Necesitas ayuda con algún paso específico?** 😊
