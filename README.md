# MERCH Касса

Служебное Android-приложение для сотрудников магазина одежды MERCH: касса лояльности и кабинет админа.

Клиент носит карту в Apple Wallet / Google Wallet. Сотрудник в этом приложении сканирует QR, проводит чек и выдаёт карту.

## Стек

Flutter 3.24+ / Dart 3.10+, архитектура как в `PET/foshill`: Pure DI, `flutter_bloc`, `go_router`, `RestClientDio`.

ТЗ: [`merch-backend/docs/TZ-MERCH-APP.md`](../merch-backend/docs/TZ-MERCH-APP.md)

## Запуск

Бэкенд локально: `cd ../merch-backend && make run` (порт `:8080`).

```bash
flutter pub get
flutter gen-l10n
dart run flutter_launcher_icons
dart run flutter_native_splash:create

# iOS Simulator / desktop → localhost
flutter run --dart-define=ENVIRONMENT=DEV --dart-define=API_BASE_URL=http://127.0.0.1:8080

# Android emulator
flutter run --dart-define=ENVIRONMENT=DEV --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

Логин по умолчанию после первого старта бэкенда: `admin` / `changeme`.

## Сборка APK

```bash
flutter build apk --release --split-per-abi --dart-define=ENVIRONMENT=PROD --dart-define=API_BASE_URL=https://api.example.com
```

Имя на устройстве: **MERCH Касса**.
