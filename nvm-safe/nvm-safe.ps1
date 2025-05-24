param (
    [string]$Command,
    [string]$Version
)

function Is-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Run-AsAdmin {
    $argsList = @()
    if ($Command) { $argsList += "-Command"; $argsList += $Command }
    if ($Version) { $argsList += "-Version"; $argsList += $Version }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $PSCommandPath) + $argsList
    $psi.Verb = "runas"

    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
        exit
    }
    catch {
        Write-Host "Failed to elevate privileges: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

if (-not (Is-Admin)) {
    Write-Host "Admin rights required - elevating..." -ForegroundColor Yellow
    Run-AsAdmin
}

if ($Command -and $Version) {
    Write-Host "Running: nvm $Command $Version" -ForegroundColor Cyan
    try {
        & nvm.exe $Command $Version
        if ($LASTEXITCODE -eq 0) {
            Write-Host "nvm $Command $Version completed successfully." -ForegroundColor Green
            if ($Command -eq "use") {
                & node -v
            }
        }
        else {
            Write-Host "nvm $Command failed with exit code $LASTEXITCODE" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "Passing through to nvm.exe $($args -join ' ')" -ForegroundColor Cyan
    & nvm.exe @args
}