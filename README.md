# windows-scripts

A collection of PowerShell scripts to streamline and enhance development workflows on Windows.

## Overview

This repository contains utility scripts designed to solve common issues for Windows developers. Each script is housed in its own subdirectory with a dedicated `README.md` for setup and usage instructions.

## Scripts

* [**nvm-safe**](nvm-safe/): A PowerShell wrapper for `nvm-windows` to handle admin privileges when using `C:\Program Files`, preventing silent failures for commands like `use`, `install`, and `uninstall`. → [View detailed setup & usage](nvm-safe/README.md)

## Getting Started

1. Clone or download this repository:

   ```bash
   git clone https://github.com/raburas/windows-scripts.git
   ```
2. Navigate to the desired script’s subdirectory (e.g., `nvm-safe`) and follow its `README.md` for setup instructions.
3. Ensure PowerShell 5.1 or later is installed (included in Windows 10+).

## Adding Scripts to Your PATH

Most scripts in this repository are designed to be placed in `%USERPROFILE%\Scripts` and added to your User PATH for easy access.

To add `%USERPROFILE%\Scripts` to your PATH:

1. Press `Win + S` and search for "Environment Variables."
2. Select "Edit environment variables for your account."
3. Under User variables, select `Path` and click `Edit`.
4. Click `New` and add: `%USERPROFILE%\Scripts`
5. Click `OK` and restart your terminal.

## nvm-safe: PowerShell Wrapper for nvm-windows

The `nvm-safe` script addresses issues with `nvm-windows` when installed in `C:\Program Files`, which requires admin privileges for commands like `use`, `install`, and `uninstall`. It:

* Checks for admin rights and auto-elevates via UAC if needed.
* Provides clear feedback on success or failure.
* Passes non-admin commands (e.g., `nvm ls`) directly to `nvm.exe`.

### Installation

1. Copy `nvm-safe/nvm-safe.ps1` to `%USERPROFILE%\Scripts\nvm-safe.ps1`.
2. Ensure `%USERPROFILE%\Scripts` is in your PATH (see above).
3. Verify `nvm-windows` is installed and `nvm.exe` is in your system PATH.

### Usage

Run commands like:

```powershell
nvm-safe.ps1 use 20.19.1
nvm-safe.ps1 install 20.19.1
nvm-safe.ps1 list
```

### Optional: PowerShell Profile Integration

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

### Requirements

* `nvm-windows` installed (available from [nvm-windows releases](https://github.com/coreybutler/nvm-windows/releases)).
* PowerShell 5.1 or later.
* `nvm.exe` and `node.exe` in your system PATH.

### Tested On

* Windows 10
* PowerShell 5.1+
* nvm-windows v1.1.12+

## Contributing

Feel free to submit issues or pull requests for improvements or new scripts. Please include a `README.md` in any new subdirectory with setup and usage details.

## License

MIT
