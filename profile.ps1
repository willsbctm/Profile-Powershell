Import-Module posh-git

Function gig {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$list
    )
    $params = ($list | ForEach-Object { [uri]::EscapeDataString($_) }) -join ","
    Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | select -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
}

New-Item Alias:grep -Value findstr 

New-Item Alias:vs -Value 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe'

New-Item Alias:k -Value kubectl

New-Item Alias:d -Value docker

New-Item Alias:g -Value git

New-Item Alias:vim -Value 'C:\Program Files (x86)\Vim\vim81\gvim.exe'

New-Item Alias:which -Value where.exe

function abrirChrome(
    [string]$perfil
)
{
    & 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' --profile-directory=$perfil
}

function cw {
    abrirChrome 'Profile 2'
}

function cl {
    abrirChrome 'Profile 1'
}
