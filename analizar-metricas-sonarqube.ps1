# Script para analizar metricas avanzadas similares a SonarQube
# Analiza complejidad, duplicacion, y otros aspectos del codigo

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ANALISIS DE METRICAS SONARQUBE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sourceDirs = @("Salud/Controlador", "Salud/Vista", "Administrador")
$jsFiles = @()
$allFunctions = @()
$codeBlocks = @{}

# Analizar archivos JavaScript
foreach ($dir in $sourceDirs) {
    if (Test-Path $dir) {
        $files = Get-ChildItem -Path $dir -Recurse -Filter "*.js" -File
        foreach ($file in $files) {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            if ($content) {
                $jsFiles += @{
                    Path = $file.FullName
                    Name = $file.Name
                    Content = $content
                    Lines = (Get-Content $file.FullName).Count
                }
            }
        }
    }
}

Write-Host "Analizando complejidad y calidad del codigo..." -ForegroundColor Yellow
Write-Host ""

# Analizar complejidad ciclomatica aproximada
$totalComplexity = 0
$highComplexityFiles = @()
$functions = @()

foreach ($file in $jsFiles) {
    $content = $file.Content
    $complexity = 0
    
    # Contar estructuras de control (if, else, for, while, switch, catch, etc.)
    $ifCount = ([regex]::Matches($content, '\bif\s*\(')).Count
    $elseCount = ([regex]::Matches($content, '\belse\s*\{')).Count
    $forCount = ([regex]::Matches($content, '\bfor\s*\(')).Count
    $whileCount = ([regex]::Matches($content, '\bwhile\s*\(')).Count
    $switchCount = ([regex]::Matches($content, '\bswitch\s*\(')).Count
    $catchCount = ([regex]::Matches($content, '\bcatch\s*\(')).Count
    $ternaryCount = ([regex]::Matches($content, '\?.*:')).Count
    $andCount = ([regex]::Matches($content, '&&')).Count
    $orCount = ([regex]::Matches($content, '\|\|')).Count
    
    $complexity = 1 + $ifCount + $elseCount + $forCount + $whileCount + $switchCount + $catchCount + $ternaryCount + ($andCount / 2) + ($orCount / 2)
    $totalComplexity += $complexity
    
    if ($complexity -gt 20) {
        $highComplexityFiles += @{
            File = $file.Name
            Path = $file.Path.Replace((Get-Location).Path + '\', '')
            Complexity = [math]::Round($complexity, 2)
            Lines = $file.Lines
        }
    }
    
    # Detectar funciones
    $functionMatches = [regex]::Matches($content, '(function\s+\w+|const\s+\w+\s*=\s*(async\s+)?\(|const\s+\w+\s*=\s*(async\s+)?function|export\s+(default\s+)?(function|const))')
    $functions += $functionMatches.Count
}

$avgComplexity = if ($jsFiles.Count -gt 0) { [math]::Round($totalComplexity / $jsFiles.Count, 2) } else { 0 }

# Analizar duplicacion de codigo
Write-Host "Analizando duplicacion de codigo..." -ForegroundColor Yellow
$duplicatedLines = 0
$duplicatedBlocks = @()

# Buscar bloques de codigo similares (mas de 5 lineas)
foreach ($file1 in $jsFiles) {
    $lines1 = Get-Content $file1.Path
    foreach ($file2 in $jsFiles) {
        if ($file1.Path -ne $file2.Path) {
            $lines2 = Get-Content $file2.Path
            
            # Buscar secuencias similares
            for ($i = 0; $i -lt ($lines1.Count - 5); $i++) {
                $block1 = $lines1[$i..($i+4)] -join "`n"
                $block1Clean = $block1 -replace '\s+', ' ' -replace '//.*', ''
                
                for ($j = 0; $j -lt ($lines2.Count - 5); $j++) {
                    $block2 = $lines2[$j..($j+4)] -join "`n"
                    $block2Clean = $block2 -replace '\s+', ' ' -replace '//.*', ''
                    
                    if ($block1Clean -eq $block2Clean -and $block1Clean.Length -gt 50) {
                        $duplicatedLines += 5
                        $duplicatedBlocks += @{
                            File1 = $file1.Name
                            File2 = $file2.Name
                            Lines = 5
                        }
                        break
                    }
                }
            }
        }
    }
}

$duplicationPercentage = if ($jsFiles.Count -gt 0) {
    $totalLines = ($jsFiles | Measure-Object -Property Lines -Sum).Sum
    [math]::Round(($duplicatedLines / $totalLines) * 100, 2)
} else { 0 }

# Detectar posibles bugs y code smells
Write-Host "Detectando posibles bugs y code smells..." -ForegroundColor Yellow
$bugs = @()
$vulnerabilities = @()
$codeSmells = @()

foreach ($file in $jsFiles) {
    $content = $file.Content
    $lines = Get-Content $file.Path
    
    # Detectar posibles bugs
    if ($content -match 'console\.(log|error|warn)') {
        $bugs += @{
            Type = "Debug Code"
            Severity = "Minor"
            File = $file.Name
            Message = "Console.log encontrado (debe removerse en produccion)"
        }
    }
    
    if ($content -match 'eval\s*\(') {
        $vulnerabilities += @{
            Type = "Security"
            Severity = "Critical"
            File = $file.Name
            Message = "Uso de eval() detectado - riesgo de seguridad"
        }
    }
    
    if ($content -match 'innerHTML\s*=') {
        $vulnerabilities += @{
            Type = "Security"
            Severity = "Major"
            File = $file.Name
            Message = "Uso de innerHTML puede ser vulnerable a XSS"
        }
    }
    
    # Detectar code smells
    $longFunctions = [regex]::Matches($content, 'function\s+\w+[^}]{200,}')
    if ($longFunctions.Count -gt 0) {
        $codeSmells += @{
            Type = "Long Function"
            Severity = "Major"
            File = $file.Name
            Message = "Funciones muy largas detectadas (mas de 200 caracteres)"
        }
    }
    
    # Detectar variables no usadas (aproximado)
    if ($content -match 'const\s+(\w+)\s*=' -and $content -notmatch '\$\1') {
        $codeSmells += @{
            Type = "Unused Variable"
            Severity = "Minor"
            File = $file.Name
            Message = "Posibles variables no utilizadas"
        }
    }
    
    # Detectar funciones anidadas profundas
    $nestedDepth = ([regex]::Matches($content, '\{')).Count - ([regex]::Matches($content, '\}')).Count
    if ($nestedDepth -gt 5) {
        $codeSmells += @{
            Type = "Deep Nesting"
            Severity = "Major"
            File = $file.Name
            Message = "Anidamiento profundo detectado (dificulta la lectura)"
        }
    }
}

# Generar reporte
$report = @"
========================================
  REPORTE DE METRICAS SONARQUBE
  Proyecto: Salud
  Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
========================================

RESUMEN EJECUTIVO
-----------------
Estado General: $(if ($bugs.Count -eq 0 -and $vulnerabilities.Count -eq 0) { "BUENO" } elseif ($vulnerabilities.Count -gt 0) { "REQUIERE ATENCION" } else { "ACEPTABLE" })

COMPLEJIDAD
-----------
Complejidad Ciclomatica Total: $totalComplexity
Complejidad Promedio por Archivo: $avgComplexity
Total de Funciones Detectadas: $functions
Archivos con Alta Complejidad (>20): $($highComplexityFiles.Count)

$(if ($highComplexityFiles.Count -gt 0) {
    "Archivos con Mayor Complejidad:`n"
    foreach ($file in $highComplexityFiles | Sort-Object Complexity -Descending | Select-Object -First 5) {
        "  - $($file.File): $($file.Complexity) (Complejidad) - $($file.Lines) lineas"
    }
})

DUPLICACION DE CODIGO
---------------------
Lineas Duplicadas: $duplicatedLines
Porcentaje de Duplicacion: $duplicationPercentage%
Bloques Duplicados Detectados: $($duplicatedBlocks.Count / 2)

$(if ($duplicatedBlocks.Count -gt 0) {
    "Bloques Duplicados:`n"
    $uniqueBlocks = $duplicatedBlocks | Select-Object -First 5 -Unique
    foreach ($block in $uniqueBlocks) {
        "  - $($block.File1) <-> $($block.File2): $($block.Lines) lineas"
    }
})

BUGS DETECTADOS
---------------
Total de Bugs: $($bugs.Count)
$(if ($bugs.Count -gt 0) {
    "`nDetalles:`n"
    foreach ($bug in $bugs | Select-Object -First 10) {
        "  [$($bug.Severity)] $($bug.File): $($bug.Message)"
    }
} else {
    "  No se detectaron bugs criticos"
})

VULNERABILIDADES DE SEGURIDAD
------------------------------
Total de Vulnerabilidades: $($vulnerabilities.Count)
$(if ($vulnerabilities.Count -gt 0) {
    "`nDetalles:`n"
    foreach ($vuln in $vulnerabilities) {
        "  [$($vuln.Severity)] $($vuln.File): $($vuln.Message)"
    }
} else {
    "  No se detectaron vulnerabilidades criticas"
})

CODE SMELLS
-----------
Total de Code Smells: $($codeSmells.Count)
$(if ($codeSmells.Count -gt 0) {
    "`nDetalles:`n"
    $grouped = $codeSmells | Group-Object Type
    foreach ($group in $grouped) {
        "  $($group.Name): $($group.Count) ocurrencias"
    }
    "`nEjemplos:`n"
    foreach ($smell in $codeSmells | Select-Object -First 10) {
        "  [$($smell.Severity)] $($smell.File): $($smell.Message)"
    }
} else {
    "  No se detectaron code smells significativos"
})

CONCLUSIONES Y RECOMENDACIONES
-------------------------------
"@

# Agregar conclusiones
if ($vulnerabilities.Count -gt 0) {
    $report += "`n⚠️  CRITICO: Se detectaron vulnerabilidades de seguridad que deben corregirse inmediatamente.`n"
}

if ($highComplexityFiles.Count -gt 3) {
    $report += "`n⚠️  ATENCION: Varios archivos tienen alta complejidad ciclomatica. Considera refactorizar.`n"
}

if ($duplicationPercentage -gt 3) {
    $report += "`n⚠️  ATENCION: El porcentaje de duplicacion de codigo es alto ($duplicationPercentage%). Considera extraer codigo comun.`n"
}

if ($bugs.Count -gt 10) {
    $report += "`n⚠️  ATENCION: Se detectaron varios bugs menores. Revisa y corrige.`n"
}

if ($codeSmells.Count -gt 15) {
    $report += "`n⚠️  ATENCION: Se detectaron varios code smells. Mejora la calidad del codigo.`n"
}

if ($vulnerabilities.Count -eq 0 -and $bugs.Count -lt 5 -and $codeSmells.Count -lt 10 -and $duplicationPercentage -lt 3) {
    $report += "`n✅ El codigo tiene una calidad aceptable. Continua manteniendo buenas practicas.`n"
}

$report += @"

RECOMENDACIONES GENERALES
-------------------------
1. Configura SonarCloud para obtener metricas completas y actualizadas
2. Ejecuta analisis de SonarQube en cada Pull Request
3. Corrige las vulnerabilidades de seguridad prioritariamente
4. Refactoriza archivos con alta complejidad
5. Reduce la duplicacion de codigo extrayendo funciones comunes
6. Elimina console.log antes de produccion
7. Considera usar herramientas de linting (ESLint)

NOTA: Este es un analisis aproximado. Para metricas completas y precisas,
      configura SonarCloud siguiendo CONFIGURAR_SONARQUBE.md
"@

# Guardar reporte
$report | Out-File -FilePath "reporte-metricas-sonarqube.txt" -Encoding UTF8

# Mostrar resumen
Write-Host $report
Write-Host ""
Write-Host "Reporte completo guardado en: reporte-metricas-sonarqube.txt" -ForegroundColor Green

