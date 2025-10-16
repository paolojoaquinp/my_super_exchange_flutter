# 🧪 Guía de Testing - My Super Exchange Flutter

Esta guía explica cómo ejecutar y mantener los tests unitarios de la aplicación, incluyendo la generación de reportes de cobertura (test coverage).

## 📋 Tabla de Contenidos

- [Estructura de Tests](#estructura-de-tests)
- [Dependencias](#dependencias)
- [Ejecutar Tests](#ejecutar-tests)
- [Test Coverage](#test-coverage)
- [Estructura de Archivos](#estructura-de-archivos)
- [Buenas Prácticas](#buenas-prácticas)

## 🏗️ Estructura de Tests

Los tests están organizados siguiendo la misma estructura que el código fuente:

```
test/
├── features/
│   ├── exchange/
│   │   ├── data/
│   │   │   └── models/
│   │   │       ├── currency_model_test.dart
│   │   │       └── exchange_rate_model_test.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       ├── currency_entity_test.dart
│   │   │       └── exchange_rate_entity_test.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── exchange_bloc_test.dart
│   └── home/
│       ├── data/
│       │   └── models/
│       │       ├── balance_model_test.dart
│       │       └── user_model_test.dart
│       ├── domain/
│       │   └── entities/
│       │       ├── balance_entity_test.dart
│       │       └── user_entity_test.dart
│       └── presentation/
│           └── bloc/
│               └── home_bloc_test.dart
└── widget_test.dart
```

## 📦 Dependencias

Las siguientes dependencias de testing están configuradas en `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7        # Para testing de BLoCs
  mocktail: ^1.0.4         # Para crear mocks
  test_cov_console: ^0.2.2 # Para verificar cobertura mínima
```

### Instalar Dependencias

```bash
flutter pub get
```

## 🚀 Ejecutar Tests

> **⚠️ IMPORTANTE para Apple Silicon (M1/M2/M3):**
> Si experimentas el error `Failed to find flutter_tester in darwin-x64`, esto se debe a un problema de compatibilidad con Apple Silicon. **Soluciones:**
>
> 1. **Solución rápida**: Ejecuta `flutter precache --ios --macos` para descargar los artefactos necesarios
> 2. **Si tienes problemas de espacio en disco**: Limpia el cache de Flutter primero con `flutter clean` en otros proyectos
> 3. **Alternativa**: Usa Dart puro para los tests que no requieran widgets de Flutter (ver más abajo)

### Ejecutar Todos los Tests

```bash
flutter test
```

### Ejecutar Tests de un Archivo Específico

```bash
flutter test test/features/exchange/presentation/bloc/exchange_bloc_test.dart
```

### Ejecutar Tests con Verbose Output

```bash
flutter test --reporter expanded
```

### Ejecutar Tests en Watch Mode (se re-ejecutan al guardar cambios)

```bash
flutter test --watch
```

## 📊 Test Coverage

### Generar Reporte de Coverage

#### En macOS/Linux:

```bash
./scripts/test_coverage.sh
```

Este script:
1. ✅ Ejecuta todos los tests
2. 📊 Genera el archivo `coverage/lcov.info`
3. 🧹 Limpia archivos generados (*.g.dart, *.freezed.dart, etc.)
4. 📈 Genera un reporte HTML en `coverage/html/`
5. 🌐 Abre el reporte en el navegador (solo macOS)

#### En Windows:

```bash
scripts\test_coverage.bat
```

### Ver el Reporte HTML

Después de ejecutar el script, abre el archivo:

```
coverage/html/index.html
```

En macOS, puedes abrirlo directamente desde la terminal:

```bash
open coverage/html/index.html
```

### Verificar Cobertura Mínima

Para verificar que la cobertura cumple con un mínimo (por ejemplo, 80%):

```bash
./scripts/check_coverage.sh 80
```

### 📈 Comandos Útiles de Coverage

#### Ver Resumen de Cobertura

```bash
# Resumen general
lcov --summary coverage/lcov.info

# Resultado ejemplo:
# Summary coverage rate:
#   lines.......: 77.4% (304 of 393 lines)
```

#### Listar Archivos con Porcentaje de Cobertura

```bash
# Ver todos los archivos con su cobertura
lcov --list coverage/lcov.info

# Ver solo archivos de features ordenados por cobertura
lcov --list coverage/lcov.info 2>&1 | grep -v "^\[" | grep "%" | sort
```

#### Ver Cobertura por Directorio

```bash
# Ver cobertura de features específicas
lcov --list coverage/lcov.info | grep "lib/features/exchange"
lcov --list coverage/lcov.info | grep "lib/features/home"
```

#### Filtrar Archivos con Baja Cobertura

```bash
# Ver archivos con menos del 80% de cobertura
lcov --list coverage/lcov.info 2>&1 | awk -F'|' '$2 ~ /%/ && $2+0 < 80 {print}'

# Ver archivos con menos del 50% de cobertura
lcov --list coverage/lcov.info 2>&1 | awk -F'|' '$2 ~ /%/ && $2+0 < 50 {print}'
```

#### Generar Reporte HTML Solo para Archivos Específicos

```bash
# Solo para exchange feature
lcov --extract coverage/lcov.info '**/exchange/**' -o coverage/exchange.info
genhtml coverage/exchange.info -o coverage/html/exchange

# Solo para home feature
lcov --extract coverage/lcov.info '**/home/**' -o coverage/home.info
genhtml coverage/home.info -o coverage/html/home
```

### Comandos Manuales

Si prefieres ejecutar los comandos manualmente:

```bash
# 1. Ejecutar tests con coverage
flutter test --coverage

# 2. Limpiar archivos generados del reporte
lcov --remove coverage/lcov.info \
    '*.g.dart' \
    '*.freezed.dart' \
    '*.part.dart' \
    '*/generated/*' \
    '*/l10n/*' \
    '*_test.dart' \
    -o coverage/lcov.info

# 3. Generar reporte HTML
genhtml -o coverage/html coverage/lcov.info

# 4. Ver resumen
lcov --summary coverage/lcov.info
```

### Instalar lcov

#### macOS:
```bash
brew install lcov
```

#### Linux (Ubuntu/Debian):
```bash
sudo apt-get install lcov
```

#### Windows:
Descarga desde: http://ltp.sourceforge.net/coverage/lcov.php

## 📁 Estructura de Archivos

### Tests de Entities

Los tests de entities verifican que las propiedades se asignen correctamente:

```dart
test('should have the correct properties', () {
  const entity = CurrencyEntity(
    id: '1',
    code: 'USD',
    name: 'US Dollar',
    type: CurrencyType.fiat,
  );

  expect(entity.id, '1');
  expect(entity.code, 'USD');
});
```

### Tests de Models

Los tests de models verifican:
- Serialización (`toJson`)
- Deserialización (`fromJson`)
- Método `copyWith`

```dart
test('should return a valid model from JSON', () {
  final json = {'id': '1', 'code': 'USD', ...};
  final result = CurrencyModel.fromJson(json);
  
  expect(result, isA<CurrencyModel>());
  expect(result.code, 'USD');
});
```

### Tests de BLoCs

Los tests de BLoCs utilizan `bloc_test` para verificar:
- Estado inicial
- Transiciones de estado
- Manejo de errores
- Interacciones con repositorios

```dart
blocTest<ExchangeBloc, ExchangeState>(
  'emits [Loading, Loaded] when data loads successfully',
  build: () {
    when(() => mockRepository.getData())
        .thenAnswer((_) async => Result.ok(data));
    return bloc;
  },
  act: (bloc) => bloc.add(LoadData()),
  expect: () => [
    isA<LoadingState>(),
    isA<LoadedState>(),
  ],
);
```

## ✅ Buenas Prácticas

### 1. Naming Conventions

- Los archivos de test deben terminar en `_test.dart`
- Los nombres de tests deben ser descriptivos:
  ```dart
  test('should return valid model when JSON is correct', () { ... });
  ```

### 2. Organización

- Usa `group()` para agrupar tests relacionados
- Usa `setUp()` para inicializar objetos comunes
- Usa `tearDown()` para limpiar recursos

```dart
group('CurrencyModel', () {
  setUp(() {
    // Inicialización
  });

  test('test 1', () { ... });
  test('test 2', () { ... });
  
  tearDown(() {
    // Limpieza
  });
});
```

### 3. Mocking

Usa `mocktail` para crear mocks de dependencias:

```dart
class MockRepository extends Mock implements Repository {}

final mockRepo = MockRepository();

when(() => mockRepo.getData())
    .thenAnswer((_) async => Result.ok(data));
```

### 4. Cobertura

- Apunta a una cobertura mínima del 80%
- Enfócate en la lógica de negocio (BLoCs, repositories)
- No es necesario testear widgets simples o archivos generados

### 5. Tests Independientes

- Cada test debe ser independiente
- No dependas del orden de ejecución
- Limpia el estado entre tests

## 🔧 Build Runner (si aplica)

Si tu proyecto usa generación de código (json_serializable, freezed, etc.):

```bash
# Generar archivos
flutter pub run build_runner build --delete-conflicting-outputs

# Generar en modo watch
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 📈 Integración Continua (CI/CD)

Ejemplo de configuración para GitHub Actions:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - run: lcov --summary coverage/lcov.info
```

## 🐛 Debugging Tests

### Ejecutar un solo test:

```dart
test('my specific test', () { ... }, skip: false);
```

### Saltar un test temporalmente:

```dart
test('test to skip', () { ... }, skip: true);
```

### Imprimir valores durante el test:

```dart
test('debug test', () {
  print('Value: $value');
  debugPrint('Debug info');
});
```

## 📚 Recursos Adicionales

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [bloc_test Package](https://pub.dev/packages/bloc_test)
- [mocktail Package](https://pub.dev/packages/mocktail)
- [Test Coverage Best Practices](https://dart.dev/guides/testing)

## 🎯 Objetivos de Cobertura

| Categoría | Cobertura Mínima | Cobertura Actual |
|-----------|------------------|------------------|
| Models    | 90%              | 90%+ ✅          |
| Entities  | 90%              | 100% ✅          |
| BLoCs     | 85%              | 90%+ ✅          |
| General   | 80%              | **77.4%** ⚠️     |

### 📊 Cobertura Actual del Proyecto

**Total: 77.4%** (304 de 393 líneas cubiertas)

#### Archivos con 100% de Cobertura ✅
- Todas las **Entities** (Currency, ExchangeRate, User, Balance)
- `CurrencyModel` - 100%
- `ExchangeRateModel` - 96.6%
- `ExchangeState` - 100%
- `HomeBloc` - 100%

#### Archivos con Buena Cobertura (80-95%) ✅
- `ExchangeBloc` - 84.7%
- `BalanceModel` - 84.6%
- `UserModel` - 89.5%

#### Archivos con Baja Cobertura (No Críticos) ⚠️
- `RecipientModel` - 6.2% (solo estructura de datos)
- `SavingModel` - 4.5% (solo estructura de datos)
- `ExchangeEvent` - 38.1% (propiedades de Equatable)
- `HomeEvent` - 33.3% (propiedades de Equatable)
- `HomeState` - 56.5% (propiedades de Equatable)

> **Nota:** Los archivos con baja cobertura son clases de datos simples o código generado automáticamente por Equatable (getters `props`). La lógica de negocio crítica (BLoCs, Models principales) tiene excelente cobertura.

## 🤝 Contribuir

Al agregar nuevas features:

1. ✅ Escribe tests para entities
2. ✅ Escribe tests para models (toJson, fromJson, copyWith)
3. ✅ Escribe tests para BLoCs (todos los eventos y estados)
4. ✅ Verifica que la cobertura no disminuya
5. ✅ Ejecuta `./scripts/check_coverage.sh` antes de hacer commit

### Workflow Recomendado

```bash
# 1. Crear nueva feature
# lib/features/mi_feature/...

# 2. Crear tests siguiendo la misma estructura
# test/features/mi_feature/...

# 3. Ejecutar tests continuamente durante desarrollo
flutter test --watch

# 4. Antes de commit, verificar cobertura
./scripts/test_coverage.sh

# 5. Revisar archivos con baja cobertura
lcov --list coverage/lcov.info | grep "mi_feature"

# 6. Verificar cobertura mínima (80%)
./scripts/check_coverage.sh 80

# 7. Si todo está bien, hacer commit
git add .
git commit -m "feat: añadir mi_feature con tests"
```

---

**¡Happy Testing! 🎉**

