@echo off
REM Starts a local web server for the pre-built Khayt store and opens it in your browser.
cd /d "%~dp0"
echo Serving http://localhost:8080  (close this window to stop)
start "" http://localhost:8080
python -m http.server 8080 --directory build/web
