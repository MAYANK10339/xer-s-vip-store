$ErrorActionPreference = "Continue"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host "       XER'S VIP STORE - WINDOWS .EXE COMPILER" -ForegroundColor Cyan
Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host ""

# Find csc.exe compiler
$cscCandidates = @(
    "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\csc.exe",
    "$env:SystemRoot\Microsoft.NET\Framework\v4.0.30319\csc.exe"
)

$csc = $null
foreach ($path in $cscCandidates) {
    if (Test-Path $path) {
        $csc = $path
        break
    }
}

function Build-Executable {
    param (
        [string]$SourcePath,
        [string]$OutputPath
    )

    Write-Host "[*] Building: $(Split-Path -Leaf $OutputPath)..." -ForegroundColor Yellow

    if ($csc) {
        & $csc /target:winexe /optimize+ /nologo "/out:$OutputPath" "$SourcePath" 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0 -and (Test-Path $OutputPath)) {
            Write-Host "    [+] Success: $(Split-Path -Leaf $OutputPath)" -ForegroundColor Green
            return $true
        }
    }

    # Fallback using .NET CodeDomProvider
    try {
        $sourceCode = Get-Content -Path $SourcePath -Raw
        $provider = New-Object Microsoft.CSharp.CSharpCodeProvider
        $params = New-Object System.CodeDom.Compiler.CompilerParameters
        $params.GenerateExecutable = $true
        $params.OutputAssembly = $OutputPath
        $params.CompilerOptions = "/target:winexe /optimize+"
        $params.ReferencedAssemblies.Add("System.dll") | Out-Null
        $results = $provider.CompileAssemblyFromSource($params, $sourceCode)

        if ($results.Errors.Count -eq 0 -and (Test-Path $OutputPath)) {
            Write-Host "    [+] Success (via CodeDom): $(Split-Path -Leaf $OutputPath)" -ForegroundColor Green
            return $true
        } else {
            foreach ($e in $results.Errors) {
                Write-Host "    [!] $e" -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "    [!] Error during compilation: $_" -ForegroundColor Red
    }

    return $false
}

$userCs = Join-Path $ScriptDir "src-win\UserApp.cs"
$adminCs = Join-Path $ScriptDir "src-win\AdminApp.cs"

$userExe = Join-Path $ScriptDir "XER-VIP-Store-User.exe"
$adminExe = Join-Path $ScriptDir "XER-VIP-Store-Admin.exe"

$resUser = Build-Executable -SourcePath $userCs -OutputPath $userExe
$resAdmin = Build-Executable -SourcePath $adminCs -OutputPath $adminExe

Write-Host ""
if ($resUser -and $resAdmin) {
    Write-Host "==============================================================" -ForegroundColor Green
    Write-Host "      BUILD SUCCESSFUL! BOTH .EXE FILES ARE READY!" -ForegroundColor Green
    Write-Host "==============================================================" -ForegroundColor Green
    Write-Host "  1. XER-VIP-Store-User.exe   - Customer VIP Store Desktop App" -ForegroundColor White
    Write-Host "  2. XER-VIP-Store-Admin.exe  - Admin Management Console App" -ForegroundColor White
    Write-Host ""
    Write-Host "  Connected to 24/7 Cloud: https://xers-vip-store.onrender.com" -ForegroundColor Cyan
} else {
    Write-Host "[!] If compilation encountered an error, please ensure .NET Framework is installed." -ForegroundColor Yellow
}
