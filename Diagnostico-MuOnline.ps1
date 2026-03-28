# ================================================
# GUI DIAGNÓSTICO MULTIPROPÓSITO - MU ONLINE
# Creado por: Tyferiusk
# Versión: 5.8
# ================================================

# Verificar permisos de administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script necesita ejecutarse como Administrador para obtener toda la información."
    Write-Host "Por favor, ejecuta PowerShell como Administrador y vuelve a intentarlo."
    Start-Sleep -Seconds 3
    exit
}

# Cargar ensamblados para la GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear formulario principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Diagnóstico MU Online - Tyferiusk"
$form.Size = New-Object System.Drawing.Size(900, 750)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.Topmost = $true
$form.MinimumSize = New-Object System.Drawing.Size(900, 750)

# Panel de configuración
$panelConfig = New-Object System.Windows.Forms.Panel
$panelConfig.Size = New-Object System.Drawing.Size(860, 100)
$panelConfig.Location = New-Object System.Drawing.Point(15, 15)
$panelConfig.BorderStyle = "FixedSingle"

# IP Detectada
$labelAutoIP = New-Object System.Windows.Forms.Label
$labelAutoIP.Text = "IP Detectada (main.exe):"
$labelAutoIP.Location = New-Object System.Drawing.Point(15, 15)
$labelAutoIP.Size = New-Object System.Drawing.Size(150, 25)
$labelAutoIP.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9)

$textBoxAutoIP = New-Object System.Windows.Forms.TextBox
$textBoxAutoIP.Text = "(No detectada - inicia el juego primero)"
$textBoxAutoIP.Location = New-Object System.Drawing.Point(170, 12)
$textBoxAutoIP.Size = New-Object System.Drawing.Size(150, 25)
$textBoxAutoIP.ReadOnly = $true
$textBoxAutoIP.BackColor = "LightYellow"
$textBoxAutoIP.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9)

# Puerto del juego
$labelPort = New-Object System.Windows.Forms.Label
$labelPort.Text = "Puerto del Juego:"
$labelPort.Location = New-Object System.Drawing.Point(15, 48)
$labelPort.Size = New-Object System.Drawing.Size(100, 25)
$labelPort.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9)

$textBoxPort = New-Object System.Windows.Forms.TextBox
$textBoxPort.Text = "55920"
$textBoxPort.Location = New-Object System.Drawing.Point(120, 45)
$textBoxPort.Size = New-Object System.Drawing.Size(80, 25)
$textBoxPort.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9)

# Ruta del juego
$labelPath = New-Object System.Windows.Forms.Label
$labelPath.Text = "Ruta del Juego:"
$labelPath.Location = New-Object System.Drawing.Point(15, 81)
$labelPath.Size = New-Object System.Drawing.Size(100, 25)
$labelPath.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9)

$textBoxPath = New-Object System.Windows.Forms.TextBox
$textBoxPath.Text = "C:\Program Files (x86)\MU Argentina 97D"
$textBoxPath.Location = New-Object System.Drawing.Point(120, 78)
$textBoxPath.Size = New-Object System.Drawing.Size(580, 25)
$textBoxPath.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9)

$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = "Examinar"
$buttonBrowse.Location = New-Object System.Drawing.Point(710, 76)
$buttonBrowse.Size = New-Object System.Drawing.Size(130, 30)
$buttonBrowse.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9)
$buttonBrowse.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Selecciona la carpeta donde está instalado el juego"
    $folderBrowser.SelectedPath = $textBoxPath.Text
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $textBoxPath.Text = $folderBrowser.SelectedPath
    }
})

$panelConfig.Controls.AddRange(@($labelAutoIP, $textBoxAutoIP, $labelPort, $textBoxPort, $labelPath, $textBoxPath, $buttonBrowse))

# Panel de progreso
$panelProgress = New-Object System.Windows.Forms.Panel
$panelProgress.Size = New-Object System.Drawing.Size(860, 80)
$panelProgress.Location = New-Object System.Drawing.Point(15, 125)
$panelProgress.BorderStyle = "FixedSingle"

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(15, 15)
$progressBar.Size = New-Object System.Drawing.Size(830, 30)
$progressBar.Minimum = 0
$progressBar.Maximum = 11
$progressBar.Value = 0

$labelStatus = New-Object System.Windows.Forms.Label
$labelStatus.Text = "Listo para comenzar diagnóstico"
$labelStatus.Location = New-Object System.Drawing.Point(15, 50)
$labelStatus.Size = New-Object System.Drawing.Size(830, 25)
$labelStatus.ForeColor = "Blue"
$labelStatus.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)

$panelProgress.Controls.AddRange(@($progressBar, $labelStatus))

# Panel de log
$panelLog = New-Object System.Windows.Forms.Panel
$panelLog.Size = New-Object System.Drawing.Size(860, 380)
$panelLog.Location = New-Object System.Drawing.Point(15, 215)
$panelLog.BorderStyle = "FixedSingle"

$textBoxLog = New-Object System.Windows.Forms.TextBox
$textBoxLog.Location = New-Object System.Drawing.Point(15, 15)
$textBoxLog.Size = New-Object System.Drawing.Size(830, 350)
$textBoxLog.Multiline = $true
$textBoxLog.ScrollBars = "Vertical"
$textBoxLog.ReadOnly = $true
$textBoxLog.BackColor = "Black"
$textBoxLog.ForeColor = "Lime"
$textBoxLog.Font = New-Object System.Drawing.Font("Consolas", 9)

$panelLog.Controls.Add($textBoxLog)

# Panel de botones
$panelButtons = New-Object System.Windows.Forms.Panel
$panelButtons.Size = New-Object System.Drawing.Size(860, 60)
$panelButtons.Location = New-Object System.Drawing.Point(15, 605)
$panelButtons.BorderStyle = "FixedSingle"

$buttonStart = New-Object System.Windows.Forms.Button
$buttonStart.Text = "Iniciar Diagnóstico"
$buttonStart.Location = New-Object System.Drawing.Point(15, 15)
$buttonStart.Size = New-Object System.Drawing.Size(180, 35)
$buttonStart.BackColor = "LightGreen"
$buttonStart.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Bold)
$buttonStart.Add_Click({
    $buttonStart.Enabled = $false
    $textBoxLog.Clear()
    Start-Diagnosis
})

$buttonSave = New-Object System.Windows.Forms.Button
$buttonSave.Text = "Guardar Reporte"
$buttonSave.Location = New-Object System.Drawing.Point(205, 15)
$buttonSave.Size = New-Object System.Drawing.Size(180, 35)
$buttonSave.BackColor = "LightBlue"
$buttonSave.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Bold)
$buttonSave.Enabled = $false
$buttonSave.Add_Click({ Save-Report })

$buttonClear = New-Object System.Windows.Forms.Button
$buttonClear.Text = "Limpiar Log"
$buttonClear.Location = New-Object System.Drawing.Point(395, 15)
$buttonClear.Size = New-Object System.Drawing.Size(130, 35)
$buttonClear.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10)
$buttonClear.Add_Click({ $textBoxLog.Clear() })

$buttonCopy = New-Object System.Windows.Forms.Button
$buttonCopy.Text = "Copiar Log"
$buttonCopy.Location = New-Object System.Drawing.Point(535, 15)
$buttonCopy.Size = New-Object System.Drawing.Size(130, 35)
$buttonCopy.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10)
$buttonCopy.Add_Click({
    [System.Windows.Forms.Clipboard]::SetText($textBoxLog.Text)
    [System.Windows.Forms.MessageBox]::Show("Log copiado al portapapeles.", "Copiado", "OK", "Information")
})

$buttonExit = New-Object System.Windows.Forms.Button
$buttonExit.Text = "Salir"
$buttonExit.Location = New-Object System.Drawing.Point(675, 15)
$buttonExit.Size = New-Object System.Drawing.Size(170, 35)
$buttonExit.BackColor = "LightCoral"
$buttonExit.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Bold)
$buttonExit.Add_Click({ $form.Close() })

$panelButtons.Controls.AddRange(@($buttonStart, $buttonSave, $buttonClear, $buttonCopy, $buttonExit))

$form.Controls.AddRange(@($panelConfig, $panelProgress, $panelLog, $panelButtons))

# Variables globales
$global:reportContent = ""
$global:outputFile = ""
$global:detectedServerIP = $null

# Funciones auxiliares
function Add-Log {
    param([string]$Text)
    $textBoxLog.AppendText($Text + "`r`n")
    $textBoxLog.SelectionStart = $textBoxLog.Text.Length
    $textBoxLog.ScrollToCaret()
    $form.Refresh()
}

function Update-Progress {
    param([int]$Value, [string]$Status)
    $progressBar.Value = $Value
    $labelStatus.Text = $Status
    $form.Refresh()
}

# Detección de IP desde main.exe
function Detect-ServerIPFromMain {
    Add-Log "   Buscando procesos main.exe en ejecución..."
    $mainProcesses = Get-Process -Name "main" -ErrorAction SilentlyContinue
    if (-not $mainProcesses) {
        Add-Log "   No hay procesos main.exe activos. Se recomienda iniciar el juego."
        return $null
    }
    
    Add-Log "   Se encontraron $($mainProcesses.Count) proceso(s) main.exe. Analizando conexiones..."
    foreach ($proc in $mainProcesses) {
        try {
            $connections = Get-NetTCPConnection -OwningProcess $proc.Id -ErrorAction SilentlyContinue | 
                           Where-Object { $_.State -eq "Established" }
            if ($connections) {
                $remote = $connections | Where-Object { $_.RemoteAddress -notlike "127.*" -and $_.RemoteAddress -notlike "192.168.*" -and $_.RemoteAddress -notlike "10.*" } | Select-Object -First 1
                if (-not $remote) {
                    $remote = $connections | Select-Object -First 1
                }
                if ($remote) {
                    $ip = $remote.RemoteAddress
                    $port = $remote.RemotePort
                    Add-Log "   → Proceso PID $($proc.Id) conectado a $ip`:$port"
                    $textBoxAutoIP.Text = $ip
                    $textBoxPort.Text = $port
                    return $ip
                }
            }
        } catch {
            Add-Log "   Error al obtener conexiones del PID $($proc.Id): $_"
        }
    }
    Add-Log "   No se pudo detectar IP de servidor desde main.exe."
    return $null
}

# Diagnóstico principal
function Start-Diagnosis {
    $global:reportContent = @"
╔═══════════════════════════════════════════════════════════════════╗
║         SCRIPT DE DIAGNÓSTICO MULTIPROPÓSITO - MU ONLINE         ║
║                    Creado por: Tyferiusk                         ║
║                     Versión 5.8 - Traceroute funcional           ║
╚═══════════════════════════════════════════════════════════════════╝

╔═══════════════════════════════════════════════════════════════════╗
║                     INFORMACIÓN GENERAL                          ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    $gameFolder = $textBoxPath.Text.Trim()
    
    # Detectar IP automáticamente
    $global:detectedServerIP = Detect-ServerIPFromMain
    if ($global:detectedServerIP) {
        $serverIP = $global:detectedServerIP
        Add-Log "IP detectada automáticamente: $serverIP"
    } else {
        $serverIP = $null
        Add-Log "⚠️ No se pudo detectar IP automáticamente. Asegúrate de tener el juego abierto y conectado."
        [System.Windows.Forms.MessageBox]::Show("No se encontró ningún proceso main.exe con conexión activa. Asegúrate de tener el juego abierto y conectado al servidor antes de ejecutar el diagnóstico.", "Advertencia", "OK", "Warning")
        $buttonStart.Enabled = $true
        return
    }
    
    $serverPort = $textBoxPort.Text.Trim()
    
    $global:reportContent += @"
IP del Servidor: $serverIP
Puerto a verificar: $serverPort
Fecha del Diagnóstico: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
Usuario: $env:USERNAME
Equipo: $env:COMPUTERNAME
Sistema Operativo: $(Get-WmiObject Win32_OperatingSystem).Caption
Arquitectura: $env:PROCESSOR_ARCHITECTURE
Memoria RAM: $([math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB, 2)) GB

"@
    
    Add-Log "=== INICIANDO DIAGNÓSTICO ==="
    Add-Log "IP a probar: $serverIP"
    Add-Log "Puerto: $serverPort"
    Add-Log "Carpeta del juego: $gameFolder"
    Add-Log ""
    
    # 1. Procesos
    Update-Progress -Value 1 -Status "Listando todos los procesos activos..."
    Add-Log "[1] LISTADO COMPLETO DE PROCESOS ACTIVOS"
    Check-AllProcesses
    
    # 2. Configuración de red
    Update-Progress -Value 2 -Status "Obteniendo configuración de red..."
    Add-Log "`n[2] CONFIGURACIÓN DE RED"
    Check-NetworkConfiguration
    
    # 3. Detección de VPN
    Update-Progress -Value 3 -Status "Detectando VPN activa..."
    Add-Log "`n[3] DETECCIÓN DE VPN ACTIVA"
    Check-VPNDetection
    
    # 4. Puertos alternativos
    Update-Progress -Value 4 -Status "Probando puertos alternativos..."
    Add-Log "`n[4] PRUEBA DE PUERTOS ALTERNATIVOS"
    Test-AlternativePorts -ServerIP $serverIP
    
    # 5. Conexión al servidor y traceroute
    Update-Progress -Value 5 -Status "Probando conexión al servidor..."
    Add-Log "`n[5] PROBANDO CONEXIÓN AL SERVIDOR"
    Check-Connection -ServerIP $serverIP -Port $serverPort
    
    # 6. Firewall
    Update-Progress -Value 6 -Status "Verificando firewall..."
    Add-Log "`n[6] VERIFICANDO FIREWALL"
    Check-Firewall
    
    # 7. Windows Defender
    Update-Progress -Value 7 -Status "Verificando Windows Defender..."
    Add-Log "`n[7] VERIFICANDO WINDOWS DEFENDER"
    Check-Defender -GameFolder $gameFolder
    
    # 8. Archivos del juego
    Update-Progress -Value 8 -Status "Verificando archivos del juego..."
    Add-Log "`n[8] VERIFICANDO ARCHIVOS DEL JUEGO"
    Check-GameFiles -GameFolder $gameFolder
    
    # 9. Logs de error
    Update-Progress -Value 9 -Status "Analizando logs de error..."
    Add-Log "`n[9] ANALIZANDO LOGS DE ERROR"
    Check-ErrorLogs
    
    # 10. Dependencias del sistema
    Update-Progress -Value 10 -Status "Verificando dependencias del sistema..."
    Add-Log "`n[10] VERIFICANDO DEPENDENCIAS DEL SISTEMA"
    Check-SystemDependencies -GameFolder $gameFolder
    
    # 11. Resumen
    Update-Progress -Value 11 -Status "Generando resumen con análisis de ISP..."
    Add-Log "`n[11] RESUMEN DEL DIAGNÓSTICO Y ANÁLISIS DE ISP"
    Generate-Summary -ServerIP $serverIP -ServerPort $serverPort
    
    Update-Progress -Value 11 -Status "Diagnóstico completado!"
    Add-Log "`n=== DIAGNÓSTICO COMPLETADO ==="
    
    $buttonSave.Enabled = $true
    $buttonStart.Enabled = $true
}

# ------------------------------------------------------------
# 1. LISTAR TODOS LOS PROCESOS
# ------------------------------------------------------------
function Check-AllProcesses {
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║                 1. TODOS LOS PROCESOS EN EJECUCIÓN               ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    $allProcesses = Get-Process | Sort-Object -Property Name | Select-Object Name, Id, CPU, WorkingSet64, Path
    $global:reportContent += "▶ Total de procesos activos: $($allProcesses.Count)`n`n"
    Add-Log "   Total de procesos activos: $($allProcesses.Count)"
    
    $global:reportContent += "╔════════════════════════════════════════════════════════════════════════════════╗`n"
    $global:reportContent += "║ PID      Nombre del Proceso                  CPU       Memoria (MB)   Ruta      ║`n"
    $global:reportContent += "╠════════════════════════════════════════════════════════════════════════════════╣`n"
    
    foreach ($proc in $allProcesses) {
        $procId = $proc.Id
        $name = $proc.Name
        $cpu = [math]::Round($proc.CPU, 2)
        $memMB = [math]::Round($proc.WorkingSet64 / 1MB, 2)
        $path = $proc.Path
        if ([string]::IsNullOrEmpty($path)) { $path = "N/A" }
        $global:reportContent += "$procId".PadRight(8) + " $name".PadRight(30) + " $cpu".PadRight(10) + " $memMB".PadRight(14) + " $path`n"
        Add-Log "   $procId - $name - CPU: $cpu - RAM: $memMB MB - Ruta: $path"
    }
    $global:reportContent += "╚════════════════════════════════════════════════════════════════════════════════╝`n"
}

# ------------------------------------------------------------
# 2. CONFIGURACIÓN DE RED
# ------------------------------------------------------------
function Check-NetworkConfiguration {
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║             2. CONFIGURACIÓN DE RED Y DNS                         ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    foreach ($adapter in $adapters) {
        $global:reportContent += "▶ Adaptador: $($adapter.Name) ($($adapter.InterfaceDescription))`n"
        Add-Log "   Adaptador: $($adapter.Name)"
        
        $ipConfig = Get-NetIPConfiguration -InterfaceIndex $adapter.InterfaceIndex | Select-Object IPv4Address, IPv4DefaultGateway, DNSServer
        if ($ipConfig.IPv4Address) {
            $ip = $ipConfig.IPv4Address.IPAddress
            $global:reportContent += "   • IP: $ip`n"
        }
        if ($ipConfig.IPv4DefaultGateway) {
            $gw = $ipConfig.IPv4DefaultGateway.NextHop
            $global:reportContent += "   • Gateway: $gw`n"
        }
        
        $dnsServers = $ipConfig.DNSServer | Select-Object -ExpandProperty ServerAddresses -ErrorAction SilentlyContinue
        if ($dnsServers) {
            $global:reportContent += "   • DNS Servidores: $($dnsServers -join ', ')`n"
            Add-Log "   DNS: $($dnsServers -join ', ')"
        } else {
            $global:reportContent += "   • DNS: No configurado (posiblemente automático)`n"
            Add-Log "   DNS: automático"
        }
    }
}

# ------------------------------------------------------------
# 3. DETECCIÓN DE VPN
# ------------------------------------------------------------
function Check-VPNDetection {
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║                   3. DETECCIÓN DE VPN ACTIVA                      ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    $vpnDetected = $false
    $vpnAdapters = @()
    
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    $vpnKeywords = @("VPN", "TAP", "TUN", "OpenVPN", "WireGuard", "Nord", "Express", "Surfshark", "Private", "Proton", "Windscribe", "CyberGhost")
    
    foreach ($adapter in $adapters) {
        foreach ($keyword in $vpnKeywords) {
            if ($adapter.Name -like "*$keyword*" -or $adapter.InterfaceDescription -like "*$keyword*") {
                $vpnDetected = $true
                $vpnAdapters += $adapter.Name
                break
            }
        }
    }
    
    if ($vpnDetected) {
        $global:reportContent += "✅ VPN DETECTADA EN EL SISTEMA`n"
        if ($vpnAdapters.Count -gt 0) {
            $global:reportContent += "   • Adaptadores VPN: $($vpnAdapters -join ', ')`n"
        }
        Add-Log "   VPN detectada en el sistema - Esto puede estar permitiendo la conexión"
    } else {
        $global:reportContent += "❌ NO SE DETECTÓ VPN ACTIVA`n"
        Add-Log "   No se detectó VPN activa en el sistema"
    }
    
    try {
        $publicIP = (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing -TimeoutSec 5).Content.Trim()
        $global:reportContent += "`n▶ IP Pública actual: $publicIP`n"
        Add-Log "   IP Pública: $publicIP"
    } catch {
        $global:reportContent += "`n▶ No se pudo obtener IP pública.`n"
    }
}

# ------------------------------------------------------------
# 4. PUERTOS ALTERNATIVOS
# ------------------------------------------------------------
function Test-AlternativePorts {
    param([string]$ServerIP)
    
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║             4. PRUEBA DE PUERTOS ALTERNATIVOS                     ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    $global:reportContent += "▶ Probando puertos comunes para verificar bloqueo por ISP:`n"
    Add-Log "   Probando puertos alternativos para detectar bloqueo selectivo"
    
    $commonPorts = @(80, 443, 21, 22, 25, 53, 110, 143, 993, 995, 8080, 8443)
    $openPorts = @()
    
    foreach ($port in $commonPorts) {
        try {
            $tcp = New-Object System.Net.Sockets.TcpClient
            $connect = $tcp.BeginConnect($ServerIP, $port, $null, $null)
            $wait = $connect.AsyncWaitHandle.WaitOne(2000)
            if ($wait -and $tcp.Connected) {
                $openPorts += $port
                $global:reportContent += "   • Puerto $port : ✅ ABIERTO`n"
                Add-Log "   Puerto $port : ABIERTO"
            }
            $tcp.Close()
        } catch {
            # Puerto cerrado o timeout
        }
    }
    
    if ($openPorts.Count -eq 0) {
        $global:reportContent += "   Ninguno de los puertos comunes responde. Posible bloqueo total del ISP.`n"
        Add-Log "   ⚠️ Ningún puerto común responde - posible bloqueo por ISP"
    } else {
        $global:reportContent += "`n▶ Puertos comunes que responden: $($openPorts -join ', ')`n"
        Add-Log "   Puertos comunes abiertos: $($openPorts -join ', ')"
        
        $gamePort = $textBoxPort.Text.Trim()
        if ($gamePort -in $openPorts) {
            $global:reportContent += "   ✅ ¡El puerto del juego ($gamePort) está accesible!`n"
        } else {
            $global:reportContent += "   ❌ El puerto del juego ($gamePort) NO responde, mientras que otros puertos sí. Esto SUGIERE BLOQUEO SELECTIVO POR EL ISP.`n"
            Add-Log "   ⚠️ IMPORTANTE: El puerto $gamePort está bloqueado pero otros puertos están abiertos - BLOQUEO SELECTIVO DEL ISP"
        }
    }
}

# ------------------------------------------------------------
# 5. CONEXIÓN Y TRACEROUTE
# ------------------------------------------------------------
function Check-Connection {
    param([string]$ServerIP, [string]$Port)
    
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║             5. VERIFICACIÓN DE CONEXIÓN CON EL SERVIDOR           ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    $global:reportContent += "▶ Probando conexión TCP a $ServerIP en puerto $Port`n"
    
    try {
        Add-Log "   Probando conexión a $ServerIP puerto $Port..."
        $tcp = New-Object System.Net.Sockets.TcpClient
        $connect = $tcp.BeginConnect($ServerIP, $Port, $null, $null)
        $wait = $connect.AsyncWaitHandle.WaitOne(5000)
        if ($wait -and $tcp.Connected) {
            $tcp.EndConnect($connect)
            $global:reportContent += "   Puerto $Port : ✅ ABIERTO`n"
            $global:reportContent += "      └─ Fuente: $((Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway}).IPv4Address.IPAddress)`n"
            Add-Log "   ✅ Puerto $Port : ABIERTO"
            $tcp.Close()
        } else {
            $global:reportContent += "   Puerto $Port : ❌ CERRADO/BLOQUEADO`n"
            Add-Log "   ❌ Puerto $Port : CERRADO/BLOQUEADO"
            $tcp.Close()
        }
    }
    catch {
        $global:reportContent += "   Puerto $Port : ❌ ERROR: $_`n"
        Add-Log "   ❌ Puerto $Port : ERROR - $_"
    }
    
    $activeConnections = Get-NetTCPConnection -ErrorAction SilentlyContinue |
                         Where-Object { $_.RemoteAddress -eq $ServerIP -and $_.State -eq "Established" }
    
    if ($activeConnections) {
        $global:reportContent += "`n✅ CONEXIONES ACTIVAS DETECTADAS:`n"
        Add-Log "`n   ✅ Hay conexiones activas al servidor"
        foreach ($conn in $activeConnections) {
            $global:reportContent += "   • Puerto $($conn.RemotePort) - $($conn.State)`n"
        }
    }
    
    # Traceroute con tracert.exe (ruta completa)
    Add-Log "   Realizando traceroute hacia $ServerIP (puede tomar varios segundos)..."
    try {
        $tracertPath = "$env:windir\System32\tracert.exe"
        if (-not (Test-Path $tracertPath)) {
            throw "No se encontró tracert.exe en $tracertPath"
        }
        
        $tempFile = [System.IO.Path]::GetTempFileName()
        $process = Start-Process -FilePath $tracertPath -ArgumentList "-h 20", "-w 2000", $ServerIP -NoNewWindow -PassThru -RedirectStandardOutput $tempFile
        $timeout = 120
        $timer = [System.Diagnostics.Stopwatch]::StartNew()
        while (-not $process.HasExited -and $timer.Elapsed.TotalSeconds -lt $timeout) {
            Start-Sleep -Milliseconds 500
            $form.Refresh()
        }
        if (-not $process.HasExited) {
            $process.Kill()
            Add-Log "   Traceroute cancelado por timeout (excedió $timeout segundos)."
            $global:reportContent += "`n▶ Traceroute cancelado por timeout.`n"
        } else {
            $output = Get-Content $tempFile -ErrorAction SilentlyContinue
            if ($output) {
                $global:reportContent += "`n▶ Rastreo de ruta (tracert) hacia ${ServerIP}:`n"
                foreach ($line in $output) {
                    $global:reportContent += "   $line`n"
                }
                Add-Log "   Traceroute completado exitosamente."
            } else {
                Add-Log "   No se pudo obtener la salida del traceroute."
                $global:reportContent += "`n▶ No se pudo obtener la salida del traceroute.`n"
            }
        }
        Remove-Item $tempFile -ErrorAction SilentlyContinue
    }
    catch {
        Add-Log "   Error al ejecutar traceroute: $_"
        $global:reportContent += "`n▶ Error al ejecutar traceroute: $_`n"
    }
    
    $global:reportContent += "`n💡 Nota: Si el traceroute muestra muchos timeouts después de cierto salto, indica que el ISP o algún nodo intermedio está bloqueando el tráfico.`n"
}

# ------------------------------------------------------------
# 6. FIREWALL
# ------------------------------------------------------------
function Check-Firewall {
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║                   6. VERIFICACIÓN DE FIREWALL                     ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    try {
        $firewallProfiles = Get-NetFirewallProfile
        foreach ($profile in $firewallProfiles) {
            $status = if ($profile.Enabled) { "ACTIVO" } else { "INACTIVO" }
            $global:reportContent += "▶ Perfil $($profile.Name): $status`n"
        }
        Add-Log "   Firewall verificado"
    }
    catch {
        $global:reportContent += "▶ Error al verificar firewall: $_`n"
        Add-Log "   Error al verificar firewall"
    }
}

# ------------------------------------------------------------
# 7. WINDOWS DEFENDER
# ------------------------------------------------------------
function Check-Defender {
    param([string]$GameFolder)
    
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║                   7. VERIFICACIÓN DE WINDOWS DEFENDER             ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    try {
        $defenderStatus = Get-MpComputerStatus
        $global:reportContent += "▶ Protección en tiempo real: $($defenderStatus.RealTimeProtectionEnabled)`n"
        Add-Log "   Windows Defender activo: $($defenderStatus.RealTimeProtectionEnabled)"
        
        if ($defenderStatus.RealTimeProtectionEnabled) {
            $exclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath -ErrorAction SilentlyContinue
            $gameExcluded = $false
            
            if ($exclusions) {
                $global:reportContent += "`n▶ Exclusiones configuradas:`n"
                foreach ($excl in $exclusions) {
                    $global:reportContent += "   • $excl`n"
                    if ($GameFolder -like "$excl*") {
                        $gameExcluded = $true
                    }
                }
            }
            
            $global:reportContent += "`n▶ Carpeta del juego excluida: $gameExcluded`n"
            Add-Log "   Carpeta del juego excluida: $gameExcluded"
        }
    }
    catch {
        $global:reportContent += "▶ Error al verificar Defender: $_`n"
    }
}

# ------------------------------------------------------------
# 8. ARCHIVOS DEL JUEGO
# ------------------------------------------------------------
function Check-GameFiles {
    param([string]$GameFolder)
    
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║                   8. ARCHIVOS DEL JUEGO                           ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    if (Test-Path $GameFolder) {
        $global:reportContent += "▶ Carpeta del juego: ✅ EXISTE`n"
        Add-Log "   Carpeta del juego: EXISTE"
        
        $mainExe = Get-ChildItem -Path $GameFolder -Filter "main.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($mainExe) {
            $fileInfo = Get-Item $mainExe.FullName
            $global:reportContent += "`n▶ main.exe:`n"
            $global:reportContent += "   • Ruta: $($fileInfo.FullName)`n"
            $global:reportContent += "   • Tamaño: $([math]::Round($fileInfo.Length/1KB, 2)) KB`n"
            $global:reportContent += "   • Fecha de modificación: $($fileInfo.LastWriteTime)`n"
            Add-Log "   main.exe encontrado - $([math]::Round($fileInfo.Length/1KB, 2)) KB"
            
            $zone = Get-Item $mainExe.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue
            if ($zone) {
                $global:reportContent += "   • ⚠️ BLOQUEADO: Desbloquear en Propiedades`n"
                Add-Log "   ⚠️ main.exe está bloqueado por Windows"
            }
            
            $compat = Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" -Name $mainExe.FullName -ErrorAction SilentlyContinue
            if ($compat) {
                $global:reportContent += "   • Compatibilidad: $($compat.'$mainExe.FullName')`n"
            }
        } else {
            $global:reportContent += "`n▶ main.exe: ❌ NO ENCONTRADO`n"
            Add-Log "   ❌ main.exe NO ENCONTRADO"
        }
        
        $xorFiles = Get-ChildItem -Path $GameFolder -Filter "*xor*" -Recurse -ErrorAction SilentlyContinue
        if ($xorFiles) {
            $global:reportContent += "`n▶ Archivos XOR encontrados: $($xorFiles.Count)`n"
            Add-Log "   Archivos XOR encontrados: $($xorFiles.Count)"
        }
    } else {
        $global:reportContent += "▶ Carpeta del juego: ❌ NO EXISTE`n"
        Add-Log "   ❌ Carpeta del juego NO EXISTE"
    }
}

# ------------------------------------------------------------
# 9. LOGS DE ERROR
# ------------------------------------------------------------
function Check-ErrorLogs {
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║                9. LOGS DE ERROR DE main.exe                       ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    try {
        $events = Get-WinEvent -FilterHashtable @{LogName='Application'; Level=2; StartTime=(Get-Date).AddDays(-7)} -ErrorAction SilentlyContinue |
                  Where-Object { $_.Message -like "*main.exe*" -or $_.Message -like "*xor*" }
        
        if ($events) {
            $global:reportContent += "▶ Se encontraron $($events.Count) errores relacionados en los últimos 7 días:`n"
            Add-Log "   Se encontraron $($events.Count) errores en logs"
            foreach ($event in $events | Select-Object -First 10) {
                $time = $event.TimeCreated.ToString("dd/MM/yyyy HH:mm:ss")
                $global:reportContent += "   [$time] EventID $($event.Id): $($event.Message)`n"
            }
        } else {
            $global:reportContent += "▶ No hay errores recientes de main.exe en el visor de eventos.`n"
            Add-Log "   No hay errores recientes en logs"
        }
    }
    catch {
        $global:reportContent += "▶ Error al leer logs: $_`n"
    }
}

# ------------------------------------------------------------
# 10. DEPENDENCIAS DEL SISTEMA
# ------------------------------------------------------------
function Check-SystemDependencies {
    param([string]$GameFolder)
    
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║             10. DEPENDENCIAS DEL SISTEMA Y DLLs                   ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    $criticalDlls = @("d3d9.dll", "d3dx9_43.dll", "msvcr100.dll", "msvcrt.dll", "ws2_32.dll", "winmm.dll")
    
    $global:reportContent += "▶ Verificación de DLLs críticas:`n"
    foreach ($dll in $criticalDlls) {
        $found = $false
        $gameDll = Get-ChildItem -Path $GameFolder -Filter $dll -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($gameDll) {
            $global:reportContent += "   • ${dll}: ✅ presente en carpeta del juego`n"
            $found = $true
        }
        $sysDll = Get-ChildItem -Path "$env:windir\System32" -Filter $dll -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($sysDll) {
            $global:reportContent += "   • ${dll}: ✅ presente en System32`n"
            $found = $true
        }
        if (-not $found) {
            $global:reportContent += "   • ${dll}: ❌ NO ENCONTRADO (posible causa de crash)`n"
            Add-Log "   DLL crítica faltante: ${dll}"
        }
    }
    
    $vcRedists = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -like "*Visual C++*" } | Select-Object DisplayName, DisplayVersion
    if ($vcRedists) {
        $global:reportContent += "`n▶ Visual C++ Redistributables instalados:`n"
        foreach ($vc in $vcRedists | Select-Object -First 5) {
            $global:reportContent += "   • $($vc.DisplayName) - $($vc.DisplayVersion)`n"
        }
    }
}

# ------------------------------------------------------------
# 11. RESUMEN
# ------------------------------------------------------------
function Generate-Summary {
    param([string]$ServerIP, [string]$ServerPort)
    
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║                 11. RESUMEN FINAL Y ANÁLISIS DE ISP               ║
╚═══════════════════════════════════════════════════════════════════╝

"@
    
    $activeConnections = Get-NetTCPConnection -ErrorAction SilentlyContinue |
                         Where-Object { $_.RemoteAddress -eq $ServerIP -and $_.State -eq "Established" }
    
    $gamePortOpen = $false
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $connect = $tcp.BeginConnect($ServerIP, $ServerPort, $null, $null)
        $wait = $connect.AsyncWaitHandle.WaitOne(3000)
        $gamePortOpen = $wait -and $tcp.Connected
        $tcp.Close()
    } catch { $gamePortOpen = $false }
    
    $commonPortsOpen = @()
    foreach ($port in @(80, 443)) {
        try {
            $tcp = New-Object System.Net.Sockets.TcpClient
            $connect = $tcp.BeginConnect($ServerIP, $port, $null, $null)
            $wait = $connect.AsyncWaitHandle.WaitOne(2000)
            if ($wait -and $tcp.Connected) { $commonPortsOpen += $port }
            $tcp.Close()
        } catch {}
    }
    
    $global:reportContent += "╔═══════════════════════════════════════════════════════════════════╗`n"
    $global:reportContent += "║                    ANÁLISIS DE CONECTIVIDAD                      ║`n"
    $global:reportContent += "╚═══════════════════════════════════════════════════════════════════╝`n`n"
    
    if ($activeConnections) {
        $global:reportContent += "✅ ESTADO: El usuario TIENE conexión activa al servidor`n"
        Add-Log "   ✅ Conexión activa al servidor detectada"
    } else {
        $global:reportContent += "❌ ESTADO: NO HAY CONEXIÓN ACTIVA al servidor`n"
        Add-Log "   ❌ No hay conexión al servidor"
    }
    
    if ($gamePortOpen) {
        $global:reportContent += "✅ Puerto ${ServerPort}: ABIERTO`n"
    } else {
        $global:reportContent += "❌ Puerto ${ServerPort}: CERRADO/BLOQUEADO`n"
    }
    
    if ($commonPortsOpen.Count -gt 0) {
        $global:reportContent += "✅ Puertos comunes (80,443): $($commonPortsOpen -join ', ') están ABIERTOS`n"
    } else {
        $global:reportContent += "❌ Puertos comunes: NINGUNO responde - posible bloqueo total`n"
    }
    
    $global:reportContent += "`n╔═══════════════════════════════════════════════════════════════════╗`n"
    $global:reportContent += "║                    DIAGNÓSTICO DE CAUSA                          ║`n"
    $global:reportContent += "╚═══════════════════════════════════════════════════════════════════╝`n`n"
    
    if ($activeConnections -or $gamePortOpen) {
        $global:reportContent += "🔍 CAUSA PROBABLE: El problema NO es de conectividad de red.`n"
        $global:reportContent += "   El error puede deberse a:`n"
        $global:reportContent += "   • Problemas con el anti-hack XOR (archivos corruptos o faltantes)`n"
        $global:reportContent += "   • Windows Defender bloqueando main.exe`n"
        $global:reportContent += "   • Falta de dependencias (Visual C++, DirectX)`n"
        $global:reportContent += "   • main.exe bloqueado por Windows (propiedades → desbloquear)`n"
        Add-Log "   Diagnóstico: Problema de software, no de red"
    }
    elseif ((-not $gamePortOpen) -and ($commonPortsOpen.Count -gt 0)) {
        $global:reportContent += "🔍 CAUSA PROBABLE: BLOQUEO SELECTIVO POR EL ISP (PROVEEDOR DE INTERNET)`n`n"
        $global:reportContent += "   ✅ Los puertos comunes (HTTP/HTTPS) funcionan correctamente`n"
        $global:reportContent += "   ❌ El puerto del juego (${ServerPort}) está bloqueado`n"
        $global:reportContent += "   Esto indica que tu proveedor de internet está bloqueando específicamente el puerto que usa MU Online.`n`n"
        $global:reportContent += "   📌 SOLUCIÓN RECOMENDADA: USAR UNA VPN`n"
        $global:reportContent += "   • Una VPN enmascara tu tráfico y permite evadir estos bloqueos.`n"
        $global:reportContent += "   • Recomendaciones: Cloudflare WARP (gratis), ProtonVPN (gratis), o cualquier VPN de pago.`n"
        $global:reportContent += "   • También puedes contactar a tu ISP para solicitar que desbloqueen el puerto.`n"
        Add-Log "   Diagnóstico: BLOQUEO SELECTIVO DEL ISP - Recomendar VPN"
    }
    elseif ((-not $gamePortOpen) -and ($commonPortsOpen.Count -eq 0)) {
        $global:reportContent += "🔍 CAUSA PROBABLE: BLOQUEO TOTAL POR EL ISP O PROBLEMA DE CONEXIÓN GRAVE`n`n"
        $global:reportContent += "   ❌ Ningún puerto responde hacia el servidor.`n"
        $global:reportContent += "   Posibles causas:`n"
        $global:reportContent += "   • Tu ISP bloquea completamente el acceso a ese servidor (por IP).`n"
        $global:reportContent += "   • El servidor puede estar caído o tener problemas de conectividad.`n"
        $global:reportContent += "   • Tu router o firewall está bloqueando las conexiones salientes.`n`n"
        $global:reportContent += "   📌 SOLUCIÓN RECOMENDADA: USAR UNA VPN O CONTACTAR AL ISP`n"
        Add-Log "   Diagnóstico: Bloqueo total o servidor inaccesible"
    }
    
    $global:reportContent += @"

╔═══════════════════════════════════════════════════════════════════╗
║                    RECOMENDACIONES FINALES                        ║
╚═══════════════════════════════════════════════════════════════════╝

1. 🔄 Si el diagnóstico indica BLOQUEO POR ISP, la solución más efectiva es:
   • Descargar e instalar Cloudflare WARP (1.1.1.1) - GRATIS
   • O cualquier otra VPN de tu preferencia
   • Activar la VPN antes de abrir el juego

2. 🛡️ Si el problema es de software:
   • Agregar la carpeta del juego a exclusiones de Windows Defender
   • Desbloquear main.exe (clic derecho → Propiedades → Desbloquear)
   • Instalar Visual C++ Redistributables (2005, 2008, 2010, 2012, 2013, 2015-2022)
   • Ejecutar main.exe como Administrador y en modo compatibilidad Windows XP SP3

3. 🌐 Si el problema persiste después de usar VPN:
   • Compartir este reporte con el soporte técnico del servidor
   • Verificar que el servidor esté online (contactar a otros jugadores)

"@
}

# Guardar reporte
function Save-Report {
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "Archivo de texto (*.txt)|*.txt"
    $saveDialog.Title = "Guardar reporte de diagnóstico"
    $saveDialog.FileName = "DIAGNOSTICO_MU_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    
    if ($saveDialog.ShowDialog() -eq "OK") {
        $global:reportContent | Out-File -FilePath $saveDialog.FileName -Encoding UTF8
        [System.Windows.Forms.MessageBox]::Show("Reporte guardado en:`n$($saveDialog.FileName)", "Guardado exitoso", "OK", "Information")
    }
}

# Iniciar aplicación
[System.Windows.Forms.Application]::Run($form)