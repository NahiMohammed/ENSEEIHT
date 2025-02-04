@echo off
setlocal

rem Détection automatique du répertoire du script
set BASE_DIR=%~dp0

rem Supprimer le dernier backslash si présent
set BASE_DIR=%BASE_DIR:~0,-1%

rem Définition des agents à lancer
set AGENTS=SpeechReco Interpreter SearchBase Gestion

rem Lancer chaque agent dans une nouvelle fenêtre de terminal
for %%A in (%AGENTS%) do (
    start cmd /k "cd /d %BASE_DIR%\%%A\src && python main.py --device Wi-Fi --port 5670"
)

endlocal
