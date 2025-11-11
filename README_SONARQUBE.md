# 🔍 Configuración de SonarQube para Healthy IA

Esta guía te ayudará a configurar SonarQube para analizar la calidad del código de tu proyecto desde GitHub.

## 📋 Tabla de Contenidos

1. [¿Qué es SonarQube?](#qué-es-sonarqube)
2. [Opciones de Instalación](#opciones-de-instalación)
3. [Configuración con SonarCloud (Recomendado - Gratis)](#configuración-con-sonarcloud-recomendado---gratis)
4. [Configuración con SonarQube Server (Self-hosted)](#configuración-con-sonarqube-server-self-hosted)
5. [Configuración de GitHub Secrets](#configuración-de-github-secrets)
6. [Ejecución Local](#ejecución-local)
7. [Verificación](#verificación)
8. [Solución de Problemas](#solución-de-problemas)

---

## ¿Qué es SonarQube?

SonarQube es una plataforma de análisis estático de código que detecta:
- 🐛 **Bugs** y errores potenciales
- 🔒 **Vulnerabilidades** de seguridad
- 💨 **Code Smells** (malas prácticas)
- 📊 **Cobertura de código** y duplicación
- 📈 **Métricas** de calidad y deuda técnica

---

## Opciones de Instalación

Tienes dos opciones principales:

### 1. **SonarCloud** (Recomendado para proyectos pequeños/medianos)
- ✅ **Gratis** para proyectos públicos
- ✅ No requiere servidor propio
- ✅ Fácil de configurar
- ✅ Integración directa con GitHub

### 2. **SonarQube Server** (Para empresas/proyectos privados)
- ⚙️ Requiere servidor propio
- 💰 Licencia Community (gratis) o Enterprise (pago)
- 🔒 Más control sobre datos

---

## Configuración con SonarCloud (Recomendado - Gratis)

### Paso 1: Crear cuenta en SonarCloud

1. Ve a [https://sonarcloud.io](https://sonarcloud.io)
2. Haz clic en **"Log in"** y autoriza con tu cuenta de GitHub
3. Acepta los permisos necesarios

### Paso 2: Crear un proyecto

1. En SonarCloud, haz clic en **"+"** → **"Analyze new project"**
2. Selecciona tu organización (o crea una nueva)
3. Selecciona tu repositorio de GitHub
4. Elige **"From GitHub"** y selecciona tu repositorio
5. SonarCloud generará automáticamente:
   - **Project Key**: `tu-org_healthy-ia` (o similar)
   - **Organization Key**: `tu-org`

### Paso 3: Obtener tokens

1. Ve a **"My Account"** → **"Security"**
2. Genera un nuevo token (guárdalo, solo se muestra una vez)
3. Copia el token generado

### Paso 4: Usar el workflow de SonarCloud

**IMPORTANTE**: Para SonarCloud, usa el archivo `.github/workflows/sonarqube-cloud.yml` que ya está configurado.

Si prefieres usar el workflow genérico (`.github/workflows/sonarqube.yml`), renómbralo o elimínalo para evitar conflictos:

```bash
# Opción 1: Renombrar el workflow genérico
mv .github/workflows/sonarqube.yml .github/workflows/sonarqube-server.yml

# Opción 2: Eliminar el workflow genérico si solo usas SonarCloud
# (El workflow sonarqube-cloud.yml ya está listo para usar)
```

El archivo `sonarqube-cloud.yml` ya está configurado correctamente para SonarCloud.

### Paso 5: Configurar GitHub Secrets

1. Ve a tu repositorio en GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. Haz clic en **"New repository secret"**
4. Agrega estos secrets:

| Secret Name | Valor | Descripción |
|------------|-------|-------------|
| `SONAR_TOKEN` | Tu token de SonarCloud | Token generado en SonarCloud |
| `SONAR_HOST_URL` | `https://sonarcloud.io` | URL de SonarCloud (solo si usas SonarQube Server) |

### Paso 6: Actualizar sonar-project.properties

Edita `sonar-project.properties` y actualiza:

```properties
# Reemplaza con tu Project Key de SonarCloud
sonar.projectKey=tu-org_healthy-ia

# Agrega tu Organization Key
sonar.organization=tu-org
```

---

## Configuración con SonarQube Server (Self-hosted)

### Paso 1: Instalar SonarQube Server

#### Opción A: Docker (Recomendado)

```bash
# Ejecutar SonarQube en Docker
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
```

Accede a: `http://localhost:9000`
- Usuario por defecto: `admin`
- Contraseña por defecto: `admin` (cambiar en primer inicio)

#### Opción B: Descarga directa

1. Descarga SonarQube desde [https://www.sonarqube.org/downloads/](https://www.sonarqube.org/downloads/)
2. Extrae el archivo ZIP
3. Ejecuta:
   ```bash
   # Windows
   bin\windows-x86-64\StartSonar.bat
   
   # Linux/Mac
   bin/linux-x86-64/sonar.sh start
   ```

### Paso 2: Crear proyecto en SonarQube

1. Accede a `http://localhost:9000`
2. Inicia sesión con `admin/admin`
3. Ve a **"Projects"** → **"Create Project"**
4. Selecciona **"Manually"**
5. Ingresa:
   - **Project Key**: `healthy-ia`
   - **Display Name**: `Healthy IA`
6. Genera un token:
   - **My Account** → **Security** → **Generate Token**

### Paso 3: Instalar SonarScanner

#### Windows:

1. Descarga SonarScanner desde [https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)
2. Extrae en `C:\sonar-scanner` (o tu ubicación preferida)
3. Agrega `C:\sonar-scanner\bin` a tu PATH

#### Linux/Mac:

```bash
# Descargar y extraer
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
unzip sonar-scanner-cli-5.0.1.3006-linux.zip
sudo mv sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner
export PATH=$PATH:/opt/sonar-scanner/bin
```

### Paso 4: Configurar SonarScanner

Edita `conf/sonar-scanner.properties` (en la carpeta de SonarScanner):

```properties
sonar.host.url=http://localhost:9000
```

### Paso 5: Configurar GitHub Secrets

Si usas SonarQube Server en la nube, agrega:

| Secret Name | Valor |
|------------|-------|
| `SONAR_TOKEN` | Tu token de SonarQube |
| `SONAR_HOST_URL` | `https://tu-sonarqube-server.com` |

---

## Configuración de GitHub Secrets

### Para SonarCloud:

1. Ve a tu repositorio en GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. Agrega:

```
SONAR_TOKEN = [tu-token-de-sonarcloud]
```

### Para SonarQube Server:

```
SONAR_TOKEN = [tu-token-de-sonarqube]
SONAR_HOST_URL = [https://tu-sonarqube-server.com]
```

---

## Ejecución Local

### Prerrequisitos:

1. Tener SonarQube Server ejecutándose (o usar SonarCloud)
2. Tener SonarScanner instalado
3. Tener un token configurado

### Ejecutar análisis local:

```bash
# Con SonarCloud
npm run sonar

# Con SonarQube local
npm run sonar:local
```

O directamente:

```bash
sonar-scanner
```

### Con cobertura de tests:

```bash
# Generar cobertura
npm run test:coverage

# Ejecutar SonarQube (usará el reporte de cobertura)
npm run sonar
```

---

## Verificación

### 1. Verificar que el workflow funciona:

1. Haz un push a tu repositorio
2. Ve a **Actions** en GitHub
3. Verifica que el workflow **"SonarQube Analysis"** se ejecute correctamente

### 2. Ver resultados en SonarQube:

- **SonarCloud**: Ve a [https://sonarcloud.io](https://sonarcloud.io) → Tu proyecto
- **SonarQube Server**: Ve a `http://localhost:9000` → Tu proyecto

### 3. Verificar Quality Gate:

El Quality Gate indica si tu código cumple con los estándares de calidad:
- ✅ **Passed**: Código cumple con los estándares
- ❌ **Failed**: Hay problemas que resolver

---

## Solución de Problemas

### Error: "SONAR_TOKEN not found"

**Solución**: Verifica que hayas agregado el secret `SONAR_TOKEN` en GitHub:
- Settings → Secrets and variables → Actions

### Error: "Project key already exists"

**Solución**: 
- Si usas SonarCloud, el project key se genera automáticamente
- Actualiza `sonar-project.properties` con el project key correcto

### Error: "Unable to execute SonarScanner"

**Solución**:
- Verifica que SonarScanner esté instalado y en tu PATH
- Ejecuta: `sonar-scanner --version`

### El análisis no muestra cobertura de código

**Solución**:
1. Genera reporte de cobertura: `npm run test:coverage`
2. Verifica que se genere `coverage/lcov.info`
3. El archivo `sonar-project.properties` ya está configurado para usar este reporte

### Error de conexión con SonarQube Server

**Solución**:
- Verifica que SonarQube esté ejecutándose: `http://localhost:9000`
- Verifica la URL en `SONAR_HOST_URL`
- Verifica que el token sea válido

---

## Archivos Creados

Los siguientes archivos han sido creados para la configuración:

- ✅ `sonar-project.properties` - Configuración del proyecto
- ✅ `.github/workflows/sonarqube.yml` - Workflow para SonarQube Server (self-hosted)
- ✅ `.github/workflows/sonarqube-cloud.yml` - Workflow para SonarCloud (recomendado)
- ✅ `.gitignore` - Actualizado para excluir archivos de SonarQube
- ✅ `package.json` - Scripts agregados para ejecutar SonarQube

### ¿Qué workflow usar?

- **SonarCloud (Gratis)**: Usa `.github/workflows/sonarqube-cloud.yml`
- **SonarQube Server (Self-hosted)**: Usa `.github/workflows/sonarqube.yml`

---

## Próximos Pasos

1. ✅ Configura SonarCloud o SonarQube Server
2. ✅ Agrega los secrets en GitHub
3. ✅ Actualiza `sonar-project.properties` con tu project key
4. ✅ Haz un push y verifica que el análisis se ejecute
5. ✅ Revisa los resultados y corrige los problemas encontrados

---

## Recursos Adicionales

- [Documentación de SonarCloud](https://docs.sonarcloud.io/)
- [Documentación de SonarQube](https://docs.sonarqube.org/)
- [SonarScanner CLI](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)

---

## 🎉 ¡Listo!

Una vez configurado, SonarQube analizará automáticamente tu código en cada push y pull request, ayudándote a mantener un código de alta calidad.

