@echo off
REM Script para ejecutar tests con coverage en Flutter (Windows)
REM Uso: scripts\test_coverage.bat

echo Ejecutando tests con coverage...

REM Limpiar coverage anterior
if exist coverage rmdir /s /q coverage

REM Ejecutar tests con coverage
flutter test --coverage

REM Verificar si los tests pasaron
if %ERRORLEVEL% NEQ 0 (
    echo Los tests fallaron
    exit /b 1
)

echo Tests completados exitosamente

echo.
echo Reporte de coverage generado en coverage/lcov.info
echo Para ver el reporte HTML, instala lcov y ejecuta:
echo   genhtml -o coverage/html coverage/lcov.info
echo.

echo Proceso completado

