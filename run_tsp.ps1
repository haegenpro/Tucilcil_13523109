param()

$currentPath = Get-Location
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$mainScript = Join-Path -Path $scriptPath -ChildPath "src\main.rb"

if ($args.Count -gt 0 -and ($args[0] -eq "-h" -or $args[0] -eq "--help")) {
    Write-Host "Traveling Salesman Problem Solver"
    Write-Host "Usage: .\run_tsp.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -f, --file FILENAME  Read input matrix from FILENAME"
    Write-Host "  -h, --help           Display this help message"
    Write-Host "  -t, --test           Run with a built-in test case"
    Write-Host "  -s, --sample         List available sample files"
    Write-Host ""
    Write-Host "If run without arguments, interactive mode will start."
    exit 0
}

$command = "ruby `"$mainScript`""

if ($args.Count -gt 0) {
    if ($args[0] -eq "-f" -or $args[0] -eq "--file") {
        if ($args.Count -gt 1) {
            $filePath = $args[1]
            if (-not [System.IO.Path]::IsPathRooted($filePath)) {
                $filePath = Join-Path -Path $currentPath -ChildPath $filePath
            }
            if (Test-Path $filePath) {
                $command += " -f `"$filePath`""
                if ($args.Count -gt 2) {
                    $remainingArgs = $args[2..($args.Count-1)] -join " "
                    $command += " $remainingArgs"
                }
            } else {
                Write-Host "Error: File not found: $filePath" -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "Error: Missing filename after -f option" -ForegroundColor Red
            exit 1
        }
    } else {
        $allArgs = $args -join " "
        $command += " $allArgs"
    }
}
Set-Location -Path $scriptPath

Write-Host "Starting TSP Solver..." -ForegroundColor Green
Write-Host "Command: $command" -ForegroundColor Cyan
Invoke-Expression $command
Set-Location -Path $currentPath