# OctoPrint Windws Installer
Windows Installer and Services Controller for OctoPrint 

Install OctoPrint on Windows with automated installer and manage via Windows Services. 

Instalation package includes:
1. Microsoft Visual C++ Compiler Package for Python 2.7
2. Microsoft Visual Studio BuildTools (newest version by online installer)
3. Python 3.11.1 (32-bit)
4. OctoPrint (newest online installer)
5. OctoPrint Windows Service Controller (part of this project)

Instalation package automatically performs all the steps from OctoPrint Setup manual https://community.octoprint.org/t/setting-up-octoprint-on-windows/383

OctoPrint will be installed to C:\OctoPrint (C:\OctoPrint\venv)
Python will be installed to C:\Python (skip prerequisite installation by unchecking checkbox if it is already installed)

1. Download Binary From http://infobitas.lt/jdownloads/OctoPrint_Installer.exe
2. Run instalation. OctoPrint service will be started automatically.
3. Go to http://localhost:5000 to finish setup settings.
4. Open Windows "Services", find "OctoPrint Service", start/stop service. 
5. Note, that OctoPrint server settings are user-based, so service logon user will take affect. Default is "Local System".
6. If you experience service start problems - make sure, that service user has permissions to access location of executable.


