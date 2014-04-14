
:: SETTINGS AND PATHS 
:: Note: Do not put spaces before the equal signs or variables will fail
set year=%DATE:~10,4%
set day=%DATE:~7,2%
set mnt=%DATE:~4,2%
set hr=%TIME:~0,2%
set min=%TIME:~3,2%

IF %day% LSS 10 SET day=0%day:~1,1%
IF %mnt% LSS 10 SET mnt=0%mnt:~1,1%
IF %hr% LSS 10 SET hr=0%hr:~1,1%
IF %min% LSS 10 SET min=0%min:~1,1%

set backuptime=%year%-%day%-%mnt%


:: Error log path - Important in debugging your issues

set importDir="C:\Apache2.2\htdocs\accounts\clientFiles\imports\"
set backupfldr="C:\Apache2.2\htdocs\accounts\clientFiles\archived\"
set backupfldr2=U:\Sales_Consumer\Public\customerValidationArchives\

:: MySQL EXE Path
set mysqldumpexe="C:\Program Files\MySQL\MySQL Server 5.5\bin\mysql.exe"

set zipper="c:\Program Files\7-Zip\7z.exe"


:: DONE WITH SETTINGS



:: GO FORTH AND BACKUP EVERYTHING!

:: .zip option clean but not as compressed
%zipper% a -t7z "%backupfldr%%backuptime%.7z" "%importDir%*.txt"
%zipper% a -t7z "%backupfldr2%%backuptime%.7z" "%importDir%*.txt"

%mysqldumpexe% --host=%dbhost% --user=%dbuser% --password=%dbpass% --database=accountNumbers --local-infile < %sqlFilePath%

del "%importDir%*.txt"