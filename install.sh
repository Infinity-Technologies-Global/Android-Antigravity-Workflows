#!/bin/bash
# Android Antigravity Workflows Installer for Mac/Linux

REPO_BASE="https://raw.githubusercontent.com/Infinity-Technologies-Global/Android-Antigravity-Workflows/main"
WORKFLOWS=(
    "audit.md" "cloudflare-tunnel.md" "code.md" "debug.md" 
    "deploy.md" "init.md" "plan.md" "recap.md" 
    "refactor.md" "reskin.md" "rollback.md" "run.md" 
    "save_brain.md" "test.md" "visualize.md" "README.md"
)

# Detect paths
ANTIGRAVITY_GLOBAL="$HOME/.gemini/antigravity/global_workflows"
GEMINI_MD="$HOME/.gemini/GEMINI.md"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║   🚀 Android Antigravity Workflows Installer             ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# 1. Cài Global Workflows
mkdir -p "$ANTIGRAVITY_GLOBAL"
echo "✅ Workflow Path: $ANTIGRAVITY_GLOBAL"

echo "⏳ Đang tải workflows..."
success=0
for wf in "${WORKFLOWS[@]}"; do
    if curl -f -s -o "$ANTIGRAVITY_GLOBAL/$wf" "$REPO_BASE/$wf"; then
        echo "   ✅ $wf"
        ((success++))
    else
        echo "   ❌ $wf"
    fi
done

# 2. Update Global Rules
AWF_INSTRUCTIONS='
# AWF - Antigravity Workflow Framework

## CRITICAL: Command Recognition
Khi user gõ các lệnh bắt đầu bằng `/` dưới đây, đây là AWF WORKFLOW COMMANDS.
Bạn PHẢI đọc file workflow tương ứng và thực hiện theo hướng dẫn trong đó.

## Command Mapping (QUAN TRỌNG):
| Command | Workflow File | Mô tả |
|---------|--------------|-------|
| `/reskin` | ~/.gemini/antigravity/global_workflows/reskin.md | 🎨 Reskin ứng dụng Android |
| `/plan` | ~/.gemini/antigravity/global_workflows/plan.md | 📝 Thiết kế tính năng |
| `/code` | ~/.gemini/antigravity/global_workflows/code.md | 💻 Viết code theo Spec |
| `/visualize` | ~/.gemini/antigravity/global_workflows/visualize.md | 🎨 Thiết kế giao diện |
| `/debug` | ~/.gemini/antigravity/global_workflows/debug.md | 🐞 Sửa lỗi & Debug |
| `/test` | ~/.gemini/antigravity/global_workflows/test.md | ✅ Chạy kiểm thử |
| `/run` | ~/.gemini/antigravity/global_workflows/run.md | ▶️ Chạy ứng dụng |
| `/deploy` | ~/.gemini/antigravity/global_workflows/deploy.md | 🚀 Deploy lên Production |
| `/init` | ~/.gemini/antigravity/global_workflows/init.md | ✨ Tạo dự án mới |
| `/recap` | ~/.gemini/antigravity/global_workflows/recap.md | 🧠 Tóm tắt dự án |
| `/save-brain` | ~/.gemini/antigravity/global_workflows/save_brain.md | 💾 Lưu kiến thức dự án |
| `/audit` | ~/.gemini/antigravity/global_workflows/audit.md | 🏥 Kiểm tra code & bảo mật |
| `/refactor` | ~/.gemini/antigravity/global_workflows/refactor.md | 🧹 Dọn dẹp & tối ưu code |
| `/rollback` | ~/.gemini/antigravity/global_workflows/rollback.md | ⏪ Quay lại phiên bản cũ |
| `/cloudflare-tunnel` | ~/.gemini/antigravity/global_workflows/cloudflare-tunnel.md | 🌐 Quản lý Cloudflare Tunnel |

## Hướng dẫn thực hiện:
1. Khi user gõ một trong các commands trên, ĐỌC FILE WORKFLOW tương ứng
2. Thực hiện TỪNG GIAI ĐOẠN trong workflow
3. KHÔNG tự ý bỏ qua bước nào
'

if [ ! -f "$GEMINI_MD" ]; then
    echo "$AWF_INSTRUCTIONS" > "$GEMINI_MD"
    echo "✅ Đã tạo Global Rules (GEMINI.md)"
else
    # Update section
    if grep -q "AWF - Antigravity Workflow Framework" "$GEMINI_MD"; then
        # Remove old section if exists (simple method: append new, user might need manual cleanup if strictly automated, but here we append/update)
        # Using a marker to replace would be better but simple append is safer than corrupting user file
        echo "" >> "$GEMINI_MD"
    fi
    # Just append for now to be safe, user can deduplicate
    echo "$AWF_INSTRUCTIONS" >> "$GEMINI_MD"
    echo "✅ Đã cập nhật Global Rules (GEMINI.md)"
fi

echo ""
echo "🎉 HOÀN TẤT! Đã cài $success workflows."
echo "📂 Location: $ANTIGRAVITY_GLOBAL"
echo ""
