# Script gets all discoveries with an specific interal.
# Patrick Seidl, s2 - seidl solutions

$table = @()

Foreach ($discovery in (get-scomdiscovery | foreach-object {$_.DataSource})) { 
    if ($discovery.Configuration -match "<IntervalSeconds>(?<content>.*)</IntervalSeconds>") {
        $intervalSeconds = [int]$matches['content']
        if ($intervalSeconds -le 3600) {
            Write-Host $intervalSeconds -ForegroundColor Red
        } elseif ($intervalSeconds -gt 3600 -and $intervalSeconds -le 43200) {
            Write-Host $intervalSeconds -ForegroundColor Yellow
        } elseif ($intervalSeconds -gt 43200) {
            Write-Host $intervalSeconds -ForegroundColor Green
        }
        Write-Host "Workflow:" $discovery.get_ParentElement().DisplayName
        Write-Host "MP:" ($discovery.GetManagementPack()).DisplayName

        $hash = @{
            ManagementPack = $discovery.GetManagementPack().DisplayName
            Interval = $intervalSeconds
            DiscoveryWorkflow = $discovery.get_ParentElement().DisplayName
        }
        $object = New-Object psobject -Property $hash
        $table += $object

        "-"*30
    }
}

$table | Out-GridView