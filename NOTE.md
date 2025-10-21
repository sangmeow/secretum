# secretum

### 네이티브 스플래시 화면 (권장)
앱 실행 직후 플러터 엔진이 뜨기 전에 보이는 화면.
```
dependencies:
  flutter_native_splash: ^2.4.0
```

### 최초 시작 알림
```
dependencies:
  shared_preferences: ^2.2.2
```

### 6-pin 저장 위치
```
dependencies:
  flutter_secure_storage: ^9.0.0
```

### 노트 저장
```
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0   # Flutter 전용 어댑터
```

## 색상정보
기본 배경 : #1e1e1e
버튼 색상 : #2b2d30
whitesmoke: #F5F5F5
SECRETUM: #dcdcdc

### flutter 정리
```
flutter clean
flutter pub get
```

### APK / App Bundle 빌드 후 설치

APK 만들기
```
flutter clean
flutter pub get
flutter build apk --release
```
build/app/outputs/flutter-apk/app-release.apk 생성됨
이 파일을 실제 안드로이드 기기에 복사해서 실행하면 설치 가능

App Bundle 만들기 (구글 플레이 배포용)
```
flutter clean
flutter pub get
flutter build appbundle --release
```
build/app/outputs/bundle/release/app-release.aab 생성됨
이건 보통 구글 플레이 스토어에 업로드할 때 사용
