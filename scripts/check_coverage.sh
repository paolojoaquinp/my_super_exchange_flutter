#!/bin/bash

# Script para verificar que la cobertura mínima se cumpla
# Uso: ./scripts/check_coverage.sh [min_coverage]
# Ejemplo: ./scripts/check_coverage.sh 80

MIN_COVERAGE=${1:-80}

echo "🔍 Verificando cobertura mínima de ${MIN_COVERAGE}%..."

# Ejecutar tests con coverage
./scripts/test_coverage.sh

if [ $? -ne 0 ]; then
    echo "❌ Error al ejecutar tests"
    exit 1
fi

# Extraer el porcentaje de cobertura
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')

echo ""
echo "📊 Cobertura actual: ${COVERAGE}%"
echo "📊 Cobertura mínima: ${MIN_COVERAGE}%"

# Comparar cobertura
if (( $(echo "$COVERAGE >= $MIN_COVERAGE" | bc -l) )); then
    echo "✅ La cobertura cumple con el mínimo requerido"
    exit 0
else
    echo "❌ La cobertura es menor al ${MIN_COVERAGE}%"
    echo "   Necesitas aumentar la cobertura en $(echo "$MIN_COVERAGE - $COVERAGE" | bc)%"
    exit 1
fi

