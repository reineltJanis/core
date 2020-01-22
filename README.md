# Common Open Research Emulator (CORE) on Windows
> Notice: This is just an image created to lauch the CORE GUI from the [CORE Git Repository](https://github.com/coreemu/core) using Docker and [Phusions Passenger Docker](https://github.com/phusion/passenger-docker#image_variants).

## Requirements
### [VcXsrv X Server](https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde)
Install Chocolat (see [https://chocolatey.org/install](https://chocolatey.org/install)) using PowerShell:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

Run `choco install vcxsrv`

Run `XLaunch` from your Start Menu and follow the wizard. Make sure to check `Disable access control` or create a file named `config.xlauch` and paste the following content:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<XLaunch WindowMode="MultiWindow" ClientMode="NoClient" LocalClient="False" Display="-1" LocalProgram="xcalc" RemoteProgram="xterm" RemotePassword="" PrivateKey="" RemoteHost="" RemoteUser="" XDMCPHost="" XDMCPBroadcast="False" XDMCPIndirect="False" Clipboard="True" ClipboardPrimary="True" ExtraParams="" Wgl="True" DisableAC="True" XDMCPTerminate="False"/>
```
Or download file from the [Github repo](https://github.com/reineltJanis/core/tree/master/VcXsrv%20X%20Server).

By using the wizard, the Server should run in the system tray. By using the file method, open the file with XLaunch.

### Docker
Download and install Docker Desktop from the [Official Docker Webiste](https://hub.docker.com).

##  Start the image
1. Type `ipconfig` to get the current IP address assigned to the vEthernet switch adapter.
2. Use this IP address instead of `YOUR_IP` in the following command (powershell) but leave the `:0.0`:
```powershell
Set-Variable -name DISPLAY -value YOUR_IP:0.0
```
3. Start the container by running
```powershell
docker run -ti --rm -e DISPLAY=$DISPLAY --name core reineltdev/core
```
You can add the `:<VERSION>` tag if neccessary.

## Versions
- `:latest` always contains the latest build of this repository.
- `:dev` always contains the latest development build of this repository.
- `:1.0` followed the installation instructions of the CORE website and embedds the passenger-full image from phusion (ruby, nodejs, etc. installed)
- `:1.1` removed the usage of offline files and reduced image size by compressing packages and excluding unused features like ruby, nodejs, ...)

## Disclaimer
I do not own any of the used softwares. All rights go to their creators or owners.
