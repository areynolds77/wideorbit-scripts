#region Variables
$CD_source_folder = "C:\CDAudio"
$wideorbit_CD_import_folder = "C:\IMPORT\CD"
$Importer_log_file_path = "C:\IMPORT\importlog.txt"
#endregion
$start_timestamp = get-date
"CD IMPORTER SCRIPT BEGINNING AT $start_timestamp" | Tee-Object $Importer_log_file_path -append

#region Import Loop
while ($true) {
    $host.ui.RawUI.WindowTitle = "Content Depot Importer"
    $files = Get-ChildItem $CD_source_folder -File
    foreach ($file in $files) {
        $ContentDepotID = $file.BaseName
        $MediaAssetID = "$ContentDepotID"
        $fullname = $file.FullName
        #ensure that file is not locked
        While ($True) {
            Try {
                [IO.File]::OpenWrite($fullname).Close()
                Break
            }
            Catch { 
                "$fullname IS LOCKED...WAITING ONE SECOND" | Tee-Object $Importer_log_file_path -append
                Start-Sleep -Seconds 1
            }
        }

        $destfile = "$wideorbit_CD_import_folder\$MediaAssetID.wav"
        Move-Item -Path $fullname -Destination $destfile 
        start-sleep -Seconds 3
        Write-Host "Imported and tagged $MediaAssetID..."
        $imported_timestamp = get-date
        "Imported file: $fullname at $imported_timestamp" | Tee-Object $Importer_log_file_path -append

    }
    Start-Sleep -Seconds 5 
}
#endregion
