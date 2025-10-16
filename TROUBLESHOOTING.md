# 🔧 Troubleshooting - Solución de Problemas de Testing

## Problema: "Failed to find flutter_tester" en Apple Silicon

### Descripción del Error

```
Failed to find "/path/to/flutter/bin/cache/artifacts/engine/darwin-x64/flutter_tester" in the search path.
```

Este error ocurre en dispositivos con chips Apple Silicon (M1, M2, M3) porque Flutter está buscando el binario en la arquitectura `darwin-x64` en lugar de `darwin-arm64`.

### Soluciones

#### Solución 1: Descargar Artefactos Necesarios

```bash
# Limpiar cache de Flutter
flutter clean

# Descargar artefactos para macOS e iOS
flutter precache --ios --macos

# Intentar ejecutar los tests nuevamente
flutter test
```

#### Solución 2: Actualizar Flutter (Requiere Espacio en Disco)

```bash
# Verificar espacio en disco primero
df -h

# Si hay suficiente espacio (al menos 5GB), actualizar Flutter
flutter upgrade

# Descargar artefactos
flutter precache
```

#### Solución 3: Liberar Espacio en Disco

Si recibes el error `No space left on device`:

```bash
# Ver uso de disco
df -h

# Limpiar cache de Flutter en todos los proyectos
find ~/projects -name "build" -type d -exec rm -rf {} + 2>/dev/null
find ~/projects -name ".dart_tool" -type d -exec rm -rf {} + 2>/dev/null

# Limpiar cache global de Flutter
flutter clean
rm -rf $HOME/.pub-cache/hosted/*

# Limpiar cache de Gradle (Android)
rm -rf ~/.gradle/caches

# Limpiar cache de CocoaPods (iOS)
rm -rf ~/Library/Caches/CocoaPods

# Después de liberar espacio, intentar nuevamente
flutter precache --ios --macos
```

#### Solución 4: Ejecutar Terminal en Modo Rosetta (Última Opción)

Si nada funciona, puedes ejecutar la terminal en modo Rosetta:

1. Ve a `Aplicaciones` > `Utilidades`
2. Haz clic derecho en `Terminal`
3. Selecciona `Obtener información`
4. Marca la casilla `Abrir con Rosetta`
5. Reinicia la terminal y ejecuta los tests

**Nota:** Esta solución es más lenta ya que emula arquitectura x86_64.

## Problema: Tests Fallan por Dependencias Faltantes

### Error

```
Error: Cannot find package 'mocktail'
```

### Solución

```bash
# Reinstalar dependencias
flutter pub get

# Si persiste, limpiar y reinstalar
flutter clean
flutter pub get
```

## Problema: Timeout en Tests de BLoC

### Error

```
Test timed out after 30 seconds
```

### Solución

Aumenta el timeout en el test específico:

```dart
blocTest<ExchangeBloc, ExchangeState>(
  'test description',
  build: () => bloc,
  act: (bloc) => bloc.add(event),
  wait: const Duration(seconds: 2), // Aumentar este valor
  timeout: const Duration(seconds: 60), // Agregar timeout personalizado
  expect: () => [...],
);
```

## Problema: Coverage No Se Genera

### Error

```
lcov: command not found
```

### Solución en macOS

```bash
# Instalar lcov usando Homebrew
brew install lcov

# Verificar instalación
lcov --version
```

### Solución en Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install lcov
```

## Problema: genhtml No Genera Reporte HTML

### Solución

```bash
# Verificar que lcov esté instalado
which genhtml

# Si no está instalado, instalar lcov (incluye genhtml)
brew install lcov  # macOS
sudo apt-get install lcov  # Linux
```

## Problema: Tests Pasan Localmente pero Fallan en CI/CD

### Causas Comunes

1. **Diferencias de Timezone**: Usa `DateTime.utc()` en lugar de `DateTime.now()`
2. **Archivos Dependientes del Sistema**: Evita rutas absolutas
3. **Variables de Entorno**: Asegúrate de configurarlas en CI/CD

### Solución

```dart
// ❌ Mal
final now = DateTime.now();

// ✅ Bien
final now = DateTime.utc(2024, 1, 1);

// ❌ Mal
final path = '/Users/user/file.txt';

// ✅ Bien
final path = 'assets/file.txt';
```

## Problema: Mock No Funciona Correctamente

### Error

```
MissingStubError: 'getData'
No stub was found which matches the arguments of this method call
```

### Solución

Asegúrate de configurar el stub ANTES de usarlo:

```dart
// ❌ Mal - Sin stub
final result = await mockRepo.getData();

// ✅ Bien - Con stub configurado
when(() => mockRepo.getData())
    .thenAnswer((_) async => Result.ok(data));
    
final result = await mockRepo.getData();
```

## Problema: "Platform Exception" en Tests

### Causa

Los tests unitarios no tienen acceso a plugins nativos.

### Solución

Mock los canales de plataforma o usa integration tests:

```dart
// Para unit tests, mockea el método
class MockPlatformChannel extends Mock implements MethodChannel {}

// O usa TestDefaultBinaryMessengerBinding
TestWidgetsFlutterBinding.ensureInitialized();
```

## Verificar que Todo Funciona

Ejecuta este comando para verificar tu configuración:

```bash
# Verificar Flutter
flutter doctor -v

# Verificar dependencias de test
flutter pub get

# Ejecutar un test simple
flutter test test/features/exchange/domain/entities/currency_entity_test.dart

# Si pasa, intentar todos los tests
flutter test
```

## Contacto y Soporte

Si ninguna solución funciona:

1. Verifica la versión de Flutter: `flutter --version`
2. Revisa los issues de Flutter: https://github.com/flutter/flutter/issues
3. Busca en Stack Overflow con tu error específico
4. Consulta la documentación oficial: https://docs.flutter.dev/testing

---

**Última actualización:** Octubre 2025

