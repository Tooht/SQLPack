

[CmdletBinding()]
Param($Version)

Clear-Host 


if ($Version.Length -eq 0)
{
    $Version = (Get-ChildItem -Path $PSScriptRoot -Directory | Sort-Object -Property Name -Descending|Select-Object -first 1).name
}


Write-Verbose "Version: $Version"

$Folder = (Get-ChildItem -Path $PSScriptRoot -Directory -ErrorAction SilentlyContinue| Where-Object {$_.Name -eq $Version})
Write-Verbose "Folder: $Folder"


if($Folder.count -eq 0)
{
    Write-Verbose "Folder dont exists"

    $OldVersion=(Get-ChildItem -Path $PSScriptRoot -Directory | Sort-Object -Property Name -Descending|Select-Object -first 1)
    Write-Verbose "Old folder name: $OldVersion"

    $NewVersion=New-Item -Path $PSScriptRoot  -Name $Version -ItemType Directory
    Write-Verbose "Folder '$folder' created"

    Robocopy $OldVersion.FullName $NewVersion.FullName /E 
    Write-Verbose "All itens copied from $OldVersion into $NewVersion"
}


Write-Verbose ("Public folder "+($PSScriptRoot+"\"+$Version+"\Functions\Public" ))

$FunctionList = Get-ChildItem -Path ($PSScriptRoot+"\"+$Version+"\Functions\Public" ) -Recurse|Where-Object {$_.Name -like "*ps1"} |Select-Object @{n='Function';e={$_.Name -replace ".ps1",""}}
Write-Verbose "List of Functions: " 
Write-Verbose ($FunctionList|Format-Table|Out-String)


$PSDFile=($PSScriptRoot+"\"+$Version+"\SQLPack.psd1" )
Write-Verbose "PSD1 file: $PSDFile"

$ManifestParam =@{
                Path = $PSDFile
                Guid=(New-Guid) 
                Author = "fernando.almeida" 
                CompanyName = "AXA GO" 
                RootModule = "SQLPack.psm1" 
                Description = "DESC" 
                ModuleVersion = $Version 
                PowerShellVersion = "5.0" 
                FunctionsToExport = $FunctionList.Function
}



New-ModuleManifest @ManifestParam
Write-Verbose "PSD file created with success"

Remove-Item -Path "C:\Program Files\WindowsPowerShell\Modules\SQLPack\0.0.1" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -path "C:\Fernando\SQLPack\0.0.1" "C:\Program Files\WindowsPowerShell\Modules\SQLPack" -recurse -force
Write-Verbose "Files copied to PowerShell Modules folder with success"

    

Write-Host  (Get-Date) -ForegroundColor Green
Write-Host "SQLPack $Version created with success!" -ForegroundColor Green


