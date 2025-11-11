# Script para verificar la configuración de ramas de Git
# Ejecuta este script en PowerShell para verificar tu configuración

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  VERIFICACIÓN DE RAMAS DE GIT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si git está instalado
try {
    $gitVersion = git --version
    Write-Host "✅ Git está instalado: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git no está instalado o no está en el PATH" -ForegroundColor Red
    Write-Host "   Por favor, instala Git desde: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Verificar la rama actual
Write-Host "--- RAMA ACTUAL ---" -ForegroundColor Yellow
try {
    $currentBranch = git branch --show-current
    Write-Host "Rama actual: $currentBranch" -ForegroundColor Cyan
    
    if ($currentBranch -eq "main") {
        Write-Host "✅ Estás en la rama 'main' (correcto)" -ForegroundColor Green
    } elseif ($currentBranch -eq "master") {
        Write-Host "⚠️  Estás en la rama 'master'" -ForegroundColor Yellow
        Write-Host "   El repositorio podría esperar 'main'. Considera cambiar." -ForegroundColor Yellow
    } else {
        Write-Host "⚠️  Estás en la rama '$currentBranch'" -ForegroundColor Yellow
        Write-Host "   El repositorio podría esperar 'main' o 'master'." -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ No se pudo determinar la rama actual" -ForegroundColor Red
    Write-Host "   ¿Estás en un repositorio Git?" -ForegroundColor Yellow
}

Write-Host ""

# Ver todas las ramas locales
Write-Host "--- RAMAS LOCALES ---" -ForegroundColor Yellow
try {
    $localBranches = git branch
    Write-Host $localBranches
} catch {
    Write-Host "❌ No se pudieron listar las ramas locales" -ForegroundColor Red
}

Write-Host ""

# Ver ramas remotas
Write-Host "--- RAMAS REMOTAS ---" -ForegroundColor Yellow
try {
    $remoteBranches = git branch -r
    if ($remoteBranches) {
        Write-Host $remoteBranches
    } else {
        Write-Host "⚠️  No hay ramas remotas configuradas" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ No se pudieron listar las ramas remotas" -ForegroundColor Red
}

Write-Host ""

# Verificar el estado del repositorio
Write-Host "--- ESTADO DEL REPOSITORIO ---" -ForegroundColor Yellow
try {
    $status = git status --short
    if ($status) {
        Write-Host "Archivos modificados/sin commit:" -ForegroundColor Yellow
        Write-Host $status
    } else {
        Write-Host "✅ No hay cambios pendientes" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ No se pudo verificar el estado" -ForegroundColor Red
}

Write-Host ""

# Verificar remotes
Write-Host "--- REMOTES CONFIGURADOS ---" -ForegroundColor Yellow
try {
    $remotes = git remote -v
    if ($remotes) {
        Write-Host $remotes
    } else {
        Write-Host "⚠️  No hay remotes configurados" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ No se pudieron listar los remotes" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RECOMENDACIONES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Si necesitas cambiar a la rama 'main':" -ForegroundColor Yellow
Write-Host "  git checkout -b main" -ForegroundColor White
Write-Host "  (o 'git checkout main' si ya existe)" -ForegroundColor Gray
Write-Host ""
Write-Host "Si necesitas renombrar tu rama actual a 'main':" -ForegroundColor Yellow
Write-Host "  git branch -m main" -ForegroundColor White
Write-Host ""
Write-Host "Para ver más ayuda, lee: VERIFICAR_RAMA.md" -ForegroundColor Cyan
Write-Host ""

