CD C:\OctoPrint
pip install virtualenv
virtualenv venv 
set original_dir=%CD%
set venv_root_dir="C:\OctoPrint\venv"
cd %venv_root_dir%
call %venv_root_dir%\Scripts\activate.bat
pip install octoprint
pip install --no-cache-dir octoprint
call %venv_root_dir%\Scripts\deactivate.bat
cd %original_dir%
exit /B 1
