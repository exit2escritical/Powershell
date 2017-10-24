Param(
[string] $SCRIPT_NAME,
[int] $SERVICE_THw,
[int] $SERVICE_THc
)

$OK_STATUS = 0
$WARNING_STATUS = 1
$ERROR_STATUS = 2
$UNKNOWN_STATUS = 3
$DEPENDENT_STATUS = 4

$NSC_TMPDIR = "C:\Program Files\NSClient++\tmp\"
$STATUSFILE_crit = $NSC_TMPDIR + ${SCRIPT_NAME} + "_crit"
$STATUSFILE_warn = $NSC_TMPDIR + ${SCRIPT_NAME} + "_warn"


$dateDeadline_crit = (Get-Date).AddDays($SERVICE_Thc)
$dateDeadline_warn = (Get-Date).AddDays($ISERVICE_Thw)
$ActualDate = (Get-Date)

If (test-path -Path $STATUSFILE_crit) {
    Clear-Content $STATUSFILE_crit
}Else {
        new-item -Path "$STATUSFILE_crit" -ItemType file
 }

If (test-path -Path $STATUSFILE_warn) {
    Clear-Content $STATUSFILE_warn
}Else {
        new-item -Path "$STATUSFILE_warn" -ItemType file
 }


Get-ChildItem -Path cert:\LocalMachine\My  | ForEach-Object {
    $name = $_.Subject
    $dateExpireDays = $_.NotAfter
    		If ($dateExpireDays -gt $ActualDate){
                        If ($dateExpireDays -lt $dateDeadline_crit){
                                $CRIT_MSG = "CRITICAL: [$name] expires [$dateExpireDays]"
                                Add-Content $STATUSFILE_crit "`$CRIT_MSG"
                        }ElseIf ($dateExpireDays -lt $dateDeadline_warn){
                                $WARN_MSG = "WARNING: [$name] expires [$dateExpireDays]"
                                Add-Content $STATUSFILE_warn "`$WARN_MSG"
                        }
             }
        }

If ((Get-Content $STATUSFILE_crit) -ne $Null) {
Get-Content $STATUSFILE_crit | foreach {Write-Output $_}
        Write-Host "$_"
        exit $ERROR_STATUS
}ElseIf ((Get-Content $STATUSFILE_warn) -ne $Null) {
Get-Content $STATUSFILE_warn | foreach {Write-Output $_}
        Write-Host "$_"
        exit $WARNING_STATUS
}Else {
        Write-Host "OK"
        exit $OK_STATUS
        }

