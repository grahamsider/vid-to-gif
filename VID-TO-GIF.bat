@echo off

REM - Startup info...

echo ~/~ FFMPEG VID-TO-GIF v1.0 by Graham Sider ~/~
echo ~/~ This program will convert any video file to a 30fps GIF ~/~
echo ~/~ PLEASE NOTE: In order to use this program, FFMPEG must be properly installed. Visit https://www.ffmpeg.org/ for more information. ~/~
echo.

REM - Conversion

set /p inputDir="Enter input file directory and extension (e.g. input.mp4, C:\dir_path\my_input.mkv, etc): "
echo.
echo ~/~ DIRECTORY PATH: %inputDir% ~/~
echo.

set /p width="Enter the desired scale of the output .gif file (via width in pixels -- e.g. 1920, 1280, etc. [input "-1" for no scaling]): "
echo.
echo ~/~ PIXEL WIDTH: %width% ~/~
echo.

echo ~/~ CREATING TEMPORARY PALETTE BASED OFF INPUT ~/~
echo.
ffmpeg -y -i %inputDir% -vf fps=30,scale=%width%:-1:flags=lanczos,palettegen palette.png
echo.

REM - Error checking...

IF %ERRORLEVEL% NEQ 0 (
 	echo ~/~ ERROR -- Exiting... ~/~
 	echo.
 	pause
) ELSE (

REM - No error found...

	echo ~/~ PALETTE CREATION SUCCESSFULL ~/~
	echo.
	pause

	echo ~/~ CREATING OUTPUT GIF ~/~
	echo.
	ffmpeg -y -i %inputDir% -i palette.png -filter_complex "fps=30,scale=%width%:-1:flags=lanczos[x];[x][1:v]paletteuse" output.gif
	echo.

	rm palette.png
	echo ~/~ GIF CREATION SUCCESSFULL, PROGRAM COMPLETE ~/~
	echo.
	pause
)