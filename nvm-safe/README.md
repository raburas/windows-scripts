# nvm-safe

A PowerShell wrapper for `nvm-windows` to handle admin privileges in `C:\Program Files`.

## Purpose

This script addresses issues with `nvm-windows` when installed in `C:\Program Files`, which requires admin privileges for commands like `use`, `install`, and `uninstall`. It prevents silent failures by auto-elevating PowerShell when needed. For a detailed explanation of the problem and solution, see my [Medium article](https://medium.com/@rustom.aburas/fixing-node-version-management-nvm-issues-on-windows-when-using-program-files).

## Installation

1. Copy `nvm-safe.ps1` to `%USERPROFILE%\Scripts\nvm-safe.ps1`.
2. Ensure `%USERPROFILE%\Scripts` is in your User PATH:

   * Press `Win + S`, search for "Environment Variables."
   * Select "Edit environment variables for your account."
   * Under User variables, select `Path`, click `Edit`, add `%USERPROFILE%\Scripts`, and click `OK`.
   * Restart your terminal.
3. Verify `nvm-windows` is installed and `nvm.exe` is in your system PATH.

## Usage

Run commands like:

```powershell
nvm-safe.ps1 use 20.19.1
nvm-safe.ps1 install 20.19.1
```

⚠️ This script only supports the following admin-required `nvm` commands:

* `use`
* `install`
* `uninstall`

Other commands (like `nvm ls`) should be run directly with `nvm`, or via the wrapper function in your PowerShell profile (see below).

## Optional: PowerShell Profile Integration

To use `nvm` commands seamlessly (e.g., `nvm use 20.19.1`), add this function to your PowerShell `$PROFILE` file (run `notepad $PROFILE` to open or create it):

```powershell
function nvm {
    param(
        [string]$subcmd,
        [string]$version,
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$remainingArgs
    )
    $adminCommands = @("use", "install", "uninstall")
    if ($subcmd -and $adminCommands -contains $subcmd) {
        & "$HOME\Scripts\nvm-safe.ps1" -Command $subcmd -Version $version
    }
    else {
        & nvm.exe $subcmd $version @remainingArgs
    }
}
```

Save the file, restart your terminal, and run commands like:

```powershell
nvm use 20.19.1
nvm ls
```

## Requirements

* `nvm-windows` installed (available from [nvm-windows releases](https://github.com/coreybutler/nvm-windows/releases)).
* PowerShell 5.1 or later.
* `nvm.exe` and `node.exe` in your system PATH.

## License

MIT
