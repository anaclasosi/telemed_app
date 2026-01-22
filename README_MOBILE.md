# Guia de Compatibilidade Mobile - App Amamenta+

## ✅ Compatibilidade Garantida

O aplicativo está configurado para funcionar em:
- **Android**: API 21+ (Android 5.0 Lollipop ou superior)
- **iOS**: iOS 12.0 ou superior
- **Web**: Chrome, Safari, Firefox, Edge

## 📱 Configurações Implementadas

### Android
- ✅ **minSdk**: 21 (compatível com 99%+ dos dispositivos)
- ✅ **Permissões configuradas**:
  - Câmera (`CAMERA`)
  - Galeria (`READ_EXTERNAL_STORAGE`, `READ_MEDIA_IMAGES`)
  - Armazenamento (`WRITE_EXTERNAL_STORAGE` para Android < 13)
- ✅ **Compilação**: Java 17, Kotlin

### iOS
- ✅ **Permissões configuradas** no Info.plist:
  - `NSPhotoLibraryUsageDescription`: Acesso à galeria
  - `NSCameraUsageDescription`: Acesso à câmera
  - `NSMicrophoneUsageDescription`: Acesso ao microfone
- ✅ **Orientações suportadas**: Portrait, Landscape

## 📦 Dependências Multiplataforma

Todas as dependências são compatíveis com Android e iOS:

| Pacote | Versão | Android | iOS | Web |
|--------|--------|---------|-----|-----|
| `cupertino_icons` | ^1.0.8 | ✅ | ✅ | ✅ |
| `dotted_border` | ^2.1.0 | ✅ | ✅ | ✅ |
| `image_picker` | ^1.0.7 | ✅ | ✅ | ✅ |
| `fl_chart` | ^0.69.0 | ✅ | ✅ | ✅ |
| `intl` | ^0.19.0 | ✅ | ✅ | ✅ |

## 🚀 Como Executar

### Android
```bash
# Conectar dispositivo ou iniciar emulador
flutter devices

# Executar no dispositivo Android
flutter run -d <device-id>

# Ou simplesmente
flutter run
```

### iOS (requer macOS)
```bash
# Listar dispositivos
flutter devices

# Executar no simulador
flutter run -d "iPhone 15"

# Executar em dispositivo físico
flutter run -d <device-id>
```

### Web
```bash
flutter run -d chrome
```

## 🔧 Build de Produção

### Android APK
```bash
# Build APK de release
flutter build apk --release

# APK será gerado em: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Play Store)
```bash
# Build App Bundle
flutter build appbundle --release

# Bundle será gerado em: build/app/outputs/bundle/release/app-release.aab
```

### iOS (requer macOS e Xcode)
```bash
# Build iOS
flutter build ios --release

# Depois abra no Xcode para assinar e publicar
open ios/Runner.xcworkspace
```

## 📝 Notas Importantes

### Para Android
- **Assinar APK**: Para publicar na Play Store, configure o keystore:
  1. Crie um keystore: `keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
  2. Configure em `android/key.properties`
  3. Atualize `android/app/build.gradle.kts`

### Para iOS
- **Certificados**: Configure no Apple Developer Account
- **Bundle ID**: Altere em `ios/Runner.xcodeproj`
- **Provisioning Profile**: Configure no Xcode

## ✨ Funcionalidades Testadas

- ✅ Timer de amamentação
- ✅ Seleção de fotos (câmera/galeria)
- ✅ Gráficos e estatísticas
- ✅ Entrada manual de dados
- ✅ Diário de registros
- ✅ Perfil do usuário
- ✅ DatePicker e TimePicker
- ✅ Navegação entre telas

## 🐛 Troubleshooting

### Android
- **Erro de permissão**: Verifique que as permissões estão no AndroidManifest.xml
- **MinSdk error**: Confirme que `minSdk = 21` está definido
- **Gradle error**: Execute `flutter clean` e `flutter pub get`

### iOS
- **Info.plist error**: Verifique as permissões NSPhotoLibrary e NSCamera
- **Build error**: Execute `cd ios && pod install && cd ..`
- **Certificado**: Configure no Xcode > Signing & Capabilities

## 📞 Suporte

Para problemas específicos de plataforma, consulte:
- [Flutter Android Setup](https://docs.flutter.dev/get-started/install/windows#android-setup)
- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos#ios-setup)
