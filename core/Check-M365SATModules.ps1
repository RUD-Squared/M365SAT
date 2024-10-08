<# Checks if modules are installed #>
function Check-M365SATModules
{
	Write-Warning "[?] Checking Installed Modules..."
	# Define the set of modules installed and updated from the PowerShell Gallery that we want to maintain
	$Modules = @("MicrosoftTeams", "Az", "ExchangeOnlineManagement", "Microsoft.Online.Sharepoint.PowerShell", "Microsoft.Graph","Microsoft.Graph.Beta","PoShLog")
	#Check which Modules are Installed Already...
	$count = 0
	$installed = Get-InstalledModule
	foreach ($Module in $Modules)
	{
		if ($installed.Name -notcontains $Module)
		{
			Write-Host "`n$Module is not installed." -ForegroundColor Red
			do { $askyesno = (Read-Host "Do you want to install Module $Module (Y/N)").ToLower() } while ($askyesno -notin @('y','n'))
				if ($askyesno -eq 'y') {
					Write-Host "Selected YES, trying to install module $Module"
					Install-Module $Module -Scope CurrentUser -Force -Confirm:$false -AllowClobber
					$count++
					} else {
					Write-Host "Selected NO , $Module is not installed!"
					}
		}
		else
		{
			Write-Host "[+] $Module is installed." -ForegroundColor Green
			$count++
		}
		$installed = Get-InstalledModule -Name $Module
		if ($installed){
			Write-Host "$Module version $($installed.Version) is installed!"
		}
	}
	Write-Host "Succesfully Checked all Modules Existence...!"
}