# 🚀 SonarQube - Guía Rápida

## Configuración Rápida (5 minutos)

### Opción 1: SonarCloud (Recomendado - Gratis) ⭐

1. **Crear cuenta**: [https://sonarcloud.io](https://sonarcloud.io) → Login con GitHub
2. **Crear proyecto**: "+" → "Analyze new project" → Selecciona tu repo
3. **Obtener token**: My Account → Security → Generate Token
4. **Configurar GitHub Secret**:
   - Repo → Settings → Secrets → Actions → New secret
   - Name: `SONAR_TOKEN`
   - Value: [Tu token de SonarCloud]
5. **Actualizar `sonar-project.properties`**:
   ```properties
   sonar.projectKey=tu-org_healthy-ia
   sonar.organization=tu-org
   ```
6. **¡Listo!** El workflow `.github/workflows/sonarqube-cloud.yml` se ejecutará automáticamente

### Opción 2: SonarQube Server (Self-hosted)

1. **Instalar SonarQube**:
   ```bash
   docker run -d --name sonarqube -p 9000:9000 sonarqube:latest
   ```
2. **Acceder**: http://localhost:9000 (admin/admin)
3. **Crear proyecto**: Projects → Create → Manual
4. **Generar token**: My Account → Security → Generate Token
5. **Configurar GitHub Secrets**:
   - `SONAR_TOKEN`: [Tu token]
   - `SONAR_HOST_URL`: [https://tu-sonarqube-server.com]
6. **Usar workflow**: `.github/workflows/sonarqube.yml`

---

## Ejecución Local

```bash
# Instalar SonarScanner (solo una vez)
# Windows: Descargar desde https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/
# Linux/Mac: 
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-latest-linux.zip

# Ejecutar análisis
npm run sonar          # Para SonarCloud
npm run sonar:local    # Para SonarQube local
```

---

## Archivos Importantes

- `sonar-project.properties` - Configuración del proyecto
- `.github/workflows/sonarqube-cloud.yml` - Para SonarCloud
- `.github/workflows/sonarqube.yml` - Para SonarQube Server

---

## Ver Documentación Completa

Lee `README_SONARQUBE.md` para instrucciones detalladas.

