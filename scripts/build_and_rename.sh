#!/bin/bash

function Display_Help {
  echo "Options:"
  echo "  --ios       = Build iOS IPA"
  echo "  --android   = Build Android APK"
  echo "  --version=* = Set version in pubspec, keeps existing if empty or absent"
  echo "  --build=*   = Set build number in pubspec, keeps existing if empty or absent"
  echo "  -h | --help = Show this help message and exit"
  echo ""
  echo "With no platform flags, both iOS and Android are built."
}

while getopts ':-:h' VAL ; do
  case $VAL in
    h ) Display_Help ; exit 0 ;;
    - )
      case $OPTARG in
        ios ) IOS=1 ;;
        android ) ANDROID=1 ;;
        version=* ) VERSION_ARG="${OPTARG#*=}" ;;
        build=* ) BUILD_ARG="${OPTARG#*=}" ;;
        help ) Display_Help ; exit 0 ;;
        *)
          echo "Error: Failed to parse arguments"
          exit 1
        ;;
      esac
    ;;
    * )
      echo "Error: Failed to parse arguments"
      exit 1
    ;;
  esac
done
shift $((OPTIND -1))

if [[ -z $IOS && -z $ANDROID ]]; then
  IOS=1
  ANDROID=1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

echo "Changing version and build number if needed"
PUBSPEC_VERSION=$(grep 'version: ' pubspec.yaml | head -n 1 | sed 's/version: //' | tr -d ' \t\n\r')

if [ -z "$PUBSPEC_VERSION" ]; then
  echo "Error: Failed to find the version in pubspec.yaml"
  exit 1
fi

VERSION_NUMBER=$(echo "$PUBSPEC_VERSION" | cut -d '+' -f 1)
BUILD_NUMBER=$(echo "$PUBSPEC_VERSION" | cut -d '+' -f 2)

if [ -n "$VERSION_ARG" ]; then
  VERSION_NUMBER="$VERSION_ARG"
fi
if [ -n "$BUILD_ARG" ]; then
  BUILD_NUMBER="$BUILD_ARG"
fi

if [[ -n $VERSION_ARG || -n $BUILD_ARG ]]; then
  sed -i '' "s/version: $PUBSPEC_VERSION/version: $VERSION_NUMBER+$BUILD_NUMBER/" pubspec.yaml
  flutter pub get
fi

echo "Application version: $VERSION_NUMBER+$BUILD_NUMBER"

echo "Checking if builds directory exists"
BUILDS_DIRECTORY="builds"
if [ -d "$BUILDS_DIRECTORY" ]; then
  echo "The directory '$BUILDS_DIRECTORY' exists."
else
  echo "The directory '$BUILDS_DIRECTORY' does not exist. Creating..."
  mkdir -p "$BUILDS_DIRECTORY"
fi

function Rename_Build {
  if [ -f "$3" ]; then
    NEW_NAME="$1 MERCH Касса ($VERSION_NUMBER) $BUILD_NUMBER.$2"
    mv "$3" "$BUILDS_DIRECTORY/$NEW_NAME"
    echo "$2 renamed to $NEW_NAME and moved to builds folder"
  else
    echo "Error: $2 not found at $3."
    exit 1
  fi
}

function Prepare_IOS_Build {
  echo "Preparing iOS build: flutter clean, flutter pub get, pods reinstall..."
  flutter clean
  flutter pub get

  cd ios || exit 1
  rm -rf Pods Podfile.lock
  pod install
  cd "$ROOT" || exit 1
}

function Build_IOS {
  Prepare_IOS_Build
  echo "Starting IPA build..."
  flutter build ipa --release

  shopt -s nullglob
  IPA_FILES=(build/ios/ipa/*.ipa)
  shopt -u nullglob

  if [ ${#IPA_FILES[@]} -eq 0 ]; then
    echo "Error: ipa not found."
    exit 1
  fi

  Rename_Build "[iOS]" "ipa" "${IPA_FILES[0]}"
}

function Build_Android {
  echo "Starting release APK build..."
  flutter build apk --release
  Rename_Build "[RELEASE]" "apk" "build/app/outputs/flutter-apk/app-release.apk"
}

if [[ -n $IOS ]]; then
  Build_IOS
fi

if [[ -n $ANDROID ]]; then
  Build_Android
fi
