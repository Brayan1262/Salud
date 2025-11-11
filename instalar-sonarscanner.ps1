# Script de instalación automática de SonarScanner para Windows
# Ejecuta este script como Administrador para instalar SonarScanner

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALACIÓN DE SONARSCANNER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  Este script requiere permisos de administrador" -ForegroundColor Yellow
    Write-Host "   Por favor, ejecuta PowerShell como Administrador" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   Clic derecho en PowerShell → 'Ejecutar como administrador'" -ForegroundColor Gray
    exit 1
}

# URL de descarga de SonarScanner
$sonarScannerVersion = "5.0.1.3006"
$downloadUrl = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonarScannerVersion}-windows.zip"
$installDir = "C:\sonar-scanner"
$zipFile = "$env:TEMP\sonar-scanner.zip"

Write-Host "📥 Descargando SonarScanner..." -ForegroundColor Yellow
Write-Host "   URL: $downloadUrl" -ForegroundColor Gray

try {
    # Descargar SonarScanner
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing
    Write-Host "✅ Descarga completada" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al descargar SonarScanner: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📦 Extrayendo archivos..." -ForegroundColor Yellow

# Eliminar instalación anterior si existe
if (Test-Path $installDir) {
    Write-Host "   Eliminando instalación anterior..." -ForegroundColor Gray
    Remove-Item -Path $installDir -Recurse -Force
}

# Extraer archivo ZIP
try {
    Expand-Archive -Path $zipFile -DestinationPath "C:\" -Force
    # Renombrar carpeta extraída
    $extractedFolder = "C:\sonar-scanner-${sonarScannerVersion}-windows"
    if (Test-Path $extractedFolder) {
        Rename-Item -Path $extractedFolder -NewName "sonar-scanner"
    }
    Write-Host "✅ Extracción completada" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al extraer: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "⚙️  Configurando variables de entorno..." -ForegroundColor Yellow

# Agregar al PATH
$binPath = "$installDir\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notlike "*$binPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$binPath", "Machine")
    Write-Host "✅ SonarScanner agregado al PATH del sistema" -ForegroundColor Green
} else {
    Write-Host "✅ SonarScanner ya está en el PATH" -ForegroundColor Green
}

# Configurar sonar-scanner.properties
$configFile = "$installDir\conf\sonar-scanner.properties"
if (Test-Path $configFile) {
    Write-Host ""
    Write-Host "📝 Configurando sonar-scanner.properties..." -ForegroundColor Yellow
    
    # Leer configuración actual
    $config = Get-Content $configFile -Raw
    
    # Configurar para SonarCloud por defecto
    if ($config -notlike "*sonar.host.url*") {
        Add-Content -Path $configFile -Value "`n# SonarCloud (por defecto)"
        Add-Content -Path $configFile -Value "sonar.host.url=https://sonarcloud.io"
        Write-Host "✅ Configuración de SonarCloud agregada" -ForegroundColor Green
    }
}

# Limpiar archivo temporal
Remove-Item -Path $zipFile -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ SonarScanner instalado en: $installDir" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Próximos pasos:" -ForegroundColor Yellow
Write-Host "   1. Cierra y vuelve a abrir PowerShell para actualizar el PATH" -ForegroundColor White
Write-Host "   2. Verifica la instalación: sonar-scanner --version" -ForegroundColor White
Write-Host "   3. Configura SonarCloud (lee README_SONARQUBE.md)" -ForegroundColor White
Write-Host ""
Write-Host "💡 Para usar SonarQube local en lugar de SonarCloud:" -ForegroundColor Cyan
Write-Host "   Edita: $configFile" -ForegroundColor Gray
Write-Host "   Cambia: sonar.host.url=http://localhost:9000" -ForegroundColor Gray
Write-Host ""

