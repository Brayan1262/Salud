# 🚀 Guía de Configuración Completa de SonarQube

Esta guía te llevará paso a paso para configurar SonarQube en tu proyecto.

## 📋 Índice

1. [Instalación de SonarScanner](#instalación-de-sonarscanner)
2. [Configuración de SonarCloud](#configuración-de-sonarcloud)
3. [Configuración de GitHub Secrets](#configuración-de-github-secrets)
4. [Actualizar Configuración del Proyecto](#actualizar-configuración-del-proyecto)
5. [Verificación](#verificación)

---

## 1. Instalación de SonarScanner

### Opción A: Instalación Automática (Windows) ⭐

1. **Abre PowerShell como Administrador:**
   - Clic derecho en PowerShell
   - Selecciona "Ejecutar como administrador"

2. **Navega a tu proyecto:**
   ```powershell
   cd "C:\Users\Administrador\Downloads\Healthy IA"
   ```

3. **Ejecuta el script de instalación:**
   ```powershell
   .\instalar-sonarscanner.ps1
   ```

4. **Cierra y vuelve a abrir PowerShell** para actualizar el PATH

5. **Verifica la instalación:**
   ```powershell
   sonar-scanner --version
   ```

### Opción B: Instalación Manual (Windows)

1. **Descarga SonarScanner:**
   - Ve a: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/
   - Descarga: `sonar-scanner-cli-5.0.1.3006-windows.zip`

2. **Extrae el archivo:**
   - Extrae en `C:\sonar-scanner`

3. **Agrega al PATH:**
   - Abre "Variables de entorno" (Win + R → `sysdm.cpl` → Avanzado)
   - Edita la variable "Path" del sistema
   - Agrega: `C:\sonar-scanner\bin`

4. **Verifica:**
   ```powershell
   sonar-scanner --version
   ```

### Opción C: Instalación Manual (Linux/Mac)

```bash
# Descargar
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip

# Extraer
unzip sonar-scanner-cli-5.0.1.3006-linux.zip
sudo mv sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner

# Agregar al PATH
export PATH=$PATH:/opt/sonar-scanner/bin

# Hacer permanente (agregar a ~/.bashrc o ~/.zshrc)
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' >> ~/.bashrc
```

---

## 2. Configuración de SonarCloud

### Paso 1: Crear Cuenta en SonarCloud

1. **Ve a SonarCloud:**
   - Abre: https://sonarcloud.io
   - Haz clic en **"Log in"**

2. **Inicia sesión con GitHub:**
   - Selecciona **"Log in with GitHub"**
   - Autoriza los permisos necesarios
   - Acepta los términos de servicio

### Paso 2: Crear Organización

1. **Crea una organización:**
   - En SonarCloud, haz clic en **"+"** → **"Create Organization"**
   - Elige un nombre (ej: `brayan1262` o `tu-usuario`)
   - Selecciona el plan **"Free"** (gratis para proyectos públicos)

### Paso 3: Crear Proyecto

1. **Crea un nuevo proyecto:**
   - Haz clic en **"+"** → **"Analyze new project"**
   - Selecciona **"From GitHub"**

2. **Conecta tu repositorio:**
   - Autoriza el acceso a GitHub si es necesario
   - Selecciona tu organización
   - Busca y selecciona: **"Brayan1262/Salud"**

3. **Configura el proyecto:**
   - SonarCloud generará automáticamente:
     - **Project Key**: `brayan1262_salud` (o similar)
     - **Organization Key**: `brayan1262` (o el nombre de tu org)

4. **Guarda estos valores:**
   - 📝 **Project Key**: `_________________`
   - 📝 **Organization Key**: `_________________`

### Paso 4: Generar Token

1. **Ve a tu cuenta:**
   - Haz clic en tu avatar (esquina superior derecha)
   - Selecciona **"My Account"**

2. **Genera un token:**
   - Ve a la pestaña **"Security"**
   - En "Generate Tokens", escribe un nombre (ej: "GitHub Actions")
   - Haz clic en **"Generate"**
   - ⚠️ **COPIA EL TOKEN INMEDIATAMENTE** (solo se muestra una vez)
   - 📝 **Token**: `_________________`

---

## 3. Configuración de GitHub Secrets

### Paso 1: Agregar Secret en GitHub

1. **Ve a tu repositorio:**
   - Abre: https://github.com/Brayan1262/Salud

2. **Ve a Settings:**
   - Haz clic en **"Settings"** (pestaña superior)

3. **Ve a Secrets:**
   - En el menú lateral, ve a **"Secrets and variables"**
   - Selecciona **"Actions"**

4. **Agrega el secret:**
   - Haz clic en **"New repository secret"**
   - **Name**: `SONAR_TOKEN`
   - **Secret**: [Pega el token que copiaste de SonarCloud]
   - Haz clic en **"Add secret"**

✅ **Listo!** El secret `SONAR_TOKEN` está configurado.

---

## 4. Actualizar Configuración del Proyecto

### Paso 1: Actualizar sonar-project.properties

Edita el archivo `sonar-project.properties` y actualiza con tus valores:

```properties
# Reemplaza con tu Project Key de SonarCloud
sonar.projectKey=brayan1262_salud

# Reemplaza con tu Organization Key
sonar.organization=brayan1262
```

**Ejemplo completo:**
```properties
sonar.projectKey=brayan1262_salud
sonar.projectName=Healthy IA
sonar.projectVersion=1.0.0
sonar.organization=brayan1262
```

### Paso 2: Hacer Commit y Push

```bash
git add sonar-project.properties
git commit -m "Configurar SonarCloud: actualizar projectKey y organization"
git push origin main
```

---

## 5. Verificación

### Verificar que Todo Funciona

1. **Crear un Pull Request:**
   - Crea una rama nueva: `git checkout -b test-sonarqube`
   - Haz un cambio pequeño
   - Haz commit y push: `git push origin test-sonarqube`
   - Crea un Pull Request en GitHub

2. **Verificar el Workflow:**
   - Ve a **"Actions"** en GitHub
   - Deberías ver el workflow **"SonarCloud Analysis"** ejecutándose
   - Espera a que complete (puede tardar 2-5 minutos)

3. **Ver Resultados en SonarCloud:**
   - Ve a: https://sonarcloud.io
   - Selecciona tu proyecto
   - Deberías ver el análisis completo con:
     - 🐛 Bugs encontrados
     - 🔒 Vulnerabilidades
     - 💨 Code Smells
     - 📊 Cobertura de código

### Ejecutar Análisis Localmente (Opcional)

```bash
# Generar cobertura de tests
npm run test:coverage

# Ejecutar SonarScanner
npm run sonar
```

---

## 🎯 Resumen de Valores Necesarios

Completa estos valores mientras sigues la guía:

- ✅ **Organization Key**: `_________________`
- ✅ **Project Key**: `_________________`
- ✅ **SONAR_TOKEN**: `_________________` (ya configurado en GitHub Secrets)

---

## 🔧 Solución de Problemas

### Error: "sonar-scanner: command not found"

**Solución:**
- Verifica que SonarScanner esté instalado: `sonar-scanner --version`
- Si no funciona, cierra y vuelve a abrir PowerShell
- Verifica el PATH: `$env:PATH` (debe incluir `C:\sonar-scanner\bin`)

### Error: "SONAR_TOKEN not found"

**Solución:**
- Verifica que hayas agregado el secret en GitHub
- Settings → Secrets and variables → Actions
- Debe existir `SONAR_TOKEN`

### Error: "Project key already exists"

**Solución:**
- Verifica que el `sonar.projectKey` en `sonar-project.properties` coincida con el de SonarCloud
- El formato debe ser: `organizacion_proyecto`

### El análisis no se ejecuta

**Solución:**
- Verifica que el workflow esté activo: `.github/workflows/sonarqube-cloud.yml`
- Crea un Pull Request (los workflows están configurados para ejecutarse en PRs)
- O ejecuta manualmente desde GitHub Actions → "Run workflow"

---

## 📚 Recursos Adicionales

- [Documentación de SonarCloud](https://docs.sonarcloud.io/)
- [Documentación de SonarScanner](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)
- [README_SONARQUBE.md](README_SONARQUBE.md) - Documentación completa

---

## ✅ Checklist de Configuración

- [ ] SonarScanner instalado y funcionando
- [ ] Cuenta de SonarCloud creada
- [ ] Organización creada en SonarCloud
- [ ] Proyecto creado en SonarCloud
- [ ] Token generado y copiado
- [ ] Secret `SONAR_TOKEN` agregado en GitHub
- [ ] `sonar-project.properties` actualizado con Project Key y Organization
- [ ] Cambios commiteados y pusheados
- [ ] Workflow ejecutado exitosamente
- [ ] Resultados visibles en SonarCloud

---

## 🎉 ¡Listo!

Una vez completados todos los pasos, SonarQube analizará automáticamente tu código en cada Pull Request, ayudándote a mantener un código de alta calidad.

