# Script para ejecutar analisis de SonarQube sin instalar SonarScanner permanentemente
# Descarga SonarScanner temporalmente y ejecuta el analisis

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ANALISIS DE SONARQUBE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sonarScannerVersion = "5.0.1.3006"
$downloadUrl = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonarScannerVersion}-windows.zip"
$tempDir = "$env:TEMP\sonar-scanner-temp"
$zipFile = "$env:TEMP\sonar-scanner-temp.zip"
$scannerDir = "$tempDir\sonar-scanner-${sonarScannerVersion}-windows"

# Limpiar descargas anteriores
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path $zipFile) {
    Remove-Item -Path $zipFile -Force -ErrorAction SilentlyContinue
}

Write-Host "Descargando SonarScanner..." -ForegroundColor Yellow
Write-Host "   Esto puede tardar unos minutos..." -ForegroundColor Gray

try {
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing
    Write-Host "Descarga completada" -ForegroundColor Green
} catch {
    Write-Host "Error al descargar SonarScanner: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Alternativa: Ejecuta el analisis a traves de GitHub Actions:" -ForegroundColor Yellow
    Write-Host "   1. Haz commit y push de tus cambios" -ForegroundColor White
    Write-Host "   2. Crea un Pull Request" -ForegroundColor White
    Write-Host "   3. El workflow de SonarQube se ejecutara automaticamente" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "Extrayendo archivos..." -ForegroundColor Yellow

try {
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
    Write-Host "Extraccion completada" -ForegroundColor Green
} catch {
    Write-Host "Error al extraer: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Verificando configuracion..." -ForegroundColor Yellow

# Verificar que existe sonar-project.properties
if (-not (Test-Path "sonar-project.properties")) {
    Write-Host "No se encontro sonar-project.properties" -ForegroundColor Red
    Write-Host "   Por favor, crea el archivo de configuracion primero" -ForegroundColor Yellow
    exit 1
}

Write-Host "Configuracion encontrada" -ForegroundColor Green

Write-Host ""
Write-Host "IMPORTANTE: Para ejecutar el analisis necesitas:" -ForegroundColor Yellow
Write-Host "   1. SonarCloud configurado O SonarQube Server ejecutandose" -ForegroundColor White
Write-Host "   2. Token de autenticacion configurado" -ForegroundColor White
Write-Host ""
Write-Host "Opcion recomendada: Ejecutar analisis a traves de GitHub Actions" -ForegroundColor Cyan
Write-Host "   El workflow ya esta configurado y se ejecutara automaticamente" -ForegroundColor Gray
Write-Host ""

$ejecutar = Read-Host "Deseas continuar con el analisis local? (S/N)"

if ($ejecutar -ne "S" -and $ejecutar -ne "s") {
    Write-Host ""
    Write-Host "Para ejecutar el analisis a traves de GitHub Actions:" -ForegroundColor Cyan
    Write-Host "   1. git add ." -ForegroundColor White
    Write-Host "   2. git commit -m 'Analisis SonarQube'" -ForegroundColor White
    Write-Host "   3. git push origin main" -ForegroundColor White
    Write-Host "   4. Crea un Pull Request" -ForegroundColor White
    Write-Host "   5. Ve a Actions en GitHub para ver el analisis" -ForegroundColor White
    exit 0
}

Write-Host ""
Write-Host "Ejecutando analisis de SonarQube..." -ForegroundColor Yellow
Write-Host ""

$scannerBat = "$scannerDir\bin\sonar-scanner.bat"

if (-not (Test-Path $scannerBat)) {
    Write-Host "No se encontro sonar-scanner.bat" -ForegroundColor Red
    exit 1
}

# Ejecutar analisis
try {
    & $scannerBat
    $exitCode = $LASTEXITCODE
    
    Write-Host ""
    if ($exitCode -eq 0) {
        Write-Host "Analisis completado exitosamente" -ForegroundColor Green
        Write-Host ""
        Write-Host "Revisa los resultados en:" -ForegroundColor Cyan
        Write-Host "   - SonarCloud: https://sonarcloud.io" -ForegroundColor White
        Write-Host "   - O SonarQube Server: http://localhost:9000" -ForegroundColor White
    } else {
        Write-Host "El analisis se completo con errores" -ForegroundColor Yellow
        Write-Host "   Revisa los mensajes anteriores para mas detalles" -ForegroundColor Gray
    }
} catch {
    Write-Host "Error al ejecutar el analisis: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Limpiando archivos temporales..." -ForegroundColor Yellow
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $zipFile -Force -ErrorAction SilentlyContinue
Write-Host "Limpieza completada" -ForegroundColor Green
