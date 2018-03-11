@echo off

REM - Startup info...

echo ~/~ FFMPEG VID-TO-GIF v1.1 by Graham Sider ~/~
echo ~/~ This program will convert any video file to a 30fps GIF ~/~
echo ~/~ PLEASE NOTE: In order to use this program, FFMPEG must be properly installed. Visit https://www.ffmpeg.org/ for more information. ~/~
echo.

REM - Conversion

set /p inputDir="Enter input file path and extension (e.g. input.mp4, C:\dir_path\input.mkv, etc): "
echo.

set /p outputDir="Enter output file path (e.g. output, C:\dir_path\output, etc -- file extension not needed [will be ".gif"]): "
echo.

set /p width="Enter desired output scaling (via width in pixels -- e.g. 1920, 1280, etc. [input "-1" for no scaling]): "
echo.

echo ~/~ CREATING TEMPORARY PALETTE ~/~
echo.
ffmpeg -y -i %inputDir% -vf fps=30,scale=%width%:-1:flags=lanczos,palettegen %TEMP%/palette.png
echo.

REM - Error checking...

IF %ERRORLEVEL% NEQ 0 (
 	echo ~/~ ERROR -- Exiting... ~/~
 	echo.
 	pause
) ELSE (

REM - No error found...

	echo ~/~ PALETTE CREATION SUCCESSFUL ~/~
	echo.
	pause

	echo ~/~ CREATING OUTPUT GIF ~/~
	echo.
	ffmpeg -y -i %inputDir% -i %TEMP%/palette.png -filter_complex "fps=30,scale=%width%:-1:flags=lanczos[x];[x][1:v]paletteuse" %outputDir%.gif
	echo.

	rm %TEMP%/palette.png
	echo ~/~ GIF CREATION SUCCESSFULL, PROGRAM COMPLETE ~/~
	echo.
	pause
)