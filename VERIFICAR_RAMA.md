# 🔍 Guía: Verificar y Cambiar la Rama de Git

## Problema

Estás recibiendo el error:
```
push declined due to repository rule violations
```

Esto puede deberse a que tu rama local no coincide con las ramas permitidas en el repositorio remoto.

---

## Paso 1: Verificar tu Rama Actual

### Opción A: Usar el Script Automático (Recomendado)

Ejecuta el script de PowerShell que creamos:

```powershell
.\verificar-rama.ps1
```

Este script te mostrará:
- ✅ Tu rama actual
- 📋 Todas las ramas locales y remotas
- 🔗 Los remotes configurados
- 📊 El estado de tu repositorio

### Opción B: Comandos Manuales

Abre PowerShell o Git Bash y ejecuta:

```bash
# Ver tu rama actual
git branch --show-current

# Ver todas las ramas locales
git branch

# Ver ramas remotas
git branch -r

# Ver el estado del repositorio
git status

# Ver remotes configurados
git remote -v
```

---

## Paso 2: Identificar la Rama Correcta

Según los workflows de GitHub Actions que configuramos, el repositorio acepta estas ramas:
- ✅ `main` (recomendado)
- ✅ `master` (alternativa)
- ✅ `develop` (para desarrollo)

**La rama más común y recomendada es `main`.**

---

## Paso 3: Soluciones Según tu Situación

### Situación 1: Estás en una rama diferente (ej: `master`, `develop`, etc.)

#### Opción A: Cambiar a la rama `main` existente

```bash
# Si la rama main ya existe localmente
git checkout main

# Si la rama main existe en el remoto pero no localmente
git checkout -b main origin/main
```

#### Opción B: Renombrar tu rama actual a `main`

```bash
# Renombrar la rama actual a 'main'
git branch -m main

# Si ya habías hecho push de la rama anterior, actualiza el remoto
git push origin -u main

# Elimina la rama antigua del remoto (opcional)
git push origin --delete nombre-rama-antigua
```

### Situación 2: No tienes la rama `main` localmente

```bash
# Crear y cambiar a la rama main
git checkout -b main

# Si quieres que se base en una rama remota específica
git checkout -b main origin/master
# o
git checkout -b main origin/develop
```

### Situación 3: Estás en `master` y quieres usar `main`

```bash
# Renombrar master a main
git branch -m master main

# Hacer push de la nueva rama
git push origin -u main

# Si quieres eliminar master del remoto (opcional)
git push origin --delete master
```

### Situación 4: Crear una nueva rama para desarrollo

Si las reglas del repositorio requieren usar Pull Requests:

```bash
# Crear una nueva rama para tus cambios
git checkout -b feature/mis-cambios

# Hacer tus cambios y commits
git add .
git commit -m "Mis cambios"

# Push a la nueva rama
git push origin feature/mis-cambios

# Luego crear un Pull Request en GitHub hacia 'main'
```

---

## Paso 4: Verificar las Reglas del Repositorio

El error "push declined due to repository rule violations" también puede deberse a:

### 1. Reglas de Protección de Rama

En GitHub:
1. Ve a tu repositorio: `https://github.com/Brayan1262/Salud`
2. **Settings** → **Branches**
3. Busca "Branch protection rules" para `main`
4. Verifica qué reglas están activas:
   - ✅ Require pull request reviews
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date
   - ✅ Restrict who can push to matching branches

### 2. Solución: Usar Pull Request

Si las reglas requieren Pull Requests:

```bash
# 1. Crear una rama nueva
git checkout -b feature/mis-cambios

# 2. Hacer tus cambios
git add .
git commit -m "Descripción de cambios"

# 3. Push a la nueva rama
git push origin feature/mis-cambios

# 4. En GitHub, crear un Pull Request hacia 'main'
```

---

## Paso 5: Hacer Push Correctamente

Una vez que estés en la rama correcta:

```bash
# Verificar que estás en la rama correcta
git branch --show-current

# Debería mostrar: main

# Hacer push
git push origin main

# Si es la primera vez, usa:
git push -u origin main
```

---

## Comandos Útiles de Referencia

```bash
# Ver rama actual
git branch --show-current

# Cambiar de rama
git checkout nombre-rama

# Crear nueva rama y cambiar a ella
git checkout -b nueva-rama

# Renombrar rama actual
git branch -m nuevo-nombre

# Ver todas las ramas (locales y remotas)
git branch -a

# Ver diferencias entre ramas
git diff main..tu-rama

# Sincronizar con el remoto
git fetch origin
git pull origin main
```

---

## Verificación Final

Después de cambiar de rama, verifica:

```bash
# 1. Confirmar que estás en la rama correcta
git branch --show-current
# Debe mostrar: main

# 2. Verificar que estás sincronizado
git status
# Debe mostrar: "Your branch is up to date with 'origin/main'"

# 3. Intentar push
git push origin main
```

---

## Si el Problema Persiste

Si después de cambiar a `main` aún recibes el error:

1. **Verifica las reglas de protección** en GitHub Settings → Branches
2. **Usa Pull Requests** en lugar de push directo
3. **Contacta al administrador** del repositorio si no tienes permisos
4. **Revisa los workflows** en `.github/workflows/` - pueden estar bloqueando

---

## Resumen Rápido

```bash
# 1. Verificar rama actual
git branch --show-current

# 2. Si no estás en 'main', cambiar o renombrar
git checkout -b main          # Crear y cambiar a main
# o
git branch -m main            # Renombrar rama actual a main

# 3. Hacer push
git push origin main
```

---

## ¿Necesitas Más Ayuda?

- Lee `SOLUCION_ERROR_PUSH.md` para más soluciones
- Revisa la configuración de workflows en `.github/workflows/`
- Verifica las reglas de protección en GitHub

