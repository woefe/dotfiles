$env:BAT_THEME = "ansi-dark"
$env:EDITOR = "nvim-qt"
$env:DOCKER_HOST = "ssh://root@192.168.154.129"
$env:PAGER = "more"
$env:SHELL = "powershell"

function CdUp { cd ..  }
function CdUpUp { cd ..\..  }
function Change-NewTemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    $path = Join-Path $parent $name
    New-Item -ItemType Directory -Path $path
    cd $path
}

Set-Alias -Name g -Value git
Set-Alias -Name :q -Value exit
Set-Alias -Name .. -Value CdUp
Set-Alias -Name ... -Value CdUpUp
Set-Alias -Name vim -Value nvim-qt
Set-Alias -Name cdt -Value Change-NewTemporaryDirectory

$PSReadLineOptions = @{
    EditMode = "Vi"
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    ViModeIndicator = "Cursor"
}
Set-PSReadLineOption @PSReadLineOptions

Set-PSReadLineKeyHandler -Chord Ctrl+s -Function ForwardSearchHistory
Set-PSReadLineKeyHandler -Chord Ctrl+r -Function ReverseSearchHistory
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward

Import-Module posh-git
