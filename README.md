# 🚀 Android Antigravity Workflows

Bộ workflows chuẩn hóa cho Antigravity Agent, giúp tự động hóa quy trình phát triển ứng dụng Android tại Infinity Technologies Global.

## 📥 Cài đặt (Build Workflows)

Để cài đặt bộ workflows này cho Antigravity của bạn, hãy chạy lệnh sau:

```bash
# Backup workflows cũ (nếu có)
mv ~/.gemini/antigravity/global_workflows ~/.gemini/antigravity/global_workflows_backup_$(date +%s) 2>/dev/null || true

# Clone workflows mới
git clone git@github.com:Infinity-Technologies-Global/Android-Antigravity-Workflows.git ~/.gemini/antigravity/global_workflows
```

Sau khi chạy xong, restart Antigravity hoặc IDE để workflows mới có hiệu lực.

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
