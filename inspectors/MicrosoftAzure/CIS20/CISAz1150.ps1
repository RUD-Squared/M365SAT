# Date: 25-1-2023
# Version: 1.0
# Benchmark: CIS Azure v2.0.0
# Product Family: Microsoft Azure
# Purpose: Ensure That 'Guest users access restrictions' is set to 'Guest user access is restricted to properties and memberships of their own directory objects'
# Author: Leonardo van de Weteringh

# New Error Handler Will be Called here
Import-Module PoShLog

#Call the OutPath Variable here
$path = @($OutPath)


function Build-CISAz1150($findings)
{
	#Actual Inspector Object that will be returned. All object values are required to be filled in.
	$inspectorobject = New-Object PSObject -Property @{
		ID			     = "CISAz1150"
		FindingName	     = "CIS Az 1.15 - Guest users access restrictions is not set to 'Guest user access is restricted to properties and memberships of their own directory objects'"
		ProductFamily    = "Microsoft Azure"
		CVS			     = "10.0"
		Description	     = "Limiting guest access ensures that guest accounts do not have permission for certain directory tasks, such as enumerating users, groups or other directory resources, and cannot be assigned to administrative roles in your directory. Guest access has three levels of restriction. 1. Guest users have the same access as members (most inclusive)  2. Guest users have limited access to properties and memberships of directory objects 3. Guest user access is restricted to properties and memberships of their own directory objects The recommended option is the 3rd, most restrictive: 'Guest user access is restricted to their own directory object'"
		Remediation	     = "Use the PowerShell Script to mitigate this issue:"
		PowerShellScript = 'Update-MgPolicyAuthorizationPolicy -GuestUserRoleId "2af84b1e-32c8-42b7-82bc-daa82404023b"'
		DefaultValue	 = "10dae51f-b6af-4016-8d66-8c2a99b929b3"
		ExpectedValue    = "2af84b1e-32c8-42b7-82bc-daa82404023b"
		ReturnedValue    = "$findings"
		Impact		     = "Critical"
		RiskRating	     = "Critical"
		References	     = @(@{ 'Name' = 'Member and guest users'; 'URL' = 'https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/users-default-permissions#member-and-guest-users' },
			@{ 'Name' = 'PA-3: Manage lifecycle of identities and entitlements'; 'URL' = 'https://learn.microsoft.com/en-us/security/benchmark/azure/security-controls-v3-privileged-access#pa-3-manage-lifecycle-of-identities-and-entitlements' },
			@{ 'Name' = 'GS-2: Define and implement enterprise segmentation/separation of duties strategy'; 'URL' = 'https://learn.microsoft.com/en-us/security/benchmark/azure/security-controls-v3-governance-strategy#gs-2-define-and-implement-enterprise-segmentationseparation-of-duties-strategy' },
			@{ 'Name' = 'GS-6: Define and implement identity and privileged access strategy'; 'URL' = 'https://learn.microsoft.com/en-us/security/benchmark/azure/security-controls-v3-governance-strategy#gs-6-define-and-implement-identity-and-privileged-access-strategy' },
			@{ 'Name' = 'Restrict guest access permissions in Azure Active Directory'; 'URL' = 'https://learn.microsoft.com/en-us/azure/active-directory/enterprise-users/users-restrict-guest-permissions' })
	}
	return $inspectorobject
}

function Audit-CISAz1150
{
	try
	{
		# Actual Script
		$Policy = Get-MgPolicyAuthorizationPolicy
		
		# Validation
		if ($Policy.GuestUserRoleId -ne '2af84b1e-32c8-42b7-82bc-daa82404023b')
		{
			$finalobject = Build-CISAz1150($Policy.GuestUserRoleId)
			return $finalobject
		}
		return $null
	}
	catch
	{
		Write-WarningLog 'The Inspector: {inspector} was terminated!' -PropertyValues $_.InvocationInfo.ScriptName
		Write-ErrorLog 'An error occured on line {line} char {char} : {error}' -ErrorRecord $_ -PropertyValues $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.OffsetInLine, $_.InvocationInfo.Line
	}
}
return Audit-CISAz1150