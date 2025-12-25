Write-Host "==============================="
Write-Host " IT Operations Health Check"
Write-Host "==============================="
Write-Host ""

# Date & Time
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "Check run at: $timestamp"
Write-Host ""

# CPU Usage
$cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
Write-Host "CPU Load: $($cpu.Average)%"
Write-Host ""

# Memory Usage
$os = Get-CimInstance Win32_OperatingSystem
$totalMemory = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeMemory  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedMemory  = $totalMemory - $freeMemory

Write-Host "Memory Used: $usedMemory GB / $totalMemory GB"
Write-Host ""

# Disk Usage
Write-Host "Disk Usage:"
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    $used = [math]::Round(($_.Used / 1GB), 2)
    $free = [math]::Round(($_.Free / 1GB), 2)
    Write-Host "Drive $($_.Name): Used $used GB | Free $free GB"
}
Write-Host ""

# Top Processes
Write-Host "Top 5 Processes by CPU:"
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU | Format-Table -AutoSize
Write-Host ""

# Logging
$logFile = "health-log.txt"
"[$timestamp] Health check completed." | Out-File -Append $logFile

Write-Host "Health check complete. Results logged to health-log.txt"
