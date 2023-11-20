
rem @echo off

SETLOCAL
set PHYSIO_EXTRACTOR_BASEPATH=%~dp0

if not exist physio_output mkdir physio_output

echo ###

if %1!==! goto usage
%PHYSIO_EXTRACTOR_BASEPATH%\physioExtractor.exe -x -v -o physio_output -i %1 -s %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG3.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG4.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_RESP.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PULS.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_C.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_R.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_AcquisitionInfo.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PhysioTriggertimes.xsl

echo ###

if %2!==! goto end
%PHYSIO_EXTRACTOR_BASEPATH%\physioExtractor.exe -x -v -o physio_output -i %2 -s %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG3.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG4.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_RESP.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PULS.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_C.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_R.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_AcquisitionInfo.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PhysioTriggertimes.xsl

echo ###

if %3!==! goto end
%PHYSIO_EXTRACTOR_BASEPATH%\physioExtractor.exe -x -v -o physio_output -i %3 -s %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG3.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG4.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_RESP.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PULS.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_C.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_R.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_AcquisitionInfo.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PhysioTriggertimes.xsl

echo ###

if %4!==! goto end
%PHYSIO_EXTRACTOR_BASEPATH%\physioExtractor.exe -x -v -o physio_output -i %4 -s %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG3.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG4.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_RESP.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PULS.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_C.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_R.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_AcquisitionInfo.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PhysioTriggertimes.xsl

echo ###

if %5!==! goto end
%PHYSIO_EXTRACTOR_BASEPATH%\physioExtractor.exe -x -v -o physio_output -i %5 -s %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG3.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG4.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_RESP.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PULS.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_C.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_R.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_AcquisitionInfo.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PhysioTriggertimes.xsl

echo ###

if %6!==! goto end
%PHYSIO_EXTRACTOR_BASEPATH%\physioExtractor.exe -x -v -o physio_output -i %6 -s %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG3.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG4.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_RESP.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PULS.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_C.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_R.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_AcquisitionInfo.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PhysioTriggertimes.xsl

echo ###

if %7!==! goto end
%PHYSIO_EXTRACTOR_BASEPATH%\physioExtractor.exe -x -v -o physio_output -i %7 -s %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG3.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_ECG4.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_RESP.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PULS.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT1.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_EXT2.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_C.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PT_R.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_AcquisitionInfo.xsl %PHYSIO_EXTRACTOR_BASEPATH%\physio_styles\Style_PhysioTriggertimes.xsl

ENDLOCAL

:usage
echo call  physioExtractor.bat dicomfile1.ima [dicomfile2.ima] [dicomfile3.ima]...

:end
