$MaximumHistoryCount = 32767 # 32768 items is the max

# --- Modules --- #
Import-Module CompletionPredictor
Import-Module PSFzf

# allow scripts to run
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# PSReadline Predictors
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord "Ctrl+f" -Function ForwardWord

# Dynamic Help - https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/dynamic-help
# Set-PSReadLineKeyHandler -chord 'Ctrl+h' -Function ShowCommandHelp
# Set-PSReadLineKeyHandler -chord 'Ctrl+p' -Function ShowParameterHelp

# starship
Invoke-Expression (&starship init powershell)

# PSfzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'


# --- Path --- #
$env:Path += ";${Env:ProgramFiles}\Emacs\emacs-29.2\bin\"

# --- Aliases --- #
# Git
function GitCommit { git commit @args }
Remove-Alias gc -Force
New-Alias -Name gc -Value GitCommit

function GitAdd { git add @args }
New-Alias -Name ga -Value GitAdd

function GitCheckoutBranch { git checkout -b @args }
Remove-Alias gcb -Force -ErrorAction SilentlyContinue  # Get-Clipboard
New-Alias -Name gcb -Value GitCheckoutBranch

function GitPull { git pull @args }
Remove-Alias gl -Force # Get-Location
New-Alias -Name gl -Value GitPull

function GitDiff { git diff @args }
New-Alias -Name gd -Value GitDiff

function GitStatusShort { git status --short @args }
New-Alias -Name gss -Value GitStatusShort

function GitStatus { git status @args }
New-Alias -Name gst -Value GitStatus

function GitCheckout { git checkout @args }
New-Alias -Name gco -Value GitCheckout

function GitCommitMessage { git commit -m @args }
New-Alias -Name gcmsg -Value GitCommitMessage

function GitLogOneline { git log --oneline --decorate @args }
New-Alias -Name glo -Value GitLogOneline

function GitBranch { git branch @args }
New-Alias -Name gb -Value GitBranch

function GitDefaultBranch { git rev-parse --abbrev-ref origin/HEAD | Split-Path -Leaf }

function GitCheckoutMain { git checkout $(GitDefaultBranch) @args }
Remove-Alias gcm -Force # Get-Command
New-Alias -Name gcm -Value GitCheckoutMain

function GitRebase { git rebase @args }
New-Alias -Name grb -Value GitRebase

function GitPushOriginCurrentBranch { git push origin $(git branch --show-current) }
New-Alias -Name ggp -Value GitPushOriginCurrentBranch

function GitPushOriginCurrentBranchForce { git push origin $(git branch --show-current) --force }
New-Alias -Name ggf -Value GitPushOriginCurrentBranchForce

function GitRebaseOntoDefaultBranch { git rebase $(GitDefaultBranch) @args }
New-Alias -Name grbm -Value GitRebaseOntoDefaultBranch

# PlantUML
function Invoke-PlantUML { java -jar C:\Users\bradwest\AppData\Roaming\PlantUML\plantuml-1.2024.5.jar @args }
New-Alias -Name plantuml -Value Invoke-PlantUML

# Dotfiles
function Invoke-DotfilesGit { git --git-dir=$env:USERPROFILE/.dotfiles/ --work-tree=$env:USERPROFILE @args }
New-Alias -Name dot -Value Invoke-DotfilesGit

function New-DotfilesRepo {
    git init --bare $env:USERPROFILE/.dotfiles
    Invoke-DotfilesGit config --local status.showUntrackedFiles no
}

function Get-DotfilesRepo {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RepoUrl
    )

    git clone --bare $RepoUrl $env:USERPROFILE/.dotfiles
    
    Invoke-DotfilesGit config --local status.showUntrackedFiles no
}

# Conversions
function ConvertFrom-Base64String {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Base64String
    )
    
    try {
        $bytes = [System.Convert]::FromBase64String($Base64String)
        $decodedString = [System.Text.Encoding]::UTF8.GetString($bytes)
	[string]$finalString = $decodedString.ToString()  # Ensure it's treated as a plain string
        return $finalString
    } catch {
        Write-Error "Failed to decode Base64 string: $_"
    }
}

function ConvertTo-PrettyXML {
    param (
        [Parameter(Mandatory=$true)]
        [string]$XmlString
    )
    
    try {
        # Load the XML from the string
        $xmlDocument = New-Object System.Xml.XmlDocument
        $xmlDocument.LoadXml($XmlString.Trim())

        # Create an XmlWriterSettings object with indentation options
        $settings = New-Object System.Xml.XmlWriterSettings
        $settings.Indent = $true
        $settings.IndentChars = '    ' # Use four spaces for indentation
        $settings.NewLineOnAttributes = $false

        # Create a StringBuilder to output the XML
        $stringBuilder = New-Object System.Text.StringBuilder

        # Create an XmlWriter to write to the StringBuilder with the specified settings
        $writer = [System.Xml.XmlWriter]::Create($stringBuilder, $settings)

        # Write the XML content to the XmlWriter, thus applying the settings
        $xmlDocument.Save($writer)

        # Close the XmlWriter
        $writer.Close()

        # Output the pretty printed XML
        return $stringBuilder.ToString()
    } catch {
        Write-Error "Failed to pretty print XML: $_"
    }
}

function ConvertFrom-Base64Xml {
    param (
	[Parameter(Mandatory=$true)]
	[string]$Xml
    )

    $xml = Decode-Base64String $Xml
    return PrettyPrint-Xml -XmlString $xml.Trim()
}

function ConvertTo-Base64Cab {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Cab
    )

    # Convert the XML content to bytes
    $xmlBytes = [System.Text.Encoding]::UTF8.GetBytes($Cab)

    # Base64 encode the bytes
    $base64Encoded = [Convert]::ToBase64String($xmlBytes)

    # Output the Base64 encoded string
    return $base64Encoded
}

# Version Control
function New-PullRequest {
    param (
        [string]$organization = "msdata",
        [string]$project = "Database Systems"
    )
    
    $repository = git config --get remote.origin.url | Split-Path -LeafBase
    $branch = git rev-parse --abbrev-ref HEAD
    $encodedProject =  [System.Uri]::EscapeDataString($project)

    # Construct the PR creation URL
    $url = "https://$organization.visualstudio.com/$encodedProject/_git/$repository/pullrequestcreate?sourceRef=$branch"

    # Open the URL in the default web browser
    Start-Process $url
}
Set-Alias -Name npr -Value New-PullRequest
