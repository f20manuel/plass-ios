# PLASS
![Plass](https://img.shields.io/badge/PLASS-v7.9.7-blue?style=flat=&logo=ios)

## Entorno
![Firebase](https://img.shields.io/badge/firebase-plan%20blase-blue.svg?style=flat&logo=firebase) ![Flutter](https://img.shields.io/badge/Flutter-v2.10.3%20(stable)-blue?style=flat&logo=Flutter&logoColor=white) ![Dart](https://img.shields.io/badge/dart-v2.16.1%20(stable)-blue?style=flat&logo=dart&logoColor=white) ![IOS](https://img.shields.io/badge/target-12.4+-blue?style=flat&logo=ios&logoColor=white) ![Xcode](https://img.shields.io/badge/Xcode-v13.3-blue?style=flat&logo=Xcode&logoColor=white) ![Mac OS](https://img.shields.io/badge/mac%20os-monterrey%20v12.3-blue?style=flat&logo=macos&logoColor=F0F0F0)

Plass Usuario

## Antes de comenzar

Este proyecto esta basado en el frameword de UI para iOS y Android FLutter, por lo que sera necesario para su completo funcionamiento usar los siguientes comandos para su iniciación.

### Descarga e instalación de dependencias

```bash
flutter clean && flutter pub get
```

### Correo código en un Emulador o dispositivo físico

Para esta funcionalidad se cuenta con dos báses de datos:

- **versions/1.0.0**: Versión de producción.
- **versions/dev_version**: Versión de desarrollo.

Este proyecto cuenta con dos entornos ejecutables de el comando ```flutter run```, por defecto si no se le agrega ningun comando el proyecto ejecutará el código con la versión de producción.

Puede elegir la versión de entorno que desea ejecutar con el siguiente comando:

```bash
flutter run --dart-define=ENVIRONMENT=DEV #Para la versión de desarrollo
# o también
flutter run --dart-define=ENVIRONMENT=PRO #Para la versión de producción
```

```NOTA: Se dejo como predeterminado el entorno de producción para facilitar la subida a tiendas y asegurar que solo se suba una versión de producción.```

## Dependencias utilizadas
```yml
  cupertino_icons: ^1.0.2
  get: ^4.6.1
  url_launcher: ^6.0.20
  flutter_launcher_icons: ^0.9.2
  firebase_core: ^1.13.1
  cloud_firestore: ^3.1.10
  firebase_auth: ^3.3.11
  package_info_plus: ^1.4.0
  skeletons: ^0.0.3
  country_code_picker: ^2.0.2
  device_info_plus: ^3.2.2
  location: ^4.3.0
  pin_code_fields: ^7.3.0
  cached_network_image: ^3.2.0
  paginate_firestore: ^1.0.3
  intl: ^0.17.0
  badges: ^2.0.2
  firebase_messaging: ^11.2.11
  image_picker: ^0.8.4+11
  image_cropper: ^1.5.0
  firebase_storage: ^10.2.10
  bubble: ^1.2.1
  flutter_rating_bar: ^4.0.0
  connectivity_plus: ^2.3.0
  qr_code_scanner: ^0.7.0
  flutter_ringtone_player: ^3.2.0
```