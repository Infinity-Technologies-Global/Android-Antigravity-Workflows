---
description: 🎨 Reskin ứng dụng Android (Full) - Phân tích UI, Design System, Đổi Package/Name/Ads, Reskin Drawable & PNG, Kiểm tra bản quyền, Xóa nền (rembg), Icon App, Lint & Build
---

# 🎨 Workflow Reskin Ứng Dụng Android (Full Edition)

Workflow reskin toàn diện cho ứng dụng Android.
**Cơ chế**: "Phân tích → Thiết kế → Thực thi → Xác minh" - Tự động phân tích UI, tạo Design System, reskin toàn bộ drawable, PNG, icon app và rebuild.

---

## 🔎 Bước 0: Kiểm tra điều kiện chạy (Prerequisites Check)

> **⚠️ BẮT BUỘC**: Phải pass TẤT CẢ kiểm tra trước khi tiếp tục. Nếu fail → thông báo user và DỪNG LẠI.

### 0.1. Kiểm tra Android Project
```bash
cd [PROJECT_ROOT]

# Phải có build.gradle hoặc build.gradle.kts
ls app/build.gradle* 2>/dev/null || echo "❌ FAIL: Không tìm thấy app/build.gradle"

# Phải có AndroidManifest.xml
ls app/src/main/AndroidManifest.xml 2>/dev/null || echo "❌ FAIL: Không tìm thấy AndroidManifest.xml"

# Phải có res/values/
ls app/src/main/res/values/ 2>/dev/null || echo "❌ FAIL: Không tìm thấy res/values/"
```

### 0.2. Kiểm tra Git
```bash
git --version 2>/dev/null || echo "❌ FAIL: Git chưa cài"
```

### 0.3. Kiểm tra rembg (cho xóa nền)
```bash
python3 -c "from rembg import remove; print('✅ rembg OK')" 2>/dev/null || echo "⚠️ WARN: rembg chưa cài — bỏ qua bước xóa nền. Cài bằng: pip install 'rembg[cli]' Pillow"
```

### 0.4. Kiểm tra sips (resize icon - macOS)
```bash
which sips 2>/dev/null && echo "✅ sips OK" || echo "⚠️ WARN: sips không có — dùng cách khác để resize icon"
```

### 0.5. Kiểm tra Gradle Wrapper
```bash
ls [PROJECT_ROOT]/gradlew 2>/dev/null && echo "✅ gradlew OK" || echo "⚠️ WARN: gradlew không có — bỏ qua bước Lint & Build"
```

### 0.6. Kiểm tra generate_image tool
Agent tự kiểm tra: tool `generate_image` có sẵn hay không. Nếu không → thông báo user.

### 0.7. Tổng kết Prerequisites

Agent tạo bảng kết quả:

| # | Thành phần | Trạng thái | Ghi chú |
|---|-----------|:----------:|---------|
| 1 | Android Project | ✅/❌ | build.gradle + AndroidManifest |
| 2 | Git | ✅/❌ | Backup & commit |
| 3 | rembg | ✅/⚠️ | Xóa nền (optional) |
| 4 | sips | ✅/⚠️ | Resize icon (macOS) |
| 5 | gradlew | ✅/⚠️ | Lint & Build (optional) |
| 6 | generate_image | ✅/❌ | Gen ảnh PNG + Icon |

**Quy tắc:**
- ❌ ở mục 1, 2, 6 → **DỪNG LẠI**, yêu cầu user fix
- ⚠️ ở mục 3, 4, 5 → **Tiếp tục**, bỏ qua bước tương ứng

---

## 📋 Bước 1: Thu thập thông tin

Yêu cầu người dùng cung cấp **CHỦ ĐỀ / THEME** cho ứng dụng reskin (ví dụ: "Galaxy Space", "Nature Green", "Neon Cyber").

Các thông tin bổ sung (tất cả **OPTIONAL** - agent sẽ **tự động suy luận** nếu không cung cấp):

1. **Package Name mới** → Nếu không cung cấp, agent TỰ TẠO dựa trên chủ đề (ví dụ: theme "Galaxy Space" → `com.galaxy.spacemaker`)
2. **App Name** → Nếu không cung cấp, agent TỰ TẠO dựa trên chủ đề
3. **Ads Config** (Optional):
   - Adjust Token
   - Facebook App ID
   - Facebook Client Token
4. **Bảng màu tùy chỉnh** → Nếu không cung cấp, agent tự thiết kế dựa trên chủ đề

## 📋 Bước 2: Xác định phạm vi công việc

Kiểm tra thông tin để xác định các flags:

- **`THEME`**: Chủ đề reskin (LUÔN CÓ)
- **`HAS_PACKAGE`**: True (luôn true - tự tạo nếu user không cung cấp)
- **`HAS_NAME`**: True (luôn true - tự tạo nếu user không cung cấp)
- **`HAS_ADS`**: True nếu có bất kỳ thông tin Ads nào
- **`HAS_CUSTOM_COLORS`**: True nếu user cung cấp bảng màu riêng

## 📋 Bước 3: Backup Project (Luôn thực hiện)

```bash
cd [PROJECT_ROOT]

# Kiểm tra xem đã có git chưa, nếu chưa thì init
if [ ! -d ".git" ]; then
  git init
  git add -A
  git commit -m "Initial commit before reskin"
fi

git add -A
git commit -m "Backup before full reskin: [THEME]" --allow-empty
git branch backup-reskin-$(date +%Y%m%d-%H%M%S)
```

---

# 🔍 PHẦN 0: PHÂN TÍCH UI ỨNG DỤNG (Luôn thực hiện)

## 📋 Bước 4: Quét và phân tích cấu trúc UI

Agent thực hiện quét toàn bộ source code để hiểu cấu trúc UI:

### 4.1. Tìm tất cả Activity
```bash
cd [PROJECT_ROOT]
# Tìm tất cả Activity classes
find app/src/main -type f -name "*.kt" -o -name "*.java" | xargs grep -l "AppCompatActivity\|FragmentActivity\|ComponentActivity\|Activity()" 2>/dev/null
```

### 4.2. Tìm tất cả Fragment
```bash
# Tìm tất cả Fragment classes
find app/src/main -type f -name "*.kt" -o -name "*.java" | xargs grep -l "Fragment()\|DialogFragment\|BottomSheetDialogFragment" 2>/dev/null
```

### 4.3. Tìm tất cả Compose Screens
```bash
# Tìm tất cả Compose screens (nếu có)
find app/src/main -type f -name "*.kt" | xargs grep -l "@Composable\|setContent\|ComposeView" 2>/dev/null
```

### 4.4. Phân tích Theme & Colors hiện tại
```bash
# Tìm file theme hiện tại
find app/src/main/res -name "themes.xml" -o -name "styles.xml" -o -name "colors.xml" | head -20

# Tìm Compose Theme (nếu có)
find app/src/main -name "*Theme*" -o -name "*Color*" | grep -E "\.kt$" | head -20
```

### 4.5. Liệt kê tất cả Drawable resources
```bash
# Đếm và liệt kê drawable
find app/src/main/res/drawable* -type f | head -50
ls -la app/src/main/res/drawable*/
```

### 4.6. Tạo báo cáo phân tích
Agent tạo một summary ngắn gọn gồm:
- Danh sách Activity (tên + layout XML liên kết)
- Danh sách Fragment (tên + layout XML liên kết)
- Compose screens (nếu có)
- Bảng màu hiện tại (Primary, Secondary, Background, Surface, Text colors)
- Danh sách drawable PNG cần reskin
- Danh sách drawable XML cần đổi màu

---

# 🎨 PHẦN 1: TẠO DESIGN SYSTEM

## 📋 Bước 5: Thiết kế Design System theo chủ đề

Dựa trên **THEME** và kết quả phân tích UI ở Bước 4, agent tạo **Design System** gồm:

### 5.1. Bảng màu chính (Color Palette)

Agent thiết kế bảng màu **6-8 màu** phù hợp chủ đề:

| Token              | Mô tả                         | Ví dụ (Theme: Galaxy Space) |
|---------------------|-------------------------------|------------------------------|
| `colorPrimary`     | Màu chủ đạo                    | `#6C63FF` (Cosmic Purple)   |
| `colorPrimaryDark` | Màu chủ đạo tối               | `#4A42D6`                    |
| `colorAccent`      | Màu nhấn                      | `#00D9FF` (Neon Cyan)       |
| `colorBackground`  | Nền chính                      | `#0D0B2E` (Deep Space)      |
| `colorSurface`     | Nền card/surface              | `#1A1745`                    |
| `colorOnPrimary`   | Text trên primary             | `#FFFFFF`                    |
| `colorOnBackground`| Text trên background          | `#E0E0FF`                    |
| `colorSecondary`   | Màu phụ                       | `#FF6B9D` (Nebula Pink)     |

### 5.2. Cập nhật `colors.xml`

File: `app/src/main/res/values/colors.xml`

Thay thế hoặc thêm các color tokens theo bảng màu đã thiết kế. **Giữ nguyên** các color khác không liên quan đến theme (ví dụ: ad colors, error colors).

### 5.3. Cập nhật `themes.xml` / `styles.xml`

File: `app/src/main/res/values/themes.xml` (hoặc `styles.xml`)

Cập nhật các thuộc tính theme để sử dụng color tokens mới:
- `colorPrimary`, `colorPrimaryVariant`, `colorOnPrimary`
- `colorSecondary`, `colorSecondaryVariant`, `colorOnSecondary`
- `android:colorBackground`, `android:statusBarColor`, `android:navigationBarColor`

### 5.4. Cập nhật Compose Theme (nếu có)

Nếu ứng dụng dùng Compose, cập nhật file `Color.kt` và `Theme.kt`:
- Thay đổi các color values trong `Color.kt`
- Cập nhật `lightColorScheme()` / `darkColorScheme()` trong `Theme.kt`

---

# 🖌️ PHẦN 2: RESKIN DRAWABLE XML

## 📋 Bước 6: Đổi màu Drawable XML theo Design System

### 6.1. Tìm tất cả drawable XML sử dụng hardcoded colors
```bash
cd [PROJECT_ROOT]
# Tìm XML drawable có hardcoded colors
find app/src/main/res/drawable* -name "*.xml" -exec grep -l "#[0-9a-fA-F]\{3,8\}" {} \;
```

### 6.2. Thay thế màu trong drawable XML

Với mỗi file XML drawable tìm được:

1. **Đọc file** để hiểu mục đích (background, button, icon, gradient, v.v.)
2. **Map màu cũ → màu mới** theo Design System:
   - Màu primary cũ → `@color/colorPrimary` mới
   - Màu accent cũ → `@color/colorAccent` mới
   - Màu background cũ → `@color/colorBackground` mới
   - Gradient: Đổi startColor/endColor phù hợp theme
3. **Ưu tiên dùng `@color/` reference** thay vì hardcode hex, để dễ maintain sau này
4. **Giữ nguyên** shape, corners, stroke width - chỉ đổi màu

### 6.3. Xử lý gradient drawables

Với các gradient drawable, thiết kế gradient mới phù hợp theme:
- Đảm bảo gradient từ `colorPrimary` → `colorPrimaryDark` hoặc `colorPrimary` → `colorAccent`
- Giữ nguyên angle, type (linear/radial)

---

# 🖼️ PHẦN 3: RESKIN PNG IMAGES

## 📋 Bước 7: Tạo lại ảnh PNG cho Drawable

### 7.1. Liệt kê tất cả PNG cần reskin
```bash
cd [PROJECT_ROOT]
# Tìm tất cả PNG trong drawable
find app/src/main/res/drawable* -name "*.png" -type f | sort
find app/src/main/res/mipmap* -name "*.png" -o -name "*.webp" | grep -v "ic_launcher" | sort
```

### 7.2. Phân loại PNG

Agent phân loại PNG thành các nhóm:
- **Icons/UI Elements**: Các icon nhỏ dùng trong UI (button icons, menu icons)
- **Backgrounds**: Ảnh nền, splash, onboarding backgrounds
- **Illustrations**: Ảnh minh họa, empty state, tutorial images
- **Decorations**: Border, divider, overlay effects

### 7.3. Tạo ảnh mới bằng generate_image

> **🌐 BỎ QUA các icon ngôn ngữ/quốc kỳ — KHÔNG reskin:**
> - `ic_flag_*`, `flag_*`, `ic_lang_*`, `ic_language_*`
> - ISO codes: `ic_en`, `ic_vi`, `ic_ja`, `ic_ko`, `ic_zh`, `ic_fr`, `ic_de`, `ic_es`, `ic_pt`, `ic_ru`, `ic_ar`, `ic_hi`, `ic_th`, `ic_id`, `ic_ms`, `ic_tr`, `ic_pl`, `ic_nl`, `ic_sv`, `ic_da`, `ic_fi`, `ic_nb`, `ic_cs`, `ic_hu`, `ic_ro`, `ic_uk`, `ic_he`, `ic_bn`, `ic_ta`, `ic_te`, `ic_mr`
> - Country/language names: `ic_brazil`, `ic_english`, `ic_french`, `ic_german`, `ic_spanish`, `ic_portuguese`, `ic_russian`, `ic_chinese`, `ic_japanese`, `ic_korean`, `ic_vietnamese`, `ic_thai`, `ic_arabic`, `ic_hindi`, `ic_indonesian`, `ic_turkish`, `ic_italian`, `ic_dutch`, `ic_swedish`, `ic_polish`, `ic_czech`, `ic_hungarian`, `ic_romanian`, `ic_greek`, `ic_hebrew`, `ic_persian`, `ic_bengali`, `ic_tamil`, `ic_telugu`, `ic_marathi`, `ic_filipino`, `ic_malay`, v.v.
> - Các tên kết thúc bằng `_flag`, `_language`

Với **MỖI PNG** cần reskin (trừ các icon ngôn ngữ trên):

1. **Xem ảnh gốc** bằng `view_file` để hiểu nội dung
2. **Tạo prompt cho generate_image** theo công thức:

   ```
   Prompt = "[Mô tả nội dung ảnh gốc] in [THEME] style.
   Colors: [Design System colors].
   Size: [width]x[height] pixels.
   Style: [flat/gradient/3D] matching Android drawable.
   Background: transparent (nếu icon) hoặc [color] (nếu background).
   No text, clean design, suitable for mobile app UI."
   ```

3. **Generate ảnh mới** bằng tool `generate_image`
4. **Copy ảnh vào đúng vị trí** drawable folder, ghi đè file cũ

> **⚠️ Lưu ý quan trọng:**
> - Giữ nguyên tên file
> - Giữ nguyên kích thước tương đối (có thể resize nếu cần)
> - Nếu có nhiều density folders (drawable-hdpi, drawable-xhdpi, v.v.), tạo cho folder chính và copy sang các folder khác
> - Ảnh icon nên có transparent background
> - Ảnh background nên match với colorBackground trong Design System

---

# 🛡️ PHẦN 3.5: KIỂM TRA BẢN QUYỀN ẢNH (Copyright Audit)

## 📋 Bước 7.5: Quét và xử lý ảnh vi phạm bản quyền

> **⚠️ QUAN TRỌNG**: Bước này **BẮT BUỘC** để tránh bị takedown trên Google Play do vi phạm bản quyền.

### 7.5.1. Quét toàn bộ ảnh trong drawable

Agent xem **từng file ảnh** (`*.png`, `*.webp`) trong tất cả các thư mục drawable bằng `view_file` và kiểm tra:

**Danh sách vi phạm cần tìm:**
- **Nintendo**: Logo, text "Nintendo", "GAME BOY", "GAME BOY ADVANCE", "NINTENDO DS", "SUPER NINTENDO", "FAMICOM", "N64"
- **Mario**: Mario, Luigi, Peach, Yoshi, Toad, Goomba, Koopa, Bowser, Mario mushroom (nấm đỏ/xanh), Mario star (ngôi sao có mắt), Mario coin, Mario pipe (ống xanh), Mario question block (?), Mario fire flower
- **Pac-Man**: Pac-Man, ghosts (Blinky, Pinky, Inky, Clyde)
- **Các IP khác**: Sonic, Pokémon, Zelda, Kirby, Mega Man, Tetris
- **Thiết bị có brand**: Game Boy shape rõ ràng, NDS shape, SNES controller shape cụ thể

**Cách kiểm tra:**
```
Với mỗi file ảnh:
1. view_file để xem nội dung ảnh
2. Phân loại: ✅ SAFE / ⚠️ BORDERLINE / ❌ VIOLATION
3. Nếu VIOLATION: Ghi nhận tên file + lý do
```

### 7.5.2. Regenerate ảnh vi phạm

Với mỗi ảnh bị đánh dấu **❌ VIOLATION**:

1. **Xác định mục đích** của ảnh gốc (icon console, tutorial, decoration, v.v.)
2. **Tạo prompt cho generate_image** theo nguyên tắc:
   ```
   Prompt = "3D rendered [mô tả chức năng ảnh], [THEME] colors,
   NO brand names NO logos NO text NO copyrighted characters,
   generic design, white clean background,
   high quality 3D claymation style render"
   ```

   **Quy tắc prompt:**
   - Console icons → Dùng "generic portable/home gaming console/device" thay vì tên cụ thể
   - KHÔNG dùng: "Nintendo", "Game Boy", "Mario", "Pac-Man", "SNES", "NDS", "Famicom"
   - KHÔNG dùng: "mushroom with eyes", "star with face", "question mark block"
   - Thay bằng: generic game controller, abstract game cartridge, simple geometric shapes

3. **Generate ảnh mới** bằng `generate_image`
4. **Copy ghi đè** vào đúng vị trí file cũ

### 7.5.3. Tạo báo cáo bản quyền

Agent tạo bảng tổng kết:

| # | File | Vấn đề | Trạng thái |
|---|------|--------|-----------|
| 1 | `ic_gba.webp` | "GAME BOY ADVANCE" text, Mario characters | ✅ Đã thay thế |
| 2 | `ic_nes.webp` | "FAMICOM", "SUPER MARIO BROS" text | ✅ Đã thay thế |
| ... | ... | ... | ... |

---

# 🧹 PHẦN 3.6: XÓA NỀN ẢNH (Background Removal)

## 📋 Bước 7.6: Xóa nền cho tất cả ảnh drawable

> **⚠️ YÊU CẦU**: Phải cài `rembg` trước khi chạy bước này.

### 7.6.1. Kiểm tra và cài đặt rembg

```bash
# Kiểm tra đã cài chưa
python3 -c "from rembg import remove; print('✅ rembg OK')" 2>/dev/null

# Nếu chưa cài, chạy:
python3 -m pip install "rembg[cli]" Pillow
```

> **Lưu ý**: Phải cài `rembg[cli]` (có `[cli]`) để có đầy đủ CLI. Nếu dùng Python 3.9 (macOS system), có thể gặp lỗi `numba`/`gradio`. Giải pháp:
> - Cài Python 3.12+: `brew install python@3.12` rồi dùng `python3.12`
> - Hoặc dùng script Python trực tiếp (bỏ qua CLI, xem bên dưới)

### 7.6.2. Tạo script xóa nền (tương thích mọi Python version)

```bash
cat > /tmp/remove_bg.py << 'SCRIPT'
import sys, os, io

# Bypass gradio import issue (Python 3.9 compatibility)
sys.modules['gradio'] = type(sys)('gradio')

from rembg import remove
from PIL import Image

input_dir = sys.argv[1]
files = [f for f in os.listdir(input_dir) if f.endswith(('.webp', '.png')) and not f.startswith('.')]
total = len(files)

for i, f in enumerate(files, 1):
    path = os.path.join(input_dir, f)
    print(f"[{i}/{total}] {f}...", flush=True)
    try:
        with open(path, 'rb') as inp:
            result = remove(inp.read())
        ext = f.rsplit('.', 1)[-1].upper()
        if ext == 'WEBP':
            Image.open(io.BytesIO(result)).save(path, 'WEBP')
        else:
            with open(path, 'wb') as out:
                out.write(result)
        print(f"  ✅ OK")
    except Exception as e:
        print(f"  ❌ Error: {e}")

print(f"\n🎉 Done! Processed {total} files.")
SCRIPT
```

### 7.6.3. Chạy xóa nền cho tất cả drawable directories

```bash
# Xóa nền cho designsystem drawable (nếu có)
if [ -d "[PROJECT_ROOT]/core/designsystem/src/main/res/drawable" ]; then
  echo "📂 Processing designsystem drawable..."
  python3 /tmp/remove_bg.py [PROJECT_ROOT]/core/designsystem/src/main/res/drawable
fi

# Xóa nền cho app drawable
if [ -d "[PROJECT_ROOT]/app/src/main/res/drawable" ]; then
  echo "📂 Processing app drawable..."
  python3 /tmp/remove_bg.py [PROJECT_ROOT]/app/src/main/res/drawable
fi

# Xóa nền cho các module drawable khác (nếu có)
find [PROJECT_ROOT] -path "*/src/main/res/drawable" -type d | while read dir; do
  echo "📂 Processing $dir..."
  python3 /tmp/remove_bg.py "$dir"
done
```

> **⚠️ Lưu ý:**
> - Lần chạy đầu tiên sẽ tải model `u2net.onnx` (~176MB), lưu tại `~/.u2net/`
> - Mỗi ảnh mất ~5-15 giây tùy kích thước
> - Ảnh đã có nền trong suốt sẽ giữ nguyên (không bị hỏng)
> - Không xóa nền cho ảnh XML drawable (chỉ PNG/WebP)

---

# 🏷️ PHẦN 4: TẠO APP ICON

## 📋 Bước 8: Tạo và thay thế App Icon

### 8.1. Tạo App Icon mới

Tạo icon đại diện cho ứng dụng theo theme:

```
Prompt cho generate_image:
"App icon for [APP_NAME] - [THEME] theme.
Modern Android adaptive icon style.
Primary color: [colorPrimary]. Accent: [colorAccent].
Clean, minimal, professional design.
Square icon with rounded corners potential.
No text unless app name is very short.
1024x1024 pixels, high quality."
```

### 8.2. Tạo các kích thước icon

Sử dụng `sips` (macOS) để tạo các kích thước cần thiết:

```bash
# Từ icon gốc 1024x1024
ICON_SOURCE="[path_to_generated_icon]"

# mipmap-mdpi (48x48)
sips -z 48 48 "$ICON_SOURCE" --out app/src/main/res/mipmap-mdpi/ic_launcher.png
sips -z 48 48 "$ICON_SOURCE" --out app/src/main/res/mipmap-mdpi/ic_launcher_round.png

# mipmap-hdpi (72x72)
sips -z 72 72 "$ICON_SOURCE" --out app/src/main/res/mipmap-hdpi/ic_launcher.png
sips -z 72 72 "$ICON_SOURCE" --out app/src/main/res/mipmap-hdpi/ic_launcher_round.png

# mipmap-xhdpi (96x96)
sips -z 96 96 "$ICON_SOURCE" --out app/src/main/res/mipmap-xhdpi/ic_launcher.png
sips -z 96 96 "$ICON_SOURCE" --out app/src/main/res/mipmap-xhdpi/ic_launcher_round.png

# mipmap-xxhdpi (144x144)
sips -z 144 144 "$ICON_SOURCE" --out app/src/main/res/mipmap-xxhdpi/ic_launcher.png
sips -z 144 144 "$ICON_SOURCE" --out app/src/main/res/mipmap-xxhdpi/ic_launcher_round.png

# mipmap-xxxhdpi (192x192)
sips -z 192 192 "$ICON_SOURCE" --out app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
sips -z 192 192 "$ICON_SOURCE" --out app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png
```

### 8.3. Cập nhật Adaptive Icon (nếu có)

Nếu dự án dùng Adaptive Icon (`ic_launcher_foreground.xml`, `ic_launcher_background.xml`):
- Cập nhật `ic_launcher_background.xml` với `colorPrimary` hoặc `colorBackground` mới
- Tạo `ic_launcher_foreground.png` mới với thiết kế phù hợp theme

---

# 📦 PHẦN 5: THAY ĐỔI PACKAGE NAME (Luôn thực hiện)

## 📋 Bước 9: Cập nhật build.gradle

Cập nhật file `[PROJECT_ROOT]/app/build.gradle`:
1. `applicationId` → `[NEW_PACKAGE_NAME]`
2. `namespace` → `[NEW_PACKAGE_NAME]`

## 📋 Bước 10: Cập nhật google-services.json

Cập nhật `[PROJECT_ROOT]/app/google-services.json`:
- `"package_name"` → `[NEW_PACKAGE_NAME]`

## 📋 Bước 11: Đổi tên folder package

```bash
OLD_PACKAGE="[OLD_PACKAGE_DETECTED]"  # Agent tự detect
NEW_PACKAGE="[NEW_PACKAGE_NAME]"

OLD_PATH=$(echo $OLD_PACKAGE | tr '.' '/')
NEW_PATH=$(echo $NEW_PACKAGE | tr '.' '/')

# Main source
cd [PROJECT_ROOT]/app/src/main/java
mkdir -p $NEW_PATH
cp -r $OLD_PATH/* $NEW_PATH/
rm -rf $(echo $OLD_PACKAGE | cut -d'.' -f1)/$(echo $OLD_PACKAGE | cut -d'.' -f2)
find . -type d -empty -delete 2>/dev/null || true

# Test source
cd [PROJECT_ROOT]/app/src/test/java
if [ -d "$OLD_PATH" ]; then
  mkdir -p $NEW_PATH
  cp -r $OLD_PATH/* $NEW_PATH/
  rm -rf $(echo $OLD_PACKAGE | cut -d'.' -f1)/$(echo $OLD_PACKAGE | cut -d'.' -f2)
  find . -type d -empty -delete 2>/dev/null || true
fi

# AndroidTest source
cd [PROJECT_ROOT]/app/src/androidTest/java
if [ -d "$OLD_PATH" ]; then
  mkdir -p $NEW_PATH
  cp -r $OLD_PATH/* $NEW_PATH/
  rm -rf $(echo $OLD_PACKAGE | cut -d'.' -f1)/$(echo $OLD_PACKAGE | cut -d'.' -f2)
  find . -type d -empty -delete 2>/dev/null || true
fi
```

## 📋 Bước 12: Cập nhật Package Declarations & Imports

```bash
cd [PROJECT_ROOT]

# Replace Package Declaration in Kotlin/Java files
find app/src -type f \( -name "*.kt" -o -name "*.java" \) -exec sed -i '' "s/package $OLD_PACKAGE/package $NEW_PACKAGE/g" {} +

# Replace all import/reference statements
find app/src -type f \( -name "*.kt" -o -name "*.java" -o -name "*.xml" \) -exec sed -i '' "s/$OLD_PACKAGE/$NEW_PACKAGE/g" {} +
```

## 📋 Bước 13: Cập nhật AndroidManifest & ProGuard

1. **AndroidManifest.xml**: Replace package cũ bằng mới
2. **proguard-rules.pro**:
   ```bash
   sed -i '' "s/$OLD_PACKAGE/$NEW_PACKAGE/g" app/proguard-rules.pro
   ```

---

# 📱 PHẦN 6: THAY ĐỔI APP NAME (Luôn thực hiện)

## 📋 Bước 14: Cập nhật App Name

Cập nhật `[PROJECT_ROOT]/app/src/main/res/values/strings.xml`:
- Tìm `<string name="app_name">`
- Thay nội dung bằng `[APP_NAME]`

---

# 🔧 PHẦN 7: THAY ĐỔI ADS CONFIG
**⚠️ Điều kiện**: Chỉ thực hiện nếu `HAS_ADS` is True.

## 📋 Bước 15: Cập nhật Ads Config

Cập nhật `[PROJECT_ROOT]/app/src/main/res/values/id_ads.xml`:

- Nếu có **Adjust Token** → Update `adjust_token`
- Nếu có **Facebook App ID** → Update `facebook_app_id`
- Nếu có **Facebook Client Token** → Update `facebook_client_token`

---

# ✅ PHẦN 8: LINT, BUILD & COMMIT (Luôn thực hiện)

## 📋 Bước 16: Fix lỗi Lint (Auto-Fix)

### 16.1. Chạy Lint check
```bash
cd [PROJECT_ROOT]
chmod +x gradlew
./gradlew lintDebug 2>&1 | tail -30
```

### 16.2. Fix lỗi phổ biến tự động
- **Hardcoded strings**: Thêm `translatable="false"` cho strings không cần dịch
- **Missing content description**: Thêm `contentDescription` cho ImageView
- **Unused imports**: Xóa imports thừa sau khi đổi package
- **Duplicate resources**: Xóa resource trùng lặp

### 16.3. Fix crash_screen strings (nếu có)
```bash
# Fix lỗi strings trong crash_screen module (nếu tồn tại)
if [ -f "[PROJECT_ROOT]/crash_screen/src/main/res/values/strings.xml" ]; then
  # Thêm translatable="false" cho error_share nếu chưa có
  sed -i '' 's/<string name="error_share">/<string name="error_share" translatable="false">/g' \
    [PROJECT_ROOT]/crash_screen/src/main/res/values/strings.xml
fi
```

## 📋 Bước 17: Build & Verify

```bash
cd [PROJECT_ROOT]
./gradlew clean

# Build Debug
./gradlew assembleDebug
```

Nếu build lỗi:
1. Đọc error log
2. Fix lỗi tự động (import sai, resource missing, v.v.)
3. Build lại cho đến khi thành công

## 📋 Bước 18: Commit Changes

```bash
cd [PROJECT_ROOT]
git add -A
git commit -m "Full reskin: Theme=[THEME] Package=[NEW_PACKAGE] Name=[APP_NAME]"
```

---

## ✅ Kết thúc

Tạo báo cáo tổng kết cho người dùng gồm:

| Hạng mục            | Chi tiết                              |
|----------------------|---------------------------------------|
| 🎨 Theme            | [THEME]                               |
| 📦 Package Name     | [OLD] → [NEW]                         |
| 📱 App Name          | [OLD] → [NEW]                         |
| 🎨 Design System     | [Số color tokens] colors defined      |
| 🖌️ Drawable XML      | [Số file] files updated               |
| 🖼️ PNG Images         | [Số file] images regenerated          |
| 🛡️ Copyright Audit   | [Số ảnh vi phạm] found → replaced     |
| 🧹 Background Remove | [Số ảnh] processed with rembg          |
| 🏷️ App Icon           | ✅ All densities created              |
| 🔧 Ads               | [Updated / Skipped]                   |
| ✅ Build              | [Success / Failed with details]       |
| 📝 Commit            | [commit hash]                         |
