#############################
# Mario Leuzinger 06.02.2024
# IPV4 Checksum Offload
# Vers. 03
#############################

# --- Festlegen des Pfads fÃ¼r das Log-Protokoll
$logPath = "C:\Logs\IPv4_TSO_Deactivation.log"

# $ErrorActionPreference = 'Continue' # default
$ErrorActionPreference = 'Stop'

# --- Funktion zum Schreiben von Protokollmeldungen
function Write-Log {
    param(
        [string]$Message
    )
    Add-content -Path $logPath -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss"): $Message"
}

# --- Funktion zum Deaktivieren von IPv4 TSO
function Disable-IPv4ChecksumOffload {          
    if ( 
        (Get-NetAdapter | Where-Object { $_.InterfaceDescription -notlike "*Virtual*" } | Get-NetAdapterChecksumOffload).IpIPv4Enabled -eq "Disabled" ) {        
    }
    else {
        Get-NetAdapter | Where-Object { $_.InterfaceDescription -notlike "*Virtual*" } | Disable-NetAdapterChecksumOffload -IPIPv4            
    }        
}

# --- Definieren der Liste von Servern ---
$servers = "S003", "S001"

# Remoteausführung des Skripts auf jedem Server
foreach ($server in $servers) {
    Write-Log "Verbindung zu $server herstellen..."
    try {
        Invoke-Command -ComputerName $server -ScriptBlock ${function:Disable-IPv4ChecksumOffload}
        Write-Log "IPv4 TSO-Deaktivierung auf $server abgeschlossen."
    }
    catch {
        Write-Log "Fehler beim Deaktivieren von IPv4 TSO auf $server $_ "
    }
}

# --- Protokoll schlieÃŸen ---
Write-Log "IPv4 Checksum Offload Deaktivierung auf allen Servern abgeschlossen."
