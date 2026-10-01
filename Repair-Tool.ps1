# ==========================================================
#  Windows Systemprüfung & Reparatur – DISM & SFC Menü
#  Autor: Yousof
#  Website: Neisitech.de
# ==========================================================

function Show-Header {
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "  _  _  ___ ___ ___ _____ ___ ___  _  _   ___  ___ " -ForegroundColor Green
    Write-Host " | \| || __|_ _| __|_   _| __/ C \| || | |   \| __|" -ForegroundColor Green
    Write-Host " | .` || _| | || _|  | | | _| \__ \ __ | | |) | _| " -ForegroundColor Green
    Write-Host " |_|\_||___|___|___| |_| |___|___/_||_| |___/|___|" -ForegroundColor Green
    Write-Host "                                                  " -ForegroundColor Green
    Write-Host "                   Neisitech.de                   " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
}

function Show-Info {
    param(
        [string]$Title,
        [string]$Description,
        [string]$Goal,
        [string]$Example
    )

    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host " $Title" -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "`nBeschreibung:" -ForegroundColor Green
    Write-Host $Description
    Write-Host "`nZiel:" -ForegroundColor Green
    Write-Host $Goal
    Write-Host "`nBeispielbefehl:" -ForegroundColor Green
    Write-Host $Example -ForegroundColor White
    Write-Host "`n==================================================`n" -ForegroundColor Cyan
}

function Run-Command {
    param([string]$Command)
    Write-Host "`nStarte Vorgang..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Invoke-Expression $Command
    Write-Host "`nVorgang abgeschlossen." -ForegroundColor Green
}

while ($true) {
    Clear-Host
    Show-Header
    
    Write-Host "`n   Windows Systemprüfung & Reparatur – Menü" -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "1) Systemstatus prüfen (DISM CheckHealth)"
    Write-Host "2) Komponentenstore tief prüfen (DISM ScanHealth)"
    Write-Host "3) Systemimage reparieren (DISM RestoreHealth)"
    Write-Host "4) Systemdateien reparieren (SFC /Scannow)"
    Write-Host "5) Windows Update zurücksetzen"
    Write-Host "6) Beenden"
    Write-Host "=================================================="

    $choice = Read-Host "Bitte Auswahl eingeben"

    switch ($choice) {

        "1" {
            Show-Info `
                -Title "Systemstatus prüfen" `
                -Description "Prüft schnell, ob Windows bekannte Beschädigungen im Komponentenstore hat." `
                -Goal "Schnelle Diagnose ohne tiefen Scan." `
                -Example "DISM /Online /Cleanup-Image /CheckHealth"

            Run-Command -Command "DISM /Online /Cleanup-Image /CheckHealth"
            Pause
        }

        "2" {
            Show-Info `
                -Title "Komponentenstore tief prüfen" `
                -Description "Führt eine gründliche Analyse des Windows-Komponentenstores durch." `
                -Goal "Neue Beschädigungen finden." `
                -Example "DISM /Online /Cleanup-Image /ScanHealth"

            Run-Command -Command "DISM /Online /Cleanup-Image /ScanHealth"
            Pause
        }

        "3" {
            Show-Info `
                -Title "Systemimage reparieren" `
                -Description "Repariert gefundene Beschädigungen im Windows-Komponentenstore." `
                -Goal "Systemintegrität wiederherstellen." `
                -Example "DISM /Online /Cleanup-Image /RestoreHealth"

            Run-Command -Command "DISM /Online /Cleanup-Image /RestoreHealth"
            Pause
        }

        "4" {
            Show-Info `
                -Title "Systemdateien reparieren" `
                -Description "Prüft und repariert beschädigte Windows-Systemdateien." `
                -Goal "Systemdateien wiederherstellen." `
                -Example "sfc /scannow"

            Run-Command -Command "sfc /scannow"
            Pause
        }

        "5" {
            Show-Info `
                -Title "Windows Update zurücksetzen" `
                -Description "Setzt Windows Update komplett zurück, löscht Cache und repariert Update-Komponenten." `
                -Goal "Update-Probleme beheben." `
                -Example "net stop wuauserv; net stop bits; ..."

            Run-Command -Command "net stop wuauserv"
            Run-Command -Command "net stop bits"
            Run-Command -Command "net stop cryptsvc"
            Run-Command -Command "ren C:\Windows\SoftwareDistribution SoftwareDistribution.old"
            Run-Command -Command "ren C:\Windows\System32\catroot2 catroot2.old"
            Run-Command -Command "net start wuauserv"
            Run-Command -Command "net start bits"
            Run-Command -Command "net start cryptsvc"
            Pause
        }

        "6" {
            Write-Host "Beende Skript..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            return
        }

        default {
            Write-Host "Ungültige Eingabe!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
