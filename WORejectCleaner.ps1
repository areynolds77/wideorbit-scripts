#region Variables
$CD_source_folder = "C:\IMPORT\CD"
$Cleanup = "C:\IMPORT\deletelog.txt"
#endregion
$start_timestamp = get-date
"WIDEORBIT REJECT CLEANUP SCRIPT BEGINNING AT $start_timestamp" | Tee-Object $Cleanup -append

#region Import Loop
while ($true) {
    $host.ui.RawUI.WindowTitle = "WideOrbit Reject File Cleanup Script"
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
                Write-Host "FILE LOCKED...WAITING"
                Start-Sleep -Seconds 1
            }
        }
        If ($fullname -match 'REJECTED$') {
            Remove-Item -path $fullname -force
            $deleted_timestamp = get-date
            "Removed Rejected file: $fullname at $deleted_timestamp" | Tee-Object $Cleanup -append
        }
    }
    Start-Sleep -Seconds 5 
}
#endregion
