# ⚡ Inicio Rápido: SonarQube en 5 Pasos

## 🎯 Configuración Rápida

### Paso 1: Instalar SonarScanner (2 minutos)

**Windows:**
```powershell
# Abre PowerShell como Administrador
.\instalar-sonarscanner.ps1
```

**Verificar:**
```powershell
sonar-scanner --version
```

---

### Paso 2: Crear Cuenta en SonarCloud (1 minuto)

1. Ve a: https://sonarcloud.io
2. Haz clic en **"Log in"** → **"Log in with GitHub"**
3. Autoriza los permisos

---

### Paso 3: Crear Proyecto (1 minuto)

1. En SonarCloud: **"+"** → **"Analyze new project"**
2. Selecciona **"From GitHub"**
3. Selecciona tu repositorio: **"Brayan1262/Salud"**
4. **Guarda estos valores:**
   - Project Key: `_________________`
   - Organization Key: `_________________`

---

### Paso 4: Configurar GitHub Secret (1 minuto)

1. GitHub → Tu repositorio → **Settings** → **Secrets and variables** → **Actions**
2. **"New repository secret"**
3. Name: `SONAR_TOKEN`
4. Value: [Token de SonarCloud - My Account → Security → Generate Token]
5. **"Add secret"**

---

### Paso 5: Actualizar Configuración (1 minuto)

Edita `sonar-project.properties`:

```properties
sonar.projectKey=TU_PROJECT_KEY_AQUI
sonar.organization=TU_ORGANIZATION_AQUI
```

Haz commit y push:
```bash
git add sonar-project.properties
git commit -m "Configurar SonarCloud"
git push origin main
```

---

## ✅ ¡Listo!

Crea un Pull Request y SonarQube analizará tu código automáticamente.

---

## 📚 Documentación Completa

- **CONFIGURAR_SONARQUBE.md** - Guía paso a paso detallada
- **README_SONARQUBE.md** - Documentación completa
- **SONARQUBE_QUICKSTART.md** - Referencia rápida

---

## 🆘 ¿Problemas?

Lee **CONFIGURAR_SONARQUBE.md** → Sección "Solución de Problemas"

