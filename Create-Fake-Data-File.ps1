# Purpose: Create fake data files with random binary content for data-file upload testing
# 
# Usage to create a 2GB file:
# .\Create-Fake-Data-File -Sizes 2048
# 
# Usage to create a 1GB and a 2GB file:
# .\Create-Fake-Data-File -Size 1024,2048
#
# Visit https://github.com/qlik-product-success/qcs-speed-test for updates and additional information.
#
param (
    [string] $Path = ".",
    [int] $ChunkSize = 256,
    [int[]] $Sizes = @(1024),
    [string] $FileExtension = "qvd"
)

$Path = Resolve-Path -Path $Path
Write-Host "Writing files to '$Path'. Press any non-modifier key to exit."

$rng = (new-object Random)
$out = new-object byte[] ($ChunkSize * 1MB)
$fileNumber = 0
$continue = $true

while ($continue) {
    $fileNumber++
    if ([console]::KeyAvailable -or $fileNumber -gt $Sizes.Count) {
        break
    } else {
        $actualChunkSize = $ChunkSize
        $size = $Sizes[$fileNumber - 1]
        if ($size -lt $actualChunkSize) {
            Write-Host "Warning: Requested file size of $size MB is smaller than requested chunk size of $ChunkSize MB. Temporarily reducing chunk size to $size MB."
            $actualChunkSize = $size
        }
        $chunks = [int]($size / $actualChunkSize)
        $lastChunkInMBs = $size % $actualChunkSize
        $fileNumberFormatted = ('{0:d4}' -f $fileNumber)
        $outputFile = "$Path\file$fileNumberFormatted.$FileExtension"
        Write-Host "Writing $size MB of random data to $outputFile..."
        $outputFileStream = New-Object -TypeName "System.IO.FileStream" -ArgumentList @(
            $outputFile, 
            [System.IO.FileMode]::Create,
            [System.IO.FileAccess]::Write,
            [System.IO.FileShare]::None,
            256KB,
            [System.IO.FileOptions]::None)
        for ($chunk = 0; $chunk -lt $chunks; $chunk++) {
            $rng.NextBytes($out)
            $outputFileStream.Write($out, 0, $out.Length)
        }
        if ($lastChunkInMBs -gt 0) {
            $lastChunk = new-object byte[] ($actualChunkSize * 1MB)
            $rng.NextBytes($lastChunk)
            $outputFileStream.Write($lastChunk, 0, $lastChunk.Length)
        }
        $outputFileStream.Flush()
        $outputFileStream.Dispose()
        $lastChunk = $null
    }
}
