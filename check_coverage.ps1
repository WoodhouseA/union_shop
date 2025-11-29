# Path to your lcov.info file
$lcovFile = "coverage/lcov.info"

# Check if the file exists
if (-not (Test-Path $lcovFile)) {
    Write-Error "Coverage file not found at $lcovFile. Please run 'flutter test --coverage' first."
    exit 1
}

$totalLines = 0
$linesHit = 0

# Read the file content
$content = Get-Content -Path $lcovFile

# Iterate over lines to find LF (Lines Found) and LH (Lines Hit)
foreach ($line in $content) {
    if ($line.StartsWith("LF:")) {
        $totalLines += [int]$line.Substring(3)
    } elseif ($line.StartsWith("LH:")) {
        $linesHit += [int]$line.Substring(3)
    }
}

if ($totalLines -gt 0) {
    $coverage = ($linesHit / $totalLines) * 100
    Write-Host "----------------------------------------"
    Write-Host "Total Code Coverage: $($coverage.ToString('F2'))%" -ForegroundColor Green
    Write-Host "----------------------------------------"
} else {
    Write-Host "No lines found to calculate coverage." -ForegroundColor Yellow
}
