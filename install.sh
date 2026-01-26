#!/bin/bash
# Android Antigravity Workflows Installer for Mac/Linux

REPO_BASE="https://raw.githubusercontent.com/Infinity-Technologies-Global/Android-Antigravity-Workflows/main"

# Workflows List
WORKFLOWS=(
    "audit.md" "cloudflare-tunnel.md" "code.md" "debug.md" 
    "deploy.md" "init.md" "plan.md" "recap.md" 
    "refactor.md" "reskin.md" "rollback.md" "run.md" 
    "save_brain.md" "test.md" "visualize.md"
)

# Schemas and Templates
SCHEMAS=(
    "brain.schema.json" "session.schema.json" "preferences.schema.json"
)
TEMPLATES=(
    "brain.example.json" "session.example.json" "preferences.example.json"
)

# Detect paths
ANTIGRAVITY_GLOBAL="$HOME/.gemini/antigravity/global_workflows"
SCHEMAS_DIR="$HOME/.gemini/antigravity/schemas"
TEMPLATES_DIR="$HOME/.gemini/antigravity/templates"
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
    # WORKFLOWS ARE NOW IN 'workflows' COMMAND IN GIT
    if curl -f -s -o "$ANTIGRAVITY_GLOBAL/$wf" "$REPO_BASE/workflows/$wf"; then
        echo "   ✅ $wf"
        ((success++))
    else
        echo "   ❌ $wf"
    fi
done

# 2. Cài Schemas
mkdir -p "$SCHEMAS_DIR"
echo "⏳ Đang tải schemas..."
for schema in "${SCHEMAS[@]}"; do
    if curl -f -s -o "$SCHEMAS_DIR/$schema" "$REPO_BASE/schemas/$schema"; then
        echo "   ✅ $schema"
        ((success++))
    else
        echo "   ❌ $schema"
    fi
done

# 3. Cài Templates
mkdir -p "$TEMPLATES_DIR"
echo "⏳ Đang tải templates..."
for template in "${TEMPLATES[@]}"; do
    if curl -f -s -o "$TEMPLATES_DIR/$template" "$REPO_BASE/templates/$template"; then
        echo "   ✅ $template"
        ((success++))
    else
        echo "   ❌ $template"
    fi
done

# 4. Cài Skills
SKILLS=("implementation_ad")
SKILLS_DIR="$HOME/.gemini/antigravity/skills"

echo "⏳ Đang tải skills..."
for skill in "${SKILLS[@]}"; do
    TARGET_SKILL_DIR="$SKILLS_DIR/$skill"
    TARGET_IMPL_DIR="$TARGET_SKILL_DIR/implementation"
    mkdir -p "$TARGET_IMPL_DIR"
    
    # Download SKILL.md
    if curl -f -s -o "$TARGET_SKILL_DIR/SKILL.md" "$REPO_BASE/skills/$skill/SKILL.md"; then
        echo "   ✅ $skill (SKILL.md)"
        ((success++))
    else
        echo "   ❌ $skill (SKILL.md)"
    fi
    
    # Download implementation files
    # Note: We need to know specific files or have a way to list them. 
    # For now, hardcoding the known files for implementation_ad is safest without directory listing API on raw github.
    # OR simpler: just download the install script and run it? No, repo structure is raw files.
    # Let's download the critical files we know exist.
    
    FILES=( "AdsManager.kt" "AdRemoteConfig.kt" "AdRemoteConfigExtensions.kt" )
    for f in "${FILES[@]}"; do
        if curl -f -s -o "$TARGET_IMPL_DIR/$f" "$REPO_BASE/skills/$skill/implementation/$f"; then
             # echo "      - $f" 
             true
        fi
    done
    
    # Download Install Scripts for future ref
    curl -f -s -o "$TARGET_SKILL_DIR/install.sh" "$REPO_BASE/skills/$skill/install.sh"
    curl -f -s -o "$TARGET_SKILL_DIR/install.ps1" "$REPO_BASE/skills/$skill/install.ps1"
    chmod +x "$TARGET_SKILL_DIR/install.sh"
done


# 5. Update Global Rules
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

## Resource Locations:
- Schemas: ~/.gemini/antigravity/schemas/
- Templates: ~/.gemini/antigravity/templates/

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
        echo "" # Placeholder
    fi
    echo "$AWF_INSTRUCTIONS" >> "$GEMINI_MD"
    echo "✅ Đã cập nhật Global Rules (GEMINI.md)"
fi

echo ""
echo "🎉 HOÀN TẤT! Đã cài $success workflows + Schemas & Templates."
echo "📂 Workflows: $ANTIGRAVITY_GLOBAL"
echo "📂 Schemas:   $SCHEMAS_DIR"
echo "📂 Templates: $TEMPLATES_DIR"
echo ""
