@echo off
setlocal
set JAVA_HOME=D:\android.studio\jbr
set PATH=%JAVA_HOME%\bin;%PATH%
call "D:\android.studio\plugins\Kotlin\kotlinc\bin\kotlinc" Main.kt -include-runtime -d notedwork.jar
if errorlevel 1 (echo GAGAL compile, cek error di atas. & pause & exit /b 1)
"%JAVA_HOME%\bin\java.exe" -jar notedwork.jar
