# Script para generar reporte de metricas estaticas del proyecto
# Analiza el codigo sin necesidad de SonarQube Server

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  REPORTE DE METRICAS ESTATICAS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$reportFile = "reporte-metricas.txt"
$reportHtml = "reporte-metricas.html"

# Directorios a analizar
$sourceDirs = @("Salud/Controlador", "Salud/Vista", "Administrador")

Write-Host "Analizando codigo fuente..." -ForegroundColor Yellow
Write-Host ""

$totalFiles = 0
$totalLines = 0
$totalCodeLines = 0
$totalCommentLines = 0
$totalBlankLines = 0
$jsFiles = 0
$htmlFiles = 0
$cssFiles = 0
$pyFiles = 0
$fileDetails = @()

foreach ($dir in $sourceDirs) {
    if (Test-Path $dir) {
        $files = Get-ChildItem -Path $dir -Recurse -File | Where-Object {
            $_.Extension -in @('.js', '.html', '.css', '.py')
        }
        
        foreach ($file in $files) {
            $totalFiles++
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            $lines = Get-Content $file.FullName -ErrorAction SilentlyContinue
            
            if ($lines) {
                $fileLines = $lines.Count
                $totalLines += $fileLines
                
                $codeLines = 0
                $commentLines = 0
                $blankLines = 0
                
                foreach ($line in $lines) {
                    $trimmed = $line.Trim()
                    if ([string]::IsNullOrWhiteSpace($trimmed)) {
                        $blankLines++
                    } elseif ($trimmed.StartsWith('//') -or $trimmed.StartsWith('/*') -or $trimmed.StartsWith('*') -or $trimmed.StartsWith('#')) {
                        $commentLines++
                    } else {
                        $codeLines++
                    }
                }
                
                $totalCodeLines += $codeLines
                $totalCommentLines += $commentLines
                $totalBlankLines += $blankLines
                
                $fileDetails += [PSCustomObject]@{
                    Archivo = $file.FullName.Replace((Get-Location).Path + '\', '')
                    Lineas = $fileLines
                    Codigo = $codeLines
                    Comentarios = $commentLines
                    Vacias = $blankLines
                    Extension = $file.Extension
                }
                
                switch ($file.Extension) {
                    '.js' { $jsFiles++ }
                    '.html' { $htmlFiles++ }
                    '.css' { $cssFiles++ }
                    '.py' { $pyFiles++ }
                }
            }
        }
    }
}

# Calcular metricas adicionales
$avgLinesPerFile = if ($totalFiles -gt 0) { [math]::Round($totalLines / $totalFiles, 2) } else { 0 }
$commentRatio = if ($totalCodeLines -gt 0) { [math]::Round(($totalCommentLines / $totalCodeLines) * 100, 2) } else { 0 }

# Generar reporte de texto
$report = @"
========================================
  REPORTE DE METRICAS ESTATICAS
  Proyecto: Salud
  Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
========================================

RESUMEN GENERAL
---------------
Total de archivos analizados: $totalFiles
Total de lineas: $totalLines
  - Lineas de codigo: $totalCodeLines
  - Lineas de comentarios: $totalCommentLines
  - Lineas vacias: $totalBlankLines

DISTRIBUCION POR TIPO DE ARCHIVO
---------------------------------
Archivos JavaScript (.js): $jsFiles
Archivos HTML (.html): $htmlFiles
Archivos CSS (.css): $cssFiles
Archivos Python (.py): $pyFiles

METRICAS ADICIONALES
--------------------
Promedio de lineas por archivo: $avgLinesPerFile
Ratio de comentarios: $commentRatio%

ARCHIVOS ANALIZADOS
-------------------
"@

foreach ($file in $fileDetails | Sort-Object Lineas -Descending | Select-Object -First 20) {
    $report += "`n$($file.Archivo)"
    $report += "  - Total: $($file.Lineas) lineas"
    $report += "  - Codigo: $($file.Codigo) | Comentarios: $($file.Comentarios) | Vacias: $($file.Vacias)"
}

$report | Out-File -FilePath $reportFile -Encoding UTF8

# Generar reporte HTML
$htmlReport = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Metricas - Salud</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 3px solid #4CAF50; padding-bottom: 10px; }
        h2 { color: #555; margin-top: 30px; }
        .metric { background: #f9f9f9; padding: 15px; margin: 10px 0; border-left: 4px solid #4CAF50; border-radius: 4px; }
        .metric-value { font-size: 24px; font-weight: bold; color: #4CAF50; }
        .metric-label { color: #666; margin-top: 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #4CAF50; color: white; }
        tr:hover { background-color: #f5f5f5; }
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-box { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; text-align: center; }
        .stat-value { font-size: 32px; font-weight: bold; }
        .stat-label { font-size: 14px; opacity: 0.9; margin-top: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Reporte de Metricas Estaticas</h1>
        <p><strong>Proyecto:</strong> Salud</p>
        <p><strong>Fecha:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
        
        <div class="stats">
            <div class="stat-box">
                <div class="stat-value">$totalFiles</div>
                <div class="stat-label">Archivos Analizados</div>
            </div>
            <div class="stat-box">
                <div class="stat-value">$totalLines</div>
                <div class="stat-label">Total de Lineas</div>
            </div>
            <div class="stat-box">
                <div class="stat-value">$totalCodeLines</div>
                <div class="stat-label">Lineas de Codigo</div>
            </div>
            <div class="stat-box">
                <div class="stat-value">$avgLinesPerFile</div>
                <div class="stat-label">Promedio por Archivo</div>
            </div>
        </div>
        
        <h2>Resumen General</h2>
        <div class="metric">
            <div class="metric-value">$totalFiles</div>
            <div class="metric-label">Total de archivos analizados</div>
        </div>
        <div class="metric">
            <div class="metric-value">$totalLines</div>
            <div class="metric-label">Total de lineas</div>
        </div>
        <div class="metric">
            <div class="metric-value">$totalCodeLines</div>
            <div class="metric-label">Lineas de codigo</div>
        </div>
        <div class="metric">
            <div class="metric-value">$totalCommentLines</div>
            <div class="metric-label">Lineas de comentarios</div>
        </div>
        <div class="metric">
            <div class="metric-value">$totalBlankLines</div>
            <div class="metric-label">Lineas vacias</div>
        </div>
        
        <h2>Distribucion por Tipo de Archivo</h2>
        <table>
            <tr>
                <th>Tipo</th>
                <th>Cantidad</th>
            </tr>
            <tr><td>JavaScript (.js)</td><td>$jsFiles</td></tr>
            <tr><td>HTML (.html)</td><td>$htmlFiles</td></tr>
            <tr><td>CSS (.css)</td><td>$cssFiles</td></tr>
            <tr><td>Python (.py)</td><td>$pyFiles</td></tr>
        </table>
        
        <h2>Top 20 Archivos por Tamaño</h2>
        <table>
            <tr>
                <th>Archivo</th>
                <th>Total</th>
                <th>Codigo</th>
                <th>Comentarios</th>
                <th>Vacias</th>
            </tr>
"@

foreach ($file in $fileDetails | Sort-Object Lineas -Descending | Select-Object -First 20) {
    $htmlReport += "            <tr>`n"
    $htmlReport += "                <td>$($file.Archivo)</td>`n"
    $htmlReport += "                <td>$($file.Lineas)</td>`n"
    $htmlReport += "                <td>$($file.Codigo)</td>`n"
    $htmlReport += "                <td>$($file.Comentarios)</td>`n"
    $htmlReport += "                <td>$($file.Vacias)</td>`n"
    $htmlReport += "            </tr>`n"
}

$htmlReport += @"
        </table>
    </div>
</body>
</html>
"@

$htmlReport | Out-File -FilePath $reportHtml -Encoding UTF8

Write-Host "Reporte generado exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "Archivos generados:" -ForegroundColor Cyan
Write-Host "  - $reportFile (texto)" -ForegroundColor White
Write-Host "  - $reportHtml (HTML)" -ForegroundColor White
Write-Host ""
Write-Host "Abre $reportHtml en tu navegador para ver el reporte completo" -ForegroundColor Yellow

