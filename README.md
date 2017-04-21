# Powershell
Powershell scritps

# Check_console_certs.ps1
This script searches on path cert:\LocalMachine\My the certificates that are installed on a Windows server.

For each cert found, gets Name and ExpirationDate and compares the ExpirationDate upon a Threshold.

If that ExpirationDate is lower that the Threashold, it writes the Name and ExpirationDate to a StatusFile, so multiple certs can be compared in the same script.

I do it this way so if more than one certs are going to expire before Threshold, you can list them, otherwise, the script would exit whenever it'd find the first cert that expires.

After that, the script checks if the StatusFile with certs that meet condition is not null, that means, and the scripts shows in console the lines + exit2.

- Arguments
   * You use script_name as a helper to name the StatusFile
   * Threshold is the days before ExpirationDate in order to warn you there's a problem.


