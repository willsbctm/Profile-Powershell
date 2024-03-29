Import-Module posh-git

function gig {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$list
    )
    $params = ($list | ForEach-Object { [uri]::EscapeDataString($_) }) -join ","
    Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | select -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
}

function ln {
    param(
        [Parameter(Mandatory = $true)]
        [string]$target,
        [Parameter(Mandatory = $true)]
        [string]$link
    )
    
    New-Item -Path $target -ItemType SymbolicLink -Value $link 
}

function rm-bin {
    rm-directory "bin"
}

function rm-directory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$filter
    )
    
    Get-ChildItem -Path . -Filter $filter -Recurse -Directory | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

Function vpn-wsl {
    sudo 'Get-NetIPInterface -InterfaceAlias ''vEthernet (WSL)'' | Set-NetIPInterface -InterfaceMetric 1 ; Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match ''Cisco AnyConnect''} | Set-NetIPInterface -InterfaceMetric 6000; Start-Sleep -Seconds 1;'
}

function sudo {
    param(
        [Parameter(Mandatory = $true)]
        [string]$command
    )

    echo $command
    Start-Process -FilePath powershell -Wait -Verb RunAs -ArgumentList "-Command $command"

    if($LastExitCode -eq 0)
    {
        echo 'Success'
    }
    else
    {
        echo 'Error'
    }
}

function touch(
    [string]$file
)
{
    New-Item $file
}

function vpn-setup() {
	param (
        [string]$Server,
        [string]$Group,
        [string]$User,
        [string]$Password,
        [string]$SecondPassword
    )

    vpn-connect $Server $Group $User $Password $SecondPassword
    Start-Sleep -Seconds 3
    vpn-wsl
}

function vpn-connect() {

#IP address or host name of cisco vpn, Username, Group and Password as parameters
param (
  [string]$Server,
  [string]$Group,
  [string]$User,
  [string]$Password,
  [string]$SecondPassword
)

[string]$vpncliAbsolutePath = 'C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe'

Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop

Add-Type @'
  using System;
  using System.Runtime.InteropServices;
  public class Win {
     [DllImport("user32.dll")]
     [return: MarshalAs(UnmanagedType.Bool)]
     public static extern bool SetForegroundWindow(IntPtr hWnd);
  }
'@ -ErrorAction Stop

Function VPNConnect()
{
    Start-Process -WindowStyle Minimized -FilePath $vpncliAbsolutePath -ArgumentList "connect $Server"
    $counter = 0; $h = 0;
    while($counter++ -lt 1000 -and $h -eq 0)
    {
        sleep -m 15
        $h = (Get-Process vpncli).MainWindowHandle
    }
    #if it takes more than 15 seconds then display message
    if($h -eq 0){echo "Could not start VPN it takes too long."}
    else{[void] [Win]::SetForegroundWindow($h)}
}

echo "Connecting to VPN address '$Server' as user '$User'."
VPNConnect

[System.Windows.Forms.SendKeys]::SendWait("$Group{Enter}")
[System.Windows.Forms.SendKeys]::SendWait("$User{Enter}")
[System.Windows.Forms.SendKeys]::SendWait("$Password{Enter}")
[System.Windows.Forms.SendKeys]::SendWait("$SecondPassword{Enter}")

}

function vpn-disconnect() {
    [string]$vpncliAbsolutePath = 'C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpncli.exe'

    Get-Process | ForEach-Object {if($_.ProcessName.ToLower() -eq "vpncli")
    {$Id = $_.Id; Stop-Process $Id; echo "Process vpncli with id: $Id was stopped"}}

    echo "Trying to terminate remaining vpn connections"
    Start-Process -WindowStyle Minimized -FilePath $vpncliAbsolutePath -ArgumentList 'disconnect' -wait
}

function  gitpull {
    git pull --rebase
}

function  gitpush {
    git push
}

function  gitadd {
    git add .
}

function  gitcommit {
	param (
		[string]$Commit	
	)
    git add .
	git commit -m $Commit
}

function  gitstatus {
    git status
}

function edge {
   Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList '--profile-directory=Default'
}

New-Item Alias:grep -Value findstr 

New-Item Alias:vs -Value 'C:\Program Files\Microsoft Visual Studio\2022\Preview\Common7\IDE\devenv.exe'

New-Item Alias:k -Value kubectl

New-Item Alias:gpu -Value gitpull

New-Item Alias:gs -Value gitpush

New-Item Alias:ga -Value gitadd

New-Item Alias:gac -Value gitcommit

New-Item Alias:gst -Value gitstatus

New-Item Alias:d -Value docker

New-Item Alias:g -Value git

New-Item Alias:pxp -Value 'C:\git\ProcessExplorer\procexp.exe'

New-Item Alias:vim -Value 'C:\Program Files\Vim\vim90\gvim.exe'

New-Item Alias:which -Value where.exe