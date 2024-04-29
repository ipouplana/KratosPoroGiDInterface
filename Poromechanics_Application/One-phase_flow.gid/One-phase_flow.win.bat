rem USED BY GiD
rem OutputFile: %1.info
rem ErrorFile: %1.err

rem Information
rem basename = %1
rem currentdirectory = %2
rem problemtypedirectory = %3

rem Setting paths. WARNING: one should check them before running this file
set PATH="C:\\Users\\Xavi Tort\\source\\repos\\KratosMultiphysics\\Kratos\\bin\\FullDebug\\libs";%PATH%
set PYTHONPATH="C:\\Users\\Xavi Tort\\source\\repos\\KratosMultiphysics\\Kratos\\bin\\FullDebug";%PYTHONPATH%


rem Execute the program
"C:\\Users\\Xavi Tort\\AppData\\Local\\Programs\\Python\Python39\\python.exe" MainKratos.py > %1.info 2> %1.err
