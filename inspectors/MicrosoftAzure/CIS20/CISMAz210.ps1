# Date: 25-1-2023
# Version: 1.0
# Benchmark: CIS Azure v2.0.0
# Product Family: Microsoft Azure
# Purpose: Ensure the admin consent workflow is enabled
# Author: Leonardo van de Weteringh

# New Error Handler Will be Called here
Import-Module PoShLog

#Call the OutPath Variable here
$path = @($OutPath)


function Build-CISMAz210($findings)
{
	#Actual Inspector Object that will be returned. All object values are required to be filled in.
	$inspectorobject = New-Object PSObject -Property @{
		ID			     = "CISMAz210"
		FindingName	     = "CIS MAz 2.1 - Admin Consent Workflow not enabled!"
		ProductFamily    = "Microsoft Azure"
		CVS			     = "7.4"
		Description	     = "The admin consent workflow (Preview) gives admins a secure way to grant access to applications that require admin approval. When a user tries to access an application but is unable to provide consent, they can send a request for admin approval. The request is sent via email to admins who have been designated as reviewers. A reviewer acts on the request, and the user is notified of the action."
		Remediation	     = "Manually change it here: https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ConsentPoliciesMenuBlade/~/AdminConsentSettings or use the PowerShell Script below"
		PowerShellScript = '$params = @{ Values = @(@{ Name = "EnableAdminConsentRequests"; Value = "True" }) }; Update-MgDirectorySetting - DirectorySettingId $directorySettingId -BodyParameter $params'
		DefaultValue	 = "EnableAdminConsentRequests: False"
		ExpectedValue    = "EnableAdminConsentRequests: True"
		ReturnedValue    = "$findings"
		Impact		     = "Medium"
		RiskRating	     = "Medium"
		References	     = @(@{ 'Name' = 'Configure the admin consent workflow'; 'URL' = 'https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/configure-admin-consent-workflow' })
	}
	return $inspectorobject
}

function Audit-CISMAz210
{
	try
	{
		# Actual Script
		$Response = (Invoke-MgGraphRequest -Method GET "https://graph.microsoft.com/beta/settings")
		$ResponseId = ($Response.value | ? {$_.displayName -eq "Consent Policy Settings"}).id
		if ([string]::IsNullOrEmpty($ResponseId))
		{
			$Response = (Invoke-MgGraphRequest -Method GET "https://graph.microsoft.com/beta/settings/$ResponseId/values")
			$hash = $Response.value
			$BetaSettingsObject = [PSCustomObject]@{ } #Create Custom Object
			# Convert HashTable names to name and assign value to it so we can correctly make the CustomObject
			foreach ($h in $hash.GetEnumerator())
			{
				$BetaSettingsObject | Add-Member -MemberType NoteProperty -Name $h.Name -Value $h.Value
			}
			# Validation
			if ($BetaSettingsObject.EnableAdminConsentRequests -eq $false)
			{
				$finalobject = Build-CISMAz210("EnableAdminConsentRequests: $($BetaSettingsObject.EnableAdminConsentRequests)")
				return $finalobject
			}
			else
			{
				return $null
			}
		}
		return $null
	}
	catch
	{
		Write-WarningLog 'The Inspector: {inspector} was terminated!' -PropertyValues $_.InvocationInfo.ScriptName
		Write-ErrorLog 'An error occured on line {line} char {char} : {error}' -ErrorRecord $_ -PropertyValues $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.OffsetInLine, $_.InvocationInfo.Line
	}
}
return Audit-CISMAz210