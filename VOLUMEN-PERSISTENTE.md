# Configurar Volumen Persistente en Railway para WordPress

## 🎯 Objetivo

Crear un volumen persistente para `/var/www/html/wp-content` en Railway, para que:
- Los plugins instalados se mantengan entre deploys
- Los uploads (imágenes, archivos) no se borren
- Los temas personalizados persistan
- No tener que subir archivos pesados a Git

---

## 📋 Pasos para configurar el volumen

### 1. Acceder al Dashboard de Railway

1. Abre: https://railway.app/dashboard
2. Entra al proyecto: **Facfast Proyect**
3. Click en el servicio: **wordpress-growthhacking**

### 2. Crear el volumen

1. **Ve a la pestaña "Volumes"** (en el menú lateral del servicio)
2. **Click en "New Volume"** o "+ Create Volume"
3. Configura:
   - **Mount Path**: `/var/www/html/wp-content`
   - **Size**: Puedes dejarlo en el valor por defecto (Railway ajusta automáticamente)
4. **Click en "Create"** o "Add Volume"

### 3. Esperar redespliegue

- Railway redespliegará automáticamente el servicio
- Espera 2-3 minutos a que termine el deploy
- Verifica que el servicio esté "Active" (verde)

### 4. Verificar que funciona

1. Accede a: https://growthhacking.cl/wp-admin
2. Ve a **Plugins** → **Añadir nuevo plugin**
3. Instala cualquier plugin de prueba (ejemplo: "Hello Dolly")
4. Verifica que el plugin se instale correctamente

---

## ✅ Beneficios del volumen persistente

| Sin volumen | Con volumen |
|------------|-------------|
| ❌ Plugins se borran en cada deploy | ✅ Plugins persisten entre deploys |
| ❌ Uploads se pierden | ✅ Uploads se mantienen |
| ❌ Temas personalizados se borran | ✅ Temas se mantienen |
| ❌ Necesitas subir todo a Git | ✅ Solo código en Git |

---

## 🔍 Troubleshooting

### Problema: "El volumen está vacío después de crear"

**Causa**: Es normal, el volumen empieza vacío

**Solución**:
1. WordPress copiará automáticamente los archivos por defecto de `wp-content` al volumen
2. Puedes instalar plugins y temas normalmente desde wp-admin

### Problema: "Los plugins no aparecen después de crear el volumen"

**Causa**: El volumen nuevo está vacío, no tiene los archivos de wp-content

**Solución**:
1. Reinstala los plugins que necesites desde wp-admin
2. O copia los archivos del backup local al volumen (ver siguiente sección)

---

## 📤 Copiar archivos del backup al volumen (opcional)

Si tienes un backup local y quieres copiar los plugins/uploads al volumen:

### Método 1: Usando Railway CLI

```bash
# 1. Conecta al contenedor de WordPress
railway run bash

# 2. Desde tu Mac, en otra terminal, copia los archivos
# (Necesitas tener acceso SSH configurado)
rsync -avz /ruta/local/wp-content/ railway:/var/www/html/wp-content/
```

### Método 2: Usando All-in-One WP Migration

1. Instala plugin "All-in-One WP Migration" en el WordPress nuevo
2. Importa el backup desde el archivo .wpress
3. El plugin copiará automáticamente todo al volumen

### Método 3: Manual vía FTP/SFTP (si Railway lo permite)

1. Configura acceso SFTP al contenedor
2. Usa FileZilla o similar
3. Copia archivos desde tu Mac al volumen

---

## 🎉 Resultado final

Una vez configurado el volumen persistente:

- ✅ Puedes instalar plugins desde wp-admin sin preocuparte
- ✅ Las imágenes que subas se mantendrán
- ✅ Los temas que instales persistirán
- ✅ El repositorio Git se mantiene limpio (solo código)
- ✅ Deploys más rápidos (no copia archivos pesados)

---

## 📝 Notas importantes

1. **El volumen tiene un costo**: Railway cobra por almacenamiento usado
2. **Backups**: Asegúrate de hacer backups periódicos del volumen
3. **Migraciones**: Si cambias de proyecto, necesitas copiar el volumen
4. **Tamaño**: Monitorea el uso de espacio para evitar costos inesperados
