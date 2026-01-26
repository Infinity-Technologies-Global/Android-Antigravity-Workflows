# Android Antigravity Workflows Installer for Windows
$RepoBase = "https://raw.githubusercontent.com/Infinity-Technologies-Global/Android-Antigravity-Workflows/main"

# Resources
# WORKFLOWS are now inside 'workflows/' folder in Git
$Workflows = @(
    "audit.md", "cloudflare-tunnel.md", "code.md", "debug.md", 
    "deploy.md", "init.md", "plan.md", "recap.md", 
    "refactor.md", "reskin.md", "rollback.md", "run.md", 
    "save_brain.md", "test.md", "visualize.md"
)
$Schemas = @("brain.schema.json", "session.schema.json", "preferences.schema.json")
$Templates = @("brain.example.json", "session.example.json", "preferences.example.json")

# Paths
$AntigravityGlobal = "$env:USERPROFILE\.gemini\antigravity\global_workflows"
$SchemasDir = "$env:USERPROFILE\.gemini\antigravity\schemas"
$TemplatesDir = "$env:USERPROFILE\.gemini\antigravity\templates"
$GeminiMd = "$env:USERPROFILE\.gemini\GEMINI.md"

Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   🚀 Android Antigravity Workflows Installer             ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 1. Cài Global Workflows
if (-not (Test-Path $AntigravityGlobal)) { New-Item -ItemType Directory -Force -Path $AntigravityGlobal | Out-Null }
Write-Host "✅ Workflow Path: $AntigravityGlobal" -ForegroundColor Green

Write-Host "⏳ Đang tải workflows..." -ForegroundColor Cyan
foreach ($wf in $Workflows) {
    try {
        Invoke-WebRequest -Uri "$RepoBase/workflows/$wf" -OutFile "$AntigravityGlobal\$wf" -ErrorAction Stop
        Write-Host "   ✅ $wf" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ $wf" -ForegroundColor Red
    }
}

# 2. Cài Schemas
if (-not (Test-Path $SchemasDir)) { New-Item -ItemType Directory -Force -Path $SchemasDir | Out-Null }
Write-Host "⏳ Đang tải schemas..." -ForegroundColor Cyan
foreach ($schema in $Schemas) {
    try {
        Invoke-WebRequest -Uri "$RepoBase/schemas/$schema" -OutFile "$SchemasDir\$schema" -ErrorAction Stop
        Write-Host "   ✅ $schema" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ $schema" -ForegroundColor Red
    }
}

# 3. Cài Templates
if (-not (Test-Path $TemplatesDir)) { New-Item -ItemType Directory -Force -Path $TemplatesDir | Out-Null }
Write-Host "⏳ Đang tải templates..." -ForegroundColor Cyan
foreach ($item in $Templates) {
    try {
        Invoke-WebRequest -Uri "$RepoBase/templates/$item" -OutFile "$TemplatesDir\$item" -ErrorAction Stop
        Write-Host "   ✅ $item" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ $item" -ForegroundColor Red
    }
}

# 4. Cài Skills
$Skills = @("implementation_ad")
$SkillsDir = "$env:USERPROFILE\.gemini\antigravity\skills"

Write-Host "⏳ Đang tải skills..." -ForegroundColor Cyan
foreach ($skill in $Skills) {
    $TargetSkillDir = "$SkillsDir\$skill"
    $TargetImplDir = "$TargetSkillDir\implementation"
    
    if (-not (Test-Path $TargetImplDir)) { New-Item -ItemType Directory -Force -Path $TargetImplDir | Out-Null }

    # Download SKILL.md
    try {
        Invoke-WebRequest -Uri "$RepoBase/skills/$skill/SKILL.md" -OutFile "$TargetSkillDir\SKILL.md" -ErrorAction Stop
        Write-Host "   ✅ $skill (SKILL.md)" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ $skill (SKILL.md)" -ForegroundColor Red
    }

    # Download implementation files
    $Files = @("AdsManager.kt", "AdRemoteConfig.kt", "AdRemoteConfigExtensions.kt")
    foreach ($f in $Files) {
        try {
            Invoke-WebRequest -Uri "$RepoBase/skills/$skill/implementation/$f" -OutFile "$TargetImplDir\$f" -ErrorAction SilentlyContinue
        } catch {
            # Implementation file might not exist, ignore
        }
    }

    # Download Install Scripts for future ref
    try { Invoke-WebRequest -Uri "$RepoBase/skills/$skill/install.sh" -OutFile "$TargetSkillDir\install.sh" -ErrorAction SilentlyContinue } catch {}
    try { Invoke-WebRequest -Uri "$RepoBase/skills/$skill/install.ps1" -OutFile "$TargetSkillDir\install.ps1" -ErrorAction SilentlyContinue } catch {}
}

# 5. Update Global Rules
$AwfInstructions = @"
# AWF - Antigravity Workflow Framework

## CRITICAL: Command Recognition
Khi user gõ các lệnh bắt đầu bằng ``/`` dưới đây, đây là AWF WORKFLOW COMMANDS.
Bạn PHẢI đọc file workflow tương ứng và thực hiện theo hướng dẫn trong đó.

## Command Mapping (QUAN TRỌNG):
| Command | Workflow File | Mô tả |
|---------|--------------|-------|
| ``/reskin`` | ~/.gemini/antigravity/global_workflows/reskin.md | 🎨 Reskin ứng dụng Android |
| ``/plan`` | ~/.gemini/antigravity/global_workflows/plan.md | 📝 Thiết kế tính năng |
| ``/code`` | ~/.gemini/antigravity/global_workflows/code.md | 💻 Viết code theo Spec |
| ``/visualize`` | ~/.gemini/antigravity/global_workflows/visualize.md | 🎨 Thiết kế giao diện |
| ``/debug`` | ~/.gemini/antigravity/global_workflows/debug.md | 🐞 Sửa lỗi & Debug |
| ``/test`` | ~/.gemini/antigravity/global_workflows/test.md | ✅ Chạy kiểm thử |
| ``/run`` | ~/.gemini/antigravity/global_workflows/run.md | ▶️ Chạy ứng dụng |
| ``/deploy`` | ~/.gemini/antigravity/global_workflows/deploy.md | 🚀 Deploy lên Production |
| ``/init`` | ~/.gemini/antigravity/global_workflows/init.md | ✨ Tạo dự án mới |
| ``/recap`` | ~/.gemini/antigravity/global_workflows/recap.md | 🧠 Tóm tắt dự án |
| ``/save-brain`` | ~/.gemini/antigravity/global_workflows/save_brain.md | 💾 Lưu kiến thức dự án |
| ``/audit`` | ~/.gemini/antigravity/global_workflows/audit.md | 🏥 Kiểm tra code & bảo mật |
| ``/refactor`` | ~/.gemini/antigravity/global_workflows/refactor.md | 🧹 Dọn dẹp & tối ưu code |
| ``/rollback`` | ~/.gemini/antigravity/global_workflows/rollback.md | ⏪ Quay lại phiên bản cũ |
| ``/cloudflare-tunnel`` | ~/.gemini/antigravity/global_workflows/cloudflare-tunnel.md | 🌐 Quản lý Cloudflare Tunnel |
| ``/implementation_ad`` | ~/.gemini/antigravity/skills/implementation_ad/SKILL.md | 💰 Tự động gán quảng cáo |

## Resource Locations:
- Schemas: ~/.gemini/antigravity/schemas/
- Templates: ~/.gemini/antigravity/templates/

## Hướng dẫn thực hiện:
1. Khi user gõ một trong các commands trên, ĐỌC FILE WORKFLOW tương ứng
2. Thực hiện TỪNG GIAI ĐOẠN trong workflow
3. KHÔNG tự ý bỏ qua bước nào
"@

if (-not (Test-Path $GeminiMd)) {
    Set-Content -Path $GeminiMd -Value $AwfInstructions -Encoding UTF8
    Write-Host "✅ Đã tạo Global Rules (GEMINI.md)" -ForegroundColor Green
} else {
    Add-Content -Path $GeminiMd -Value "`n$AwfInstructions" -Encoding UTF8
    Write-Host "✅ Đã cập nhật Global Rules (GEMINI.md)" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 HOÀN TẤT! Đã cài workflows + resources." -ForegroundColor Yellow
Write-Host "📂 Location: $AntigravityGlobal" -ForegroundColor Cyan
Write-Host ""
