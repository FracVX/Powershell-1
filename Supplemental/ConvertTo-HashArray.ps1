function ConvertTo-HashArray {
    <#
    .SYNOPSIS
    Convert an array of objects to a hash table based on a single property of the array.     
    .DESCRIPTION
    Convert an array of objects to a hash table based on a single property of the array.
    .PARAMETER InputObject
    An array of objects to convert to a hash table array.
    .PARAMETER PivotProperty
    The property to use as the key value in the resulting hash.
    .PARAMETER OverwriteDuplicates
    If the pivotproperty is found multiple times then overwrite the current hash value. Default is to skip duplicates.
    .EXAMPLE
    $test = @()
    $test += New-Object psobject -Property @{'Server' = 'Server1'; 'IP' = '1.1.1.1'}
    $test += New-Object psobject -Property @{'Server' = 'Server2'; 'IP' = '2.2.2.2'}
    $test += New-Object psobject -Property @{'Server' = 'Server2'; 'IP' = '3.3.3.3'}
    $test | ConvertTo-HashArray -PivotProperty Server
    
    Name                           Value                                                                                                                  
    ----                           -----                                                                                                                  
    Server1                        @{Server=Server1; IP=1.1.1.1}                                                                                          
    Server2                        @{Server=Server2; IP=2.2.2.2} 
    Description
    -----------
    Convert and output a hash array based on the server property (skipping duplicate values)
    
    .NOTES
    Author: Zachary Loeber
    Site: the-little-things.net
    #> 
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [PSObject[]]$InputObject,
        [Parameter(Mandatory=$true)]
        [string]$PivotProperty,
        [Parameter()]
        [switch]$OverwriteDuplicates
    )

    begin {
        $allObjects = @()
        $Results = @{}
    }
    process {
        $allObjects += $inputObject
    }
    end {
        foreach ($object in $allObjects)
        {
            if ($object[0].PSObject.Properties.Match($PivotProperty).Count) 
            {
                if ((($Results.ContainsKey($object.$PivotProperty)) -and ($OverwriteDuplicates)) -or (-not $Results.ContainsKey($object.$PivotProperty)))
                {
                    $Results[$object.$PivotProperty] = $object
                }
            }
        }
        Write-Output -InputObject $Results
    }
}