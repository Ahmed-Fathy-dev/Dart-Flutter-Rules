# Flutter Agent Rules - Setup Script (PowerShell)
# Quick setup for Remote Rules System

$ErrorActionPreference = "Stop"

# Repository URL
$REPO_URL = "https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main"

# Print header
Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Blue
Write-Host "   Flutter Agent Rules - Remote Setup" -ForegroundColor Blue
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Blue
Write-Host ""

# Check if .cascade exists
if (Test-Path ".cascade") {
    Write-Host "⚠️  .cascade folder already exists" -ForegroundColor Yellow
    $overwrite = Read-Host "Overwrite? (y/n)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-Host "❌ Setup cancelled" -ForegroundColor Red
        exit 1
    }
}

# Create folder structure
Write-Host "📁 Creating folder structure..." -ForegroundColor Blue
New-Item -ItemType Directory -Force -Path ".cascade\cache" | Out-Null
New-Item -ItemType Directory -Force -Path ".cascade\overrides" | Out-Null

# Ask for template
Write-Host ""
Write-Host "Choose a template:" -ForegroundColor Green
Write-Host "  1) Minimal     - Small projects, basic features"
Write-Host "  2) Standard    - Medium projects (recommended) ⭐"
Write-Host "  3) Full        - Large enterprise projects"
Write-Host "  4) Custom      - Customizable template (advanced)"
Write-Host "  5) URL         - Download from custom URL"
Write-Host ""
$template_choice = Read-Host "Enter choice (1-5)"

switch ($template_choice) {
    "1" {
        $TEMPLATE = "manifest-minimal.yaml"
        Write-Host "✓ Selected: Minimal" -ForegroundColor Green
    }
    "2" {
        $TEMPLATE = "manifest-standard.yaml"
        Write-Host "✓ Selected: Standard (recommended)" -ForegroundColor Green
    }
    "3" {
        $TEMPLATE = "manifest-full.yaml"
        Write-Host "✓ Selected: Full" -ForegroundColor Green
    }
    "4" {
        $TEMPLATE = "manifest-custom-example.yaml"
        Write-Host "✓ Selected: Custom (you can edit it after)" -ForegroundColor Green
    }
    "5" {
        Write-Host ""
        $CUSTOM_URL = Read-Host "Enter manifest URL"
        if ($CUSTOM_URL) {
            $MANIFEST_URL = $CUSTOM_URL
            Write-Host "✓ Using custom URL" -ForegroundColor Green
        } else {
            Write-Host "No URL provided, using Standard" -ForegroundColor Yellow
            $TEMPLATE = "manifest-standard.yaml"
        }
    }
    default {
        Write-Host "Invalid choice, using Standard" -ForegroundColor Yellow
        $TEMPLATE = "manifest-standard.yaml"
    }
}

# Download manifest
Write-Host "📥 Downloading manifest template..." -ForegroundColor Blue
if (-not $MANIFEST_URL) {
    $MANIFEST_URL = "$REPO_URL/templates/$TEMPLATE"
}

try {
    Invoke-WebRequest -Uri $MANIFEST_URL -OutFile ".cascade\rules-manifest.yaml"
    Write-Host "✓ Manifest downloaded" -ForegroundColor Green
}
catch {
    Write-Host "❌ Failed to download manifest" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Create .gitignore if needed
if (-not (Test-Path ".cascade\.gitignore")) {
    Write-Host "📝 Creating .gitignore..." -ForegroundColor Blue
    @"
# Cache (don't commit)
cache/

# Overrides (commit these!)
# !overrides/
"@ | Out-File -FilePath ".cascade\.gitignore" -Encoding UTF8
    Write-Host "✓ .gitignore created" -ForegroundColor Green
}

# Create example override file
Write-Host "📝 Creating example override..." -ForegroundColor Blue
@"
# Custom project rules (optional)
# Uncomment and edit as needed

# custom_instructions: |
#   Your custom instructions here...
#   
#   Example:
#   - Always use code generation for Riverpod
#   - Prefer GoRouter over AutoRoute
#   - Use feature-based architecture strictly

# Override specific recommendations
# state_management:
#   prefer: riverpod
#   avoid: [getx]

# navigation:
#   prefer: go_router
#   type_safety: required
"@ | Out-File -FilePath ".cascade\overrides\example.yaml" -Encoding UTF8
Write-Host "✓ Example override created" -ForegroundColor Green

# Print success message
Write-Host ""
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Green
Write-Host "            ✅ Setup Complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""

Write-Host "What was created:" -ForegroundColor Blue
Write-Host "  📁 .cascade\"
Write-Host "     ├── rules-manifest.yaml  (your config)"
Write-Host "     ├── cache\               (auto-generated)"
Write-Host "     ├── overrides\"
Write-Host "     │   └── example.yaml     (custom rules)"
Write-Host "     └── .gitignore"

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Blue
Write-Host "  1. Review .cascade\rules-manifest.yaml"
Write-Host "  2. Customize what you need"
Write-Host "  3. (Optional) Add custom rules in .cascade\overrides\"
Write-Host "  4. Your AI agent will read from GitHub automatically!"

Write-Host ""
Write-Host "Quick customization:" -ForegroundColor Blue
Write-Host "  " -NoNewline
Write-Host "code .cascade\rules-manifest.yaml" -ForegroundColor Yellow

Write-Host ""
Write-Host "Documentation:" -ForegroundColor Blue
Write-Host "  📖 Remote Usage: $REPO_URL/REMOTE-USAGE.md"
Write-Host "  🤖 AI Integration: $REPO_URL/AI-INTEGRATION.md"

Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Green
