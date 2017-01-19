﻿# Make all errors terminating errors
$ErrorActionPreference = 'Stop'

function Store-NewAccount
{
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ObjectGuid,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $EmployeeNumber,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $UserPrincipalName,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $SamAccountName,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $AccountPassword,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ResourceBundle,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GivenName,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Surname,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Department,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Office,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Title
    )
    $query = 'INSERT INTO dbo.LmNewAccount (created, objectGUID, employeeNumber, userPrincipalName, sAMAccountName, accountPassword, resourceBundle, givenName, sn, department, physicalDeliveryOfficeName, title) VALUES (GETDATE(), @guid, @empno, @upn, @sam, @pw, @bundle, @gn, @sn, @dept, @office, @title)'
    $cmd = Get-SqlCommand -Database MetaDirectory -Type Text -Text $query
    [void]$cmd.Parameters.AddWithValue('@guid', $ObjectGuid)
    [void]$cmd.Parameters.AddWithValue('@empno', $EmployeeNumber)
    [void]$cmd.Parameters.AddWithValue('@upn', $UserPrincipalName)
    [void]$cmd.Parameters.AddWithValue('@sam', $SamAccountName)
    [void]$cmd.Parameters.AddWithValue('@pw',  $AccountPassword)
    [void]$cmd.Parameters.AddWithValue('@bundle',  $ResourceBundle)
    [void]$cmd.Parameters.AddWithValue('@gn',  $GivenName)
    [void]$cmd.Parameters.AddWithValue('@sn',  $Surname)
    [void]$cmd.Parameters.AddWithValue('@dept',  $Department)
    [void]$cmd.Parameters.AddWithValue('@office',  $Office)
    [void]$cmd.Parameters.AddWithValue('@title',  $Title)
    [void]$cmd.ExecuteNonQuery()
}

function Store-UpdatedAccount
{
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ObjectGuid,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $EmployeeNumber,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $UserPrincipalName
    )
    $query = 'INSERT INTO dbo.LmAccount (inserted, objectGUID, employeeNumber, userPrincipalName) VALUES (GETDATE(), @guid, @empno, @upn)'
    $cmd = Get-SqlCommand -Database MetaDirectory -Type Text -Text $query
    [void]$cmd.Parameters.AddWithValue('@guid', $ObjectGuid)
    [void]$cmd.Parameters.AddWithValue('@empno', $EmployeeNumber)
    [void]$cmd.Parameters.AddWithValue('@upn', $UserPrincipalName)
    [void]$cmd.ExecuteNonQuery()
}

function Get-PendingTask
{
    param
    (
        [Parameter(Position = 0)]
        [ValidateSet('Expire','Unexpire','Delete','Create','Update','Move','All')]
        [string]
        $TaskName = 'All'
    )
    $query = 'SELECT * FROM dbo.ufLmGetPendingLifecycleTask(@task)'
    $cmd = Get-SqlCommand -Database MetaDirectory -Type Text -Text $query
    if ($TaskName -eq 'All')
    {
        [void]$cmd.Parameters.AddWithValue('@task', [DBNull]::Value)
    }
    else
    {
        [void]$cmd.Parameters.AddWithValue('@task', $TaskName)
    }
    $reader = $cmd.ExecuteReader()
    $table = New-Object 'System.Data.DataTable'
    if ($reader.HasRows)
    {
        $table.Load($reader)
    }
    Write-Output $table.Rows
}