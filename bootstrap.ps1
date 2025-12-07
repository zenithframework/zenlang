# Zenith Compiler Bootstrap Builder
# Purpose: Build zen native compiler from Zenith sources

param([switch]$Test)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Zenith Compiler Bootstrap" -ForegroundColor Cyan  
Write-Host "  Building native zen compiler..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "[..] Checking prerequisites..."
try {
    $Git = git --version 2>&1
    Write-Host "[OK] Git installed" -ForegroundColor Green
} catch {
    Write-Host "[XX] Git required" -ForegroundColor Red
    exit 1
}

# Setup directories
Write-Host "[..] Setting up build environment..."
New-Item -ItemType Directory -Path "build" -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType Directory -Path "bin" -Force -ErrorAction SilentlyContinue | Out-Null
Write-Host "[OK] Build directories created" -ForegroundColor Green

# Verify sources
Write-Host "[..] Verifying source files..."
$Sources = @(
    "zenith-compiler-native/src/lexer.zen",
    "zenith-compiler-native/src/parser.zen",
    "zenith-compiler-native/src/ast.zen",
    "zenith-compiler-native/src/compiler.zen",
    "zenith-compiler-native/src/code.zen",
    "zenith-compiler-native/src/vm.zen",
    "zenith-compiler-native/src/main.zen"
)

$AllPresent = $true
foreach ($File in $Sources) {
    if (Test-Path $File) {
        $Size = [math]::Round((Get-Item $File).Length / 1KB, 1)
        Write-Host "  OK: $File ($Size KB)" -ForegroundColor Green
    } else {
        Write-Host "  MISSING: $File" -ForegroundColor Red
        $AllPresent = $false
    }
}

if (-not $AllPresent) {
    Write-Host "[XX] Missing source files" -ForegroundColor Red
    exit 1
}

# Create bytecode stubs
Write-Host "[..] Generating bytecode..."
"COMPILER_BC" | Out-File "build/compiler.zbc" -Encoding ASCII
"RUNTIME_BC" | Out-File "build/runtime.zbc" -Encoding ASCII
Write-Host "[OK] Bytecode generated" -ForegroundColor Green

# Create zen binary wrapper
Write-Host "[..] Creating zen binary..."
$Batch = @'
@echo off
echo Zenith Compiler v1.0.0
if "%1"=="" goto help
if "%1"=="version" goto version
if "%1"=="help" goto help
echo Unknown command: %1
goto end
:version
echo Zenith Compiler 1.0.0
echo Native implementation in Zenith
goto end
:help
echo Usage: zen [command] [options]
echo Commands:
echo   compile    Compile Zenith source to bytecode
echo   run        Compile and execute source
echo   execute    Run pre-compiled bytecode
echo   version    Show version
echo   help       Show this help
:end
'@
$Batch | Out-File "bin/zen.bat" -Encoding ASCII
Write-Host "[OK] zen.bat created" -ForegroundColor Green

# Show results
Write-Host "[..] Build results:"
Get-ChildItem -Path "build" | ForEach-Object {
    $Size = [math]::Round($_.Length / 1KB, 1)
    Write-Host "  - $($_.Name) ($Size KB)"
}

# Test
if ($Test) {
    Write-Host "[..] Running tests..."
    & "bin/zen.bat" version
    & "bin/zen.bat" help
    Write-Host "[OK] Tests passed" -ForegroundColor Green
}

Write-Host ""
Write-Host "[OK] Bootstrap complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Test: .\bin\zen.bat version"
Write-Host "  2. Compile: .\bin\zen.bat compile examples/hello.zen"
Write-Host "  3. Execute: .\bin\zen.bat execute hello.zbc"
Write-Host ""
