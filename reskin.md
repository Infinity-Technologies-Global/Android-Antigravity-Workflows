---
description: 🎨 Reskin ứng dụng Android - Đổi package, namespace, ads ID
---

# 🎨 Workflow Reskin Ứng Dụng Android

Workflow này giúp reskin ứng dụng Android bằng cách thay đổi:
- Package name và namespace
- Cấu trúc folder Java/Kotlin
- Import statements trong toàn bộ code
- Ads IDs (Adjust, Facebook)
- Google Services configuration

## 📋 Bước 1: Thu thập thông tin từ người dùng

Yêu cầu người dùng cung cấp các thông tin sau:

1. **Package Name mới** (ví dụ: `com.infinity.videomaker`)
   - Format: com.xxx.yyy (3 phần tối thiểu)
   - Chỉ chứa chữ thường, số và dấu chấm
   
2. **App Name** (tên ứng dụng hiển thị, ví dụ: `Video Maker Pro`)

3. **Adjust Token** (từ Adjust Dashboard, ví dụ: `abc123xyz789`)

4. **Facebook App ID** (từ Facebook Developer Console, ví dụ: `1234567890123456`)

5. **Facebook Client Token** (từ Facebook Developer Console, ví dụ: `a1b2c3d4e5f6g7h8`)

**LƯU Ý**: Không tiếp tục nếu thiếu bất kỳ thông tin nào. Tất cả thông tin đều bắt buộc.

## 📋 Bước 2: Validate thông tin

Kiểm tra các thông tin đã nhập:
- Package name phải đúng format (com.xxx.yyy)
- Facebook App ID phải là số
- Không có giá trị nào là placeholder hoặc để trống

Nếu validation fail, yêu cầu người dùng nhập lại.

## 📋 Bước 3: Backup project hiện tại

```bash
# Tạo backup trước khi reskin
cd /Users/ducanh/Project/Infinity/Base-Infinity
git add -A
git commit -m "Backup before reskin to [NEW_PACKAGE_NAME]"
git branch backup-$(date +%Y%m%d-%H%M%S)
```

**Thay [NEW_PACKAGE_NAME]** bằng package name mới người dùng cung cấp.

## 📋 Bước 4: Cập nhật build.gradle

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/app/build.gradle`:

1. Dòng 15: `applicationId "com.itg.template"` → `applicationId "[NEW_PACKAGE_NAME]"`
2. Dòng 86: `namespace 'com.itg.template'` → `namespace '[NEW_PACKAGE_NAME]'`

Sử dụng tool `multi_replace_file_content` để thay đổi các dòng này trong một lần gọi.

## 📋 Bước 5: Cập nhật google-services.json

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/app/google-services.json`:
- Dòng 12: `"package_name": "com.itg.template"` → `"package_name": "[NEW_PACKAGE_NAME]"`

## 📋 Bước 6: Cập nhật id_ads.xml

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/app/src/main/res/values/id_ads.xml`:

1. Dòng 3: adjust_token
2. Dòng 4: facebook_app_id
3. Dòng 5: facebook_client_token

Sử dụng tool `multi_replace_file_content`.

## 📋 Bước 7: Cập nhật app name trong strings.xml

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/app/src/main/res/values/strings.xml`:
- Tìm `<string name="app_name">` và thay bằng App Name mới

## 📋 Bước 8: Đổi tên folder package (main, test, androidTest)

```bash
# Di chuyển folder main/java
cd /Users/ducanh/Project/Infinity/Base-Infinity/app/src/main/java
mkdir -p com/infinity/videomaker
cp -r com/itg/template/* com/infinity/videomaker/
rm -rf com/itg/template
find com -type d -empty -delete 2>/dev/null || true

# Di chuyển folder test/java
cd /Users/ducanh/Project/Infinity/Base-Infinity/app/src/test/java
mkdir -p com/infinity/videomaker
cp -r com/itg/template/* com/infinity/videomaker/
rm -rf com/itg/template
find com -type d -empty -delete 2>/dev/null || true

# Di chuyển folder androidTest/java
cd /Users/ducanh/Project/Infinity/Base-Infinity/app/src/androidTest/java
mkdir -p com/infinity/videomaker
cp -r com/itg/template/* com/infinity/videomaker/
rm -rf com/itg/template
find com -type d -empty -delete 2>/dev/null || true
```

**Thay package paths** bằng package name thực tế (chuyển dots thành slashes).

## 📋 Bước 9: Cập nhật package declarations trong tất cả file Kotlin/Java

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity

# Tìm và thay thế package declaration trong main
find app/src/main/java -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i '' 's/package com\.itg\.template/package [NEW_PACKAGE_NAME]/g' {} +

# Tìm và thay thế package declaration trong test
find app/src/test/java -type f -name "*.kt" -exec sed -i '' 's/package com\.itg\.template/package [NEW_PACKAGE_NAME]/g' {} +

# Tìm và thay thế package declaration trong androidTest
find app/src/androidTest/java -type f -name "*.kt" -exec sed -i '' 's/package com\.itg\.template/package [NEW_PACKAGE_NAME]/g' {} +
```

**Thay [NEW_PACKAGE_NAME]** bằng package name thực tế.

## 📋 Bước 10: Cập nhật import statements

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity

# Tìm và thay thế import statements
find app/src -type f \( -name "*.kt" -o -name "*.java" -o -name "*.xml" \) -exec sed -i '' 's/com\.itg\.template/[NEW_PACKAGE_NAME]/g' {} +
```

**Thay [NEW_PACKAGE_NAME]** bằng package name thực tế.

## 📋 Bước 11: Cập nhật AndroidManifest.xml

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity

# Cập nhật package name trong manifest
find app/src/main -name "AndroidManifest.xml" -exec sed -i '' 's/com\.itg\.template/[NEW_PACKAGE_NAME]/g' {} +
```

**Thay [NEW_PACKAGE_NAME]** bằng package name thực tế.

## 📋 Bước 11.5: Cập nhật proguard-rules.pro

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/app/proguard-rules.pro`:
- Tìm dòng `-keep class com.itg.template.ads.AdUnitConfig`
- Thay bằng `-keep class [NEW_PACKAGE_NAME].ads.AdUnitConfig`

Hoặc sử dụng sed:
```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity
sed -i '' 's/com\.itg\.template/[NEW_PACKAGE_NAME]/g' app/proguard-rules.pro
```

**Thay [NEW_PACKAGE_NAME]** bằng package name thực tế.

## 📋 Bước 12: Fix lint errors trong crash_screen module

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/crash_screen/src/main/res/values/strings.xml`:
- Tìm dòng `<string name="error_share">Share</string>`
- Thay bằng `<string name="error_share" translatable="false">Share</string>`

Đây là lỗi lint MissingTranslation cần fix trước khi build.

## 📋 Bước 13: Clean và Build production APK

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity

# Đảm bảo gradlew có quyền execute
chmod +x gradlew

# Clean build cache
./gradlew clean

# Build Debug APK (nhanh hơn Release)
./gradlew assembleDebug

# HOẶC Build Release nếu cần export (tốn thời gian hơn)
# ./gradlew assembleRelease -x test
```

**LƯU Ý**: 
- Build Debug sẽ nhanh hơn để verify
- File APK sẽ nằm trong `app/build/outputs/apk/debug/`
- Nếu build Release, file APK sẽ ở `app/build/outputs/apk/release/`

## 📋 Bước 14: Verify kết quả

Kiểm tra các thay đổi:

1. ✅ Package name đã được cập nhật trong build.gradle
2. ✅ Namespace đã được cập nhật trong build.gradle
3. ✅ Package name đã được cập nhật trong google-services.json
4. ✅ Folder structure đã thay đổi theo package name mới
5. ✅ Package declarations đã được cập nhật
6. ✅ Import statements đã được cập nhật
7. ✅ Ads IDs (Adjust, Facebook) đã được cập nhật
8. ✅ App name đã được cập nhật
9. ✅ Project build thành công

Hiển thị tóm tắt các thay đổi cho người dùng.

## 📋 Bước 15: Commit changes

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity

git add -A
git commit -m "Reskin app: [NEW_PACKAGE_NAME] - [APP_NAME]"
```

**Thay [NEW_PACKAGE_NAME]** và **[APP_NAME]** bằng giá trị thực tế.

## ✅ Hoàn thành

Thông báo cho người dùng:
- ✅ Reskin hoàn tất
- 📦 Package name: [NEW_PACKAGE_NAME]
- 📱 App name: [APP_NAME]
- ✅ Build thành công
- 💾 Đã commit changes

Lưu ý: Người dùng cần đồng bộ project với Android Studio và test lại ứng dụng.

## 🔄 Rollback (nếu cần)

Nếu có lỗi, có thể rollback:

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity
git reset --hard HEAD~1
git checkout master
```
