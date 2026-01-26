# Antigravity Skill Installer for implementation_ad

$SkillName = "implementation_ad"
$SkillDir = "$HOME\.gemini\antigravity\skills\$SkillName"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗"
Write-Host "║   🚀 Antigravity Skill Installer: $SkillName         ║"
Write-Host "╚══════════════════════════════════════════════════════════╝"
Write-Host ""

if (!(Test-Path -Path $SkillDir)) {
    New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
}
Write-Host "✅ Skill Path: $SkillDir"

Write-Host "⏳ Installing skill files..."

if (Test-Path -Path "SKILL.md") {
    Copy-Item -Path ".\" -Destination $SkillDir -Recurse -Force
    Write-Host "✅ Copied files to $SkillDir"
    Write-Host ""
    Write-Host "🎉 Skill '$SkillName' has been installed globally."
} else {
    Write-Host "❌ Error: Please run this script from the '$SkillName' root directory."
    Exit 1
}
Write-Host ""
