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

## 💼 For Professionals (Dành cho chuyên gia)

Follow this process for optimal results (Tuân thủ quy trình này để đạt hiệu quả tối ưu):

### 1. Planning Phase (Lập kế hoạch)
- **/init**: 
  - EN: Setup new project structure & git.
  - VI: Khởi tạo dự án mới & git.
- **/recap**: 
  - EN: Start day. AI reads .brain to restore context.
  - VI: Đầu ngày làm việc. AI đọc .brain để nhớ lại ngữ cảnh.
- **/plan** (CRITICAL): 
  - Input: `/plan Add Stripe Payment`
  - Action: Read DB & Docs -> Write docs/specs/payment.md.
  - Benefit: **Approve logic BEFORE coding** (Duyệt logic trước khi code).

### 2. Construction Phase (Xây dựng)
- **/visualize**:
  - EN: Designer Mode. Generate UI/Components.
  - VI: Tạo giao diện UI/UX.
- **/code** (CRITICAL):
  - Input: `/code Implement payment based on spec`
  - Action: Write Code + Unit Test + Security Check.
  - Benefit: **Clean & Safe Code** (Code sạch và an toàn).

### 3. Operations Phase (Vận hành)
- **/debug**: "Sherlock Holmes Mode". Find Root Cause (Tìm nguyên nhân gốc rễ).
- **/audit**: Health check & Security scan (Kiểm tra sức khỏe dự án).
- **/deploy**: Dockerize & Production setup (Đóng gói lên Production).

### 4. Memory (Bộ nhớ)
- **/save-brain**:
  - EN: Save comprehensive context to .brain.
  - VI: Lưu toàn bộ kiến thức vào file .brain.
  - **Tip**: You can clear chat history after saving! (Có thể xoá chat sau khi lưu).

## 📋 Danh sách Workflows chi tiết

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

## 💰 Tự động gán quảng cáo (/implementation_ad)

Workflow hỗ trợ tự động tích hợp quảng cáo vào dự án Android (AdMob).

### Cách dùng:
Gõ lệnh sau vào chat hoặc dùng lệnh `/implementation_ad`:

```text
/implementation_ad
interstitial inter_splash ca-app-pub-xxx/yyy
banner banner_splash ca-app-pub-xxx/zzz
native native_home ca-app-pub-xxx/aaa
```

#### Chức năng:
1. **Cập nhật Config**: Tự động điền Real ID vào `ad_config.json` và Test ID Google vào `ad_config_debug.json`.
2. **Setup Code**: Tự động sinh code Kotlin cho `AdsManager`, `AdRemoteConfig` dựa trên các key mà bạn cung cấp.

---

## 🗺️ Roadmap (Phiên bản tiếp theo)

- [x] **/implementation_ads**: 💰 Tự động gắn quảng cáo (AdMob, Applovin, etc.) vào code theo kịch bản có sẵn.
- [ ] **/change_icon**: 🖼️ Tự động resize và thay đổi icon app cho tất cả các mật độ màn hình (mipmap/drawable).

## ☕ Tác giả

**Ynsuper**
<br>
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-yellow.svg)](https://buymeacoffee.com/ynsuper)
