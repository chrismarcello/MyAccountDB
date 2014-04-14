
:: SETTINGS AND PATHS 
:: Note: Do not put spaces before the equal signs or variables will fail

:: Host to connect to.
set dbhost=localhost

:: Name of the database user with rights to all tables
set dbuser=user

:: Password for the database user
set dbpass=password

:: Error log path - Important in debugging your issues
set sqlFilePath="C:\Apache2.2\htdocs\accounts\clientFiles\sqlFile.sql"

:: MySQL EXE Path
set mysqldumpexe="C:\Program Files\MySQL\MySQL Server 5.5\bin\mysql.exe"




:: DONE WITH SETTINGS



:: GO FORTH AND BACKUP EVERYTHING!

%mysqldumpexe% --host=%dbhost% --user=%dbuser% --password=%dbpass% --database=accountNumbers --local-infile < %sqlFilePath%

