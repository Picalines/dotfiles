$env:SHELL = (Get-Command "pwsh.exe").Source

function Command-Exists([string]$Command) {
	Get-Command $Command *> $null
	return $?
}

if (Command-Exists scoop -and Command-Exists git) { Set-Alias bash "$(scoop prefix git)/bin/bash.exe" }

if (Command-Exists mise) { mise activate pwsh | Out-String | Invoke-Expression }

if (Command-Exists starship) { starship init powershell | Out-String | Invoke-Expression }

if (Command-Exists zoxide) { zoxide init powershell | Out-String | Invoke-Expression }

if (Command-Exists yazi) {
	function f {
		$tmp = (New-TemporaryFile).FullName
		yazi.exe @args --cwd-file="$tmp"
		$cwd = Get-Content -Path $tmp -Encoding UTF8
		if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
			Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
		}
		Remove-Item -Path $tmp
	}
}

Set-Alias e nvim

Set-Alias g git
Set-Alias gg lazygit

Set-Alias m mise
function mr { mise run @args }
function me { mise exec @args }
