<#
────────────────────────────────────────────────────────────
📄  Ping-Monitor.ps1 — Real-Time Ping Monitor
🔧  Version:    1.1.8 (Stable)
📅  Updated:    2025-09-05
👤  Author:     Mantas Adomavičius
🧠  Description:
     Logs and color-codes ping results for target hosts every 60s.
     Displays error counts in window title and auto-syncs console size.
     Uses adomm.psfl.ps1 as shared function library.
🗂️   Log Path:  $Folder\Ping-Check\Ping-Check-yyyy-MM-dd.txt
────────────────────────────────────────────────────────────
#>

$Global:Folder = ($PSCommandPath -replace '[^\\]+$', '') -replace '\\$', ''
$Folder = $Global:Folder   # local alias for consistency
$Global:PingMonitorVersion = "Ping Monitor v1.1.8"

. "$Folder\Ping-Monitor.cfg.ps1"  # Load configuration

for ($i=5; $i -gt 0; $i--) {
    Write-Host "$i seconds for resizing the window" -ForegroundColor 'White'
    Start-Sleep -Seconds 1
    Clear-ConsoleWindow
}

$err = 0
$i = 1
$for = 2

"$(Get-Date -Format 'HH:mm:ss') $Global:PingMonitorVersion — $pingRequests pings/host every ${timeout_s}s" |
    Out-File -FilePath "$Folder\Ping-Check\Ping-Check-$(Get-Date -Format 'yyyy-MM-dd').txt" -Append

$i++
$for = $i + 1
$web = New-Object System.Net.WebClient
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
try { $ip = ($web.DownloadString($link) -as [string]).Trim() } catch {}

while ($i -lt $for) {
	$cycleStart = [Environment]::TickCount
    $text = ""
    $flag = ""
    $dnr = 0
    $slow = 0

    if ($for % 30 -eq 0) {
        try { $ip = ($web.DownloadString($link) -as [string]).Trim() } catch {}
    }

	$pingStart = [Environment]::TickCount
    foreach ($domain in $domains) {
        $parts = $domain.Split(':')
        $name = $parts[0]
        $addr = $parts[1]

        $responseTime = $mf.ping($addr, $pingRequests)

        if (-not $responseTime -or $responseTime -le 0) {
            if ($parts.Count -gt 2) {
                $addr = $parts[2]
                $responseTime = $mf.ping($addr, $pingRequests)
            }
        }

        $text += " ${name}:"
        if (-not $responseTime -or $responseTime -le 0) {
            $text += "DNR"
            $dnr++
        } else {
            $text += "$responseTime"
            if ($responseTime -gt 120) { $slow++ }
        }
    }
	$pingEnd = [Environment]::TickCount
	$pingTime  = [Math]::Round((($pingEnd-$pingStart)),0)

    if ($slow -gt 0) { $flag = "!" }
    if ($dnr -gt 0) { $flag = "*"; $err++ }

    if ($err -gt 0) { $PingErrorCount = " (*$err)" } else { $PingErrorCount = "" }
    $ui.WindowTitle = "$Global:PingMonitorVersion$PingErrorCount"
	
    $text = "$flag$(Get-Date -Format 'HH:mm:ss')$text ~${pingTime}ms"

    "$text" | Out-File -FilePath "$Folder\Ping-Check\Ping-Check-$(Get-Date -Format 'yyyy-MM-dd').txt" -Append

    Repaint-ConsoleFromBottom
	
	$cycleEnd = [Environment]::TickCount
	$elapsed  = $cycleEnd - $cycleStart
	# target 60s cycle in ms
	$target = $timeout_s * 1000
	$remaining = $target - $elapsed
	if ($remaining -lt 1) { $remaining = 1 }
	Start-Sleep -Milliseconds $remaining

    $i++
    $for++
}
try { $web.Dispose() } catch {}

if ($Error) { Pause } else { Pause }
