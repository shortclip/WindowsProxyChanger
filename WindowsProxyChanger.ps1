<#
Change the following

$ProxyServer = ""
$ProxyOverride = ""
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

[System.Windows.Forms.Application]::EnableVisualStyles()

$GetProxyStatus = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$ProxyServer = ""
$ProxyOverride = ""



if($GetProxyStatus.ProxyEnable -eq 0) {
    $ProxyStatusValue = 'Disabled'
} else {
    $ProxyStatusValue = 'Enabled'
}

function Startup {
    $Form.Close()
    $Form.Dispose()
    Write-Warning "Form Closed!!"
}
<#Close IE#>
$CheckIE = Get-Process | Where-Object ProcessName -CLike "ie*"
if ($CheckIE.Count -gt 1) {
    Write-Host "Running IE will be terminated"
    #taskkill.exe /F /IM "iexplore.exe"
}

<#
 #Disable or Enable Proxy Status here 
#>
function BtnProxyStatus {
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Type String -Value $ProxyServer
     Set-ItemProperty  -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyOverride -Type String -Value $ProxyOverride
     
        <#Check the current status#>
    if ($GetProxyStatus.ProxyEnable -eq 1) {

        clear
        <#If ProxyEnable from eq 1, set to disabled #>
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Type DWord -Value 0
        Write-Host "Status was changed to Disabled"

    } else {
        <#If ProxyEnable Equal to 0 #>
        clear
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Type DWord -Value 1
        Write-Host "Status was changed to Enabled"

    }
 }function UpdateProxyServer {
    $GetProxyStatus = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    $ProxyServer = "129.249.149.12:8080"
    

    if ($GetProxyStatus.ProxyEnable -eq 1) {
        <#If ProxyEnable from eq 1, set to disabled => 0 #>
        Write-Host "Status will be change to Disabled"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Type DWord -Value 0        
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Type String -Value $ProxyServer
        $ProxyServer
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Type DWord -Value 1
        ReloadForm
    } else {
        <#If ProxyEnable Equal to 0 #>
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Type String -Value $ProxyServer
        $ProxyServer
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Type DWord -Value 1
        Write-Host "Status was changed to Enabled"
        ReloadForm
    }
 }
$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = New-Object System.Drawing.Point(400,200)
$Form.text = "Proxy Status"
$Form.TopMost = $false
$Form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#8fc0f7")

$btnUpdateProxyServer = New-Object System.Windows.Forms.Button
$btnUpdateProxyServer.AutoSize = $true
$btnUpdateProxyServer.Text = "ProxyServer"
$btnUpdateProxyServer.Width = 150
$btnUpdateProxyServer.Height = 40
$btnUpdateProxyServer.Location = New-Object System.Drawing.Size(175,140)
$btnUpdateProxyServer.BackColor = '#CCCC99'
$btnUpdateProxyServer.Add_Click({
    UpdateProxyServer
})

$proxyLabel = New-Object System.Windows.Forms.label
$proxyLabel.Location = New-Object System.Drawing.Size(60,30)
$proxyLabel.Size = New-Object System.Drawing.Size(150,50)
$proxyLabel.BackColor = "Transparent"
$proxyLabel.ForeColor = "Black"
$proxyLabel.Text = "Proxy Current Status:"
$proxyLabel.AutoSize = $true
$proxyLabel.BorderStyle

$btnFormReload = New-Object System.Windows.Forms.Button
$btnFormReload.Text = "Reload"
$btnFormReload.Width = 150
$btnFormReload.Height = 40
$btnFormReload.Location = New-Object System.Drawing.Size(175,80)
$btnFormReload.BackColor = '#CCCC99'
$btnFormReload.Add_Click({ReloadForm})

$btnProxyStatus = New-Object System.Windows.Forms.Button
$btnProxyStatus.Text = $ProxyStatusValue
$btnProxyStatus.Width = 150
$btnProxyStatus.Height = 40
$btnProxyStatus.Location = New-Object System.Drawing.Size(175,20)
$btnProxyStatus.BackColor = '#CCCC99'
$btnProxyStatus.Add_Click({
BtnProxyStatus
Startup
})

$Form.controls.AddRange(@($btnProxyStatus,$proxyLabel, $btnFormReload, $btnUpdateProxyServer))

[void]$Form.ShowDialog()