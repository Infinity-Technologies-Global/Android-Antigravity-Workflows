---
description: 🎨 Reskin ứng dụng Android (Linh hoạt) - Đổi Package, Name, Ads tùy theo input
---

# 🎨 Workflow Reskin Ứng Dụng Android (Flexible)

Workflow này giúp reskin ứng dụng Android linh hoạt.
**Cơ chế**: "Có gì làm nấy" - Chỉ thực hiện các thay đổi dựa trên thông tin người dùng cung cấp.

## 📋 Bước 1: Thu thập thông tin

Yêu cầu người dùng cung cấp các thông tin mong muốn thay đổi (Tất cả đều là **OPTIONAL**):

1. **Package Name mới** (ví dụ: `com.infinity.videomaker`)
2. **App Name** (ví dụ: `Video Maker Pro`)
3. **Ads Config**:
   - Adjust Token
   - Facebook App ID
   - Facebook Client Token

## 📋 Bước 2: Xác định phạm vi công việc

Kiểm tra thông tin đã nhập để xác định các bước cần làm:

- **Biến `HAS_PACKAGE`**: True nếu có Package Name mới.
- **Biến `HAS_NAME`**: True nếu có App Name mới.
- **Biến `HAS_ADS`**: True nếu có bất kỳ thông tin Ads nào (Adjust/Facebook).

## 📋 Bước 3: Backup project (Luôn thực hiện)

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity
git add -A
git commit -m "Backup before reskin operation" --allow-empty
git branch backup-reskin-$(date +%Y%m%d-%H%M%S)
```

---

# 📦 PHẦN 1: THAY ĐỔI PACKAGE NAME
**⚠️ Điều kiện**: Chỉ thực hiện nếu `HAS_PACKAGE` is True.

## 📋 Bước 4: Cập nhật build.gradle (Package)

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/app/build.gradle`:
1. `applicationId` -> `[NEW_PACKAGE_NAME]`
2. `namespace` -> `[NEW_PACKAGE_NAME]`

## 📋 Bước 5: Cập nhật google-services.json (Package)

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/app/google-services.json`:
- `"package_name"` -> `[NEW_PACKAGE_NAME]`

## 📋 Bước 6: Đổi tên folder package (Package)

Thực hiện đổi cấu trúc thư mục cho `main`, `test`, và `androidTest`:

```bash
# Xác định thông tin
OLD_PACKAGE="[OLD_PACKAGE_DETECTED]" # Agent tự detect package cũ
NEW_PACKAGE="[NEW_PACKAGE_NAME]"

# Convert to path
OLD_PATH=$(echo $OLD_PACKAGE | tr '.' '/')
NEW_PATH=$(echo $NEW_PACKAGE | tr '.' '/')

# 1. Main
cd /Users/ducanh/Project/Infinity/Base-Infinity/app/src/main/java
mkdir -p $NEW_PATH
cp -r $OLD_PATH/* $NEW_PATH/
rm -rf $(echo $OLD_PACKAGE | cut -d'.' -f1)/$(echo $OLD_PACKAGE | cut -d'.' -f2) # Xóa folder cũ an toàn
find . -type d -empty -delete 2>/dev/null || true

# 2. Test
cd /Users/ducanh/Project/Infinity/Base-Infinity/app/src/test/java
mkdir -p $NEW_PATH
cp -r $OLD_PATH/* $NEW_PATH/
rm -rf $(echo $OLD_PACKAGE | cut -d'.' -f1)/$(echo $OLD_PACKAGE | cut -d'.' -f2)
find . -type d -empty -delete 2>/dev/null || true

# 3. AndroidTest
cd /Users/ducanh/Project/Infinity/Base-Infinity/app/src/androidTest/java
mkdir -p $NEW_PATH
cp -r $OLD_PATH/* $NEW_PATH/
rm -rf $(echo $OLD_PACKAGE | cut -d'.' -f1)/$(echo $OLD_PACKAGE | cut -d'.' -f2)
find . -type d -empty -delete 2>/dev/null || true
```

## 📋 Bước 7: Cập nhật Package Declarations & Imports (Package)

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity

# Replace Package Declaration
find app/src -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i '' "s/package [OLD_PACKAGE_DETECTED]/package [NEW_PACKAGE_NAME]/g" {} +

# Replace Import Statements
find app/src -type f \( -name "*.kt" -o -name "*.java" -o -name "*.xml" \) -exec sed -i '' "s/[OLD_PACKAGE_DETECTED]/[NEW_PACKAGE_NAME]/g" {} +
```

## 📋 Bước 8: Cập nhật AndroidManifest & ProGuard (Package)

1. **AndroidManifest.xml**: Replace package cũ bằng mới.
2. **proguard-rules.pro**:
   ```bash
   sed -i '' "s/[OLD_PACKAGE_DETECTED]/[NEW_PACKAGE_NAME]/g" app/proguard-rules.pro
   ```

---

# 📱 PHẦN 2: THAY ĐỔI APP NAME
**⚠️ Điều kiện**: Chỉ thực hiện nếu `HAS_NAME` is True.

## 📋 Bước 9: Cập nhật App Name

Cập nhật file `/Users/ducanh/Project/Infinity/Base-Infinity/app/src/main/res/values/strings.xml`:
- Tìm `<string name="app_name">`
- Thay nội dung bằng `[APP_NAME]`

---

# 🔧 PHẦN 3: THAY ĐỔI ADS ID
**⚠️ Điều kiện**: Chỉ thực hiện nếu `HAS_ADS` is True (và có giá trị tương ứng).

## 📋 Bước 10: Cập nhật Ads Config

Cập nhật `/Users/ducanh/Project/Infinity/Base-Infinity/app/src/main/res/values/id_ads.xml`:

- Nếu có **Adjust Token** -> Update `adjust_token`
- Nếu có **Facebook App ID** -> Update `facebook_app_id`
- Nếu có **Facebook Client Token** -> Update `facebook_client_token`

---

# ✅ PHẦN 4: HOÀN TẤT & BUILD (Luôn thực hiện)

## 📋 Bước 11: Fix lỗi Lint (Auto-Fix)

Cập nhật `/Users/ducanh/Project/Infinity/Base-Infinity/crash_screen/src/main/res/values/strings.xml`:
- Thêm `translatable="false"` cho `error_share` nếu chưa có.

## 📋 Bước 12: Build & Verify

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity
chmod +x gradlew
./gradlew clean

# Build Debug cho nhanh
./gradlew assembleDebug
```

## 📋 Bước 13: Commit Changes

```bash
cd /Users/ducanh/Project/Infinity/Base-Infinity
git add -A
git commit -m "Reskin applied: Package=${HAS_PACKAGE} Name=${HAS_NAME} Ads=${HAS_ADS}"
```

## ✅ Kết thúc
Thông báo lại cho người dùng những thay đổi đã thực hiện.
