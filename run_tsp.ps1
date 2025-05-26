param (
    [Parameter(Position=0)]
    [string]$Option,
    
    [Parameter(Position=1)]
    [string]$Param
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$mainScript = Join-Path -Path $scriptPath -ChildPath "src\main.rb"

if ($Option -eq "-h" -or $Option -eq "--help") {
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

if ($Option) {
    $command += " $Option"
    if ($Param) {
        $command += " `"$Param`""
    }
}

Write-Host "Starting TSP Solver..."
Invoke-Expression $command
