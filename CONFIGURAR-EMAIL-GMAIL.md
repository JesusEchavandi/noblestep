# 📧 Configuración de Email con Gmail

## Guía Paso a Paso para Configurar el Envío de Emails

### ⚠️ Importante
El sistema necesita enviar emails para:
- **Recuperación de contraseña**
- **Confirmación de pedidos**

---

## 📝 Paso 1: Obtener Contraseña de Aplicación de Gmail

### 1.1 Acceder a tu Cuenta de Google
1. Ve a: https://myaccount.google.com/
2. Inicia sesión con tu cuenta de Gmail

### 1.2 Activar Verificación en 2 Pasos
1. En el menú izquierdo, haz clic en **"Seguridad"**
2. Busca **"Verificación en 2 pasos"**
3. Si no está activada, haz clic en **"Empezar"** y sigue las instrucciones
4. ✅ Asegúrate de que esté **ACTIVADA**

### 1.3 Crear Contraseña de Aplicación
1. En la página de Seguridad, busca **"Contraseñas de aplicaciones"**
2. Haz clic en **"Contraseñas de aplicaciones"**
3. Es posible que te pida verificar tu contraseña
4. Selecciona:
   - **Aplicación**: Correo
   - **Dispositivo**: Windows Computer (o el que prefieras)
5. Haz clic en **"Generar"**
6. 🔑 Google mostrará una contraseña de 16 caracteres como: `abcd efgh ijkl mnop`
7. **COPIA ESTA CONTRASEÑA** (solo se muestra una vez)

---

## 🔧 Paso 2: Configurar en el Backend

### 2.1 Editar appsettings.json

Abre el archivo: `backend/appsettings.json`

Busca la sección `"Email"` y actualiza los valores:

```json
{
  "Email": {
    "FromEmail": "tu_correo@gmail.com",
    "FromName": "NobleStep Shop",
    "SmtpHost": "smtp.gmail.com",
    "SmtpPort": "587",
    "SmtpUsername": "tu_correo@gmail.com",
    "SmtpPassword": "abcd efgh ijkl mnop"
  },
  "App": {
    "FrontendUrl": "http://localhost:4201"
  }
}
```

### 2.2 Valores a Reemplazar

- **FromEmail**: Tu dirección de Gmail (ejemplo: `tienda@gmail.com`)
- **SmtpUsername**: La misma dirección de Gmail
- **SmtpPassword**: La contraseña de aplicación que generaste (16 caracteres con espacios)

### ⚠️ Advertencias
- **NO uses tu contraseña normal de Gmail**
- **SOLO usa la contraseña de aplicación** que generaste
- Mantén este archivo seguro y **NO lo subas a repositorios públicos**

---

## ✅ Paso 3: Verificar Configuración

### 3.1 Reiniciar el Backend
Si el backend está corriendo, reinícialo para que cargue la nueva configuración:

```powershell
# Detener el backend (Ctrl+C)
# Iniciar nuevamente
cd backend
dotnet run
```

### 3.2 Probar Envío de Email

**Opción 1: Recuperación de Contraseña**
1. Ve al e-commerce: http://localhost:4201
2. Haz clic en el icono de usuario
3. Clic en "¿Olvidaste tu contraseña?"
4. Ingresa un email registrado
5. Revisa tu bandeja de entrada
6. ✅ Deberías recibir el email en 5-10 segundos

**Opción 2: Pedido**
1. Realiza una compra en el e-commerce
2. Completa el checkout
3. Revisa tu bandeja de entrada
4. ✅ Deberías recibir confirmación del pedido

---

## 🐛 Solución de Problemas

### ❌ No llegan los emails

**Causa 1: Contraseña incorrecta**
- Verifica que hayas copiado bien la contraseña de aplicación
- Verifica que no haya espacios extra al inicio o final
- La contraseña debe tener exactamente 16 caracteres (incluyendo espacios)

**Causa 2: Verificación en 2 pasos no activada**
- Las contraseñas de aplicación SOLO funcionan si la verificación en 2 pasos está activa
- Ve a tu cuenta de Google y verifica que esté activada

**Causa 3: Email en spam**
- Revisa tu carpeta de spam/correo no deseado
- Marca como "No es spam" para futuros emails

**Causa 4: Backend no reiniciado**
- Después de cambiar la configuración, debes reiniciar el backend
- Detén el proceso con Ctrl+C e inícialo nuevamente

### ❌ Error "Authentication failed"

Esto significa que las credenciales son incorrectas:
1. Verifica que el email sea correcto
2. Genera una NUEVA contraseña de aplicación
3. Actualiza el appsettings.json con la nueva contraseña
4. Reinicia el backend

### ❌ Error "SMTP server not found"

Verifica la configuración:
- `SmtpHost`: debe ser `smtp.gmail.com`
- `SmtpPort`: debe ser `587`

---

## 📋 Checklist de Configuración

- [ ] Verificación en 2 pasos activada en Google
- [ ] Contraseña de aplicación generada
- [ ] `appsettings.json` actualizado con:
  - [ ] FromEmail correcto
  - [ ] SmtpUsername correcto
  - [ ] SmtpPassword correcto (16 caracteres)
- [ ] Backend reiniciado
- [ ] Email de prueba enviado y recibido

---

## 🔒 Seguridad

### ⚠️ NUNCA hagas lo siguiente:
- ❌ NO compartas tu contraseña de aplicación
- ❌ NO subas appsettings.json con credenciales reales a GitHub
- ❌ NO uses tu contraseña normal de Gmail

### ✅ Buenas prácticas:
- ✅ Usa contraseñas de aplicación específicas
- ✅ Usa variables de entorno en producción
- ✅ Agrega appsettings.json a .gitignore
- ✅ Crea un appsettings.Example.json sin credenciales reales para el repositorio

---

## 📧 Ejemplo de Email de Recuperación

Así se verá el email que reciben los usuarios:

```
Asunto: Restablecer tu contraseña - NobleStep

Hola [Nombre],

Recibimos una solicitud para restablecer tu contraseña.

Haz clic en el siguiente botón para crear una nueva contraseña:

[Restablecer Contraseña]

Este enlace expirará en 1 hora.

Si no solicitaste restablecer tu contraseña, puedes ignorar este correo.

© 2025 NobleStep. Todos los derechos reservados.
```

---

## 📧 Ejemplo de Email de Confirmación de Pedido

```
Asunto: Confirmación de Pedido #ORD-20250206-ABC123 - NobleStep

¡Gracias por tu compra, [Nombre]!

Tu pedido ha sido recibido exitosamente.

Número de Pedido: #ORD-20250206-ABC123

Estamos procesando tu pedido y te enviaremos actualizaciones por correo electrónico.

Puedes ver el estado de tu pedido en tu panel de usuario en nuestro sitio web.

© 2025 NobleStep. Todos los derechos reservados.
```

---

## 🎯 Resultado Esperado

Una vez configurado correctamente:
- ✅ Los usuarios pueden recuperar su contraseña por email
- ✅ Reciben confirmación al realizar un pedido
- ✅ Los emails llegan en 5-10 segundos
- ✅ Los emails se ven profesionales con el nombre de tu tienda

---

**¡Listo! Tu sistema de emails está configurado.** 🎉
