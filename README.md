# OctoPrint WinService
Windows Services Controller for OctoPrint 

Manage OctoPrint for Windows via Windows Services. 

1. Download Binary From http://www.infobitas.lt/jdownloads/OctoPrintService.zip
2. Place files from zip archive in desired location 
3. Change parameter "ServicePath" in Settings.ini file with your path to "octoprint.exe"
4. Run "Install.bat" as Administrator
5. Open Windows "Services", find "OctoPrint Service", start service. 
6. Note, that OctoPrint server settings are user-based, so service logon user will take affect. Default is "Local System".
7. If you experience service start problems - make sure, that service user has permissions to access location of executable.


