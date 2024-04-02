# Define minimum and maximum lengths for map names
$MinMapNameLength = 1
$MaxMapNameLength = 79
# Specify the cache path where s2ml files are located
$CachePath = 'C:\ProgramData\Blizzard Entertainment\Battle.net\Cache'

# Announce the start of the search
Write-Host "Searching for all s2ml files in the cache folder..."

# Search and process all s2ml files in the cache folder
Get-ChildItem -Path $CachePath -Include *.s2ml -Recurse | ForEach-Object {
    $filePath = $_.FullName
    # Attempt to read the file content
    try {
        $content = Get-Content -Path $filePath -Raw -Encoding UTF8
        # Attempt to extract the map name using regex
        if ($content -match '<e id="1">(.*?)</e>') {
            $mapName = $matches[1]
        } else {
            $mapName = "none"
        }
        # Validate the length of the map name
        if ($mapName.Length -lt $MinMapNameLength -or $mapName.Length -gt $MaxMapNameLength) {
            # Take actions to block exploit by clearing content and setting the file as read-only
            Clear-Content -Path $filePath
            Set-ItemProperty -Path $filePath -Name IsReadOnly -Value $true
            Write-Host "Blocked exploit s2ml file: $filePath"
        }
    } catch {
        Write-Warning "Failed to process file: $filePath"
    }
}
# Indicate that the script has completed its execution
Write-Host "Process completed."
