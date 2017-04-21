Param(
[string] $SCRIPT_NAME,
[string] $SERVICE_TH
)

$OK_STATUS = 0
$WARNING_STATUS = 1
$ERROR_STATUS = 2
$UNKNOWN_STATUS = 3
$DEPENDENT_STATUS = 4

$NSC_TMPDIR = "C:\Program Files\NSClient++\tmp\"
$STATUSFILE = $NSC_TMPDIR + ${SCRIPT_NAME}

$dateDeadline = (Get-Date).AddDays($SERVICE_TH)
$ActualDate = (Get-Date)

If (test-path -Path $STATUSFILE) {
    Clear-Content $STATUSFILE
}Else {
        new-item -Path "$STATUSFILE" -ItemType file
 }


Get-ChildItem -Path cert:\LocalMachine\My  | ForEach-Object {
    $name = $_.Subject
    $dateExpireDays = $_.NotAfter
    		If ($dateExpireDays -gt $ActualDate){
                        If ($dateExpireDays -lt $dateDeadline){
                                $CRIT_MSG = "CRITICAL: [$name] expires [$dateExpireDays]"
                                Add-Content $STATUSFILE "`n$CRIT_MSG"
                        }
             }
        }

If ((Get-Content $STATUSFILE) -ne $Null) {
Get-Content $STATUSFILE| foreach {Write-Output $_}
        Write-Host "$_"
        exit $ERROR_STATUS
}Else {
        Write-Host "OK"
        exit $OK_STATUS
        }

