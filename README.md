# 🚀 Android Antigravity Workflows

Bộ workflows chuẩn hóa cho Antigravity Agent, giúp tự động hóa quy trình phát triển ứng dụng Android tại Infinity Technologies Global.

## 📥 Cài đặt nhanh

### 🍎 Mac / Linux
Chạy lệnh sau trong Terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Infinity-Technologies-Global/Android-Antigravity-Workflows/main/install.sh)"
```

### 🪟 Windows (PowerShell)
Chạy lệnh sau trong PowerShell:

```powershell
irm https://raw.githubusercontent.com/Infinity-Technologies-Global/Android-Antigravity-Workflows/main/install.ps1 | iex
```

Sau khi cài đặt xong, hãy restart Antigravity hoặc IDE để workflows có hiệu lực.

## 🎨 Hướng dẫn Reskin (/reskin)

Workflow `/reskin` giúp tự động hóa việc thay đổi Package Name, App Name, và Ads IDs.

### Cách dùng:

Gõ lệnh sau vào chat với Antigravity:

```text
@[/reskin] Package Name: com.infinity.videomaker
App Name: Video Maker Pro
Adjust Token: abc123xyz789
Facebook App ID: 1234567890123456
Facebook Client Token: a1b2c3d4e5f6g7h8
```

⚠️ **Lưu ý**: Thay thế các giá trị trên bằng thông tin thực tế của dự án mới.

### Chức năng của /reskin:
1. Tự động backup project hiện tại.
2. Đổi Application ID & Namespace trong `build.gradle`.
3. Cập nhật `google-services.json`.
4. Cập nhật Ads IDs trong `id_ads.xml`.
5. Đổi tên App trong `strings.xml`.
6. Refactor cấu trúc folder (`main`, `test`, `androidTest`) theo package mới.
7. Cập nhật package declarations và imports toàn project.
8. Cập nhật `AndroidManifest.xml`.
9. **Cập nhật ProGuard Rules** (`proguard-rules.pro`).
10. Fix lỗi lint thường gặp (ví dụ: `MissingTranslation`).
11. Tự động Build Debug APK để kiểm tra.
12. Commit code lên git.

## 📋 Danh sách Workflows khác

- **/audit**: 🏥 Kiểm tra code & bảo mật
- **/code**: 💻 Viết code theo Spec
- **/debug**: 🐞 Sửa lỗi & Debug
- **/deploy**: 🚀 Deploy lên Production
- **/init**: ✨ Tạo dự án mới
- **/plan**: 📝 Thiết kế tính năng
- **/recap**: 🧠 Tóm tắt dự án
- **/refactor**: 🧹 Dọn dẹp & tối ưu code
- **/rollback**: ⏪ Quay lại phiên bản cũ
- **/run**: ▶️ Chạy ứng dụng
- **/test**: ✅ Chạy kiểm thử
- **/visualize**: 🎨 Thiết kế giao diện
- **/cloudflare-tunnel**: 🌐 Quản lý Cloudflare Tunnel

## 🗺️ Roadmap (Phiên bản tiếp theo)

- [ ] **/implementation_ads**: 💰 Tự động gắn quảng cáo (AdMob, Applovin, etc.) vào code theo kịch bản có sẵn.
- [ ] **/change_icon**: 🖼️ Tự động resize và thay đổi icon app cho tất cả các mật độ màn hình (mipmap/drawable).

## ☕ Tác giả

**Ynsuper**
<br>
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-yellow.svg)](https://buymeacoffee.com/ynsuper)
