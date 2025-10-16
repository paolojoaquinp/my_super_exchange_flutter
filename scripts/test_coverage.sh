#!/bin/bash

# Script para ejecutar tests con coverage en Flutter
# Uso: ./scripts/test_coverage.sh

echo "🧪 Ejecutando tests con coverage..."

# Limpiar coverage anterior
rm -rf coverage

# Ejecutar tests con coverage
flutter test --coverage

# Verificar si los tests pasaron
if [ $? -ne 0 ]; then
    echo "❌ Los tests fallaron"
    exit 1
fi

echo "✅ Tests completados exitosamente"

# Verificar si lcov está instalado
if ! command -v lcov &> /dev/null; then
    echo "⚠️  lcov no está instalado. Instalando..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install lcov
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt-get install lcov
    else
        echo "❌ Por favor instala lcov manualmente"
        exit 1
    fi
fi

# Remover archivos generados de la cobertura
echo "🧹 Limpiando archivos generados del reporte de coverage..."
lcov --remove coverage/lcov.info \
    '*.g.dart' \
    '*.freezed.dart' \
    '*.part.dart' \
    '*/generated/*' \
    '*/l10n/*' \
    '*_test.dart' \
    -o coverage/lcov.info

# Verificar si genhtml está disponible
if command -v genhtml &> /dev/null; then
    echo "📊 Generando reporte HTML..."
    genhtml -o coverage/html coverage/lcov.info
    echo "✅ Reporte HTML generado en coverage/html/index.html"
    
    # Abrir el reporte en el navegador (solo en macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🌐 Abriendo reporte en el navegador..."
        open coverage/html/index.html
    fi
else
    echo "⚠️  genhtml no está disponible. Instala lcov para generar reportes HTML"
fi

# Mostrar resumen de coverage
echo ""
echo "📈 Resumen de Coverage:"
lcov --summary coverage/lcov.info

echo ""
echo "✅ Proceso completado"

