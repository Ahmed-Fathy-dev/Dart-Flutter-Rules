#!/bin/bash

# Flutter Agent Rules - Setup Script
# Quick setup for Remote Rules System

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Repository URL
REPO_URL="https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main"

# Print header
echo -e "${BLUE}"
echo "═══════════════════════════════════════════════"
echo "   Flutter Agent Rules - Remote Setup"
echo "═══════════════════════════════════════════════"
echo -e "${NC}"

# Check if .cascade exists
if [ -d ".cascade" ]; then
    echo -e "${YELLOW}⚠️  .cascade folder already exists${NC}"
    read -p "Overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}❌ Setup cancelled${NC}"
        exit 1
    fi
fi

# Create folder structure
echo -e "${BLUE}📁 Creating folder structure...${NC}"
mkdir -p .cascade/cache
mkdir -p .cascade/overrides

# Ask for template
echo ""
echo -e "${GREEN}Choose a template:${NC}"
echo "  1) Minimal     - Small projects, basic features"
echo "  2) Standard    - Medium projects (recommended) ⭐"
echo "  3) Full        - Large enterprise projects"
echo "  4) Custom      - Customizable template (advanced)"
echo "  5) URL         - Download from custom URL"
echo ""
read -p "Enter choice (1-5): " template_choice

case $template_choice in
    1)
        TEMPLATE="manifest-minimal.yaml"
        echo -e "${GREEN}✓ Selected: Minimal${NC}"
        ;;
    2)
        TEMPLATE="manifest-standard.yaml"
        echo -e "${GREEN}✓ Selected: Standard (recommended)${NC}"
        ;;
    3)
        TEMPLATE="manifest-full.yaml"
        echo -e "${GREEN}✓ Selected: Full${NC}"
        ;;
    4)
        TEMPLATE="manifest-custom-example.yaml"
        echo -e "${GREEN}✓ Selected: Custom (you can edit it after)${NC}"
        ;;
    5)
        echo ""
        read -p "Enter manifest URL: " CUSTOM_URL
        if [ -n "$CUSTOM_URL" ]; then
            MANIFEST_URL="$CUSTOM_URL"
            echo -e "${GREEN}✓ Using custom URL${NC}"
        else
            echo -e "${YELLOW}No URL provided, using Standard${NC}"
            TEMPLATE="manifest-standard.yaml"
        fi
        ;;
    *)
        echo -e "${YELLOW}Invalid choice, using Standard${NC}"
        TEMPLATE="manifest-standard.yaml"
        ;;
esac

# Download manifest
echo -e "${BLUE}📥 Downloading manifest template...${NC}"
if [ -z "$MANIFEST_URL" ]; then
    MANIFEST_URL="${REPO_URL}/templates/${TEMPLATE}"
fi

if command -v curl &> /dev/null; then
    curl -sf -o .cascade/rules-manifest.yaml "$MANIFEST_URL"
elif command -v wget &> /dev/null; then
    wget -q -O .cascade/rules-manifest.yaml "$MANIFEST_URL"
else
    echo -e "${RED}❌ Error: curl or wget not found${NC}"
    exit 1
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Manifest downloaded${NC}"
else
    echo -e "${RED}❌ Failed to download manifest${NC}"
    exit 1
fi

# Create .gitignore if needed
if [ ! -f ".cascade/.gitignore" ]; then
    echo -e "${BLUE}📝 Creating .gitignore...${NC}"
    cat > .cascade/.gitignore << 'EOF'
# Cache (don't commit)
cache/

# Overrides (commit these!)
# !overrides/
EOF
    echo -e "${GREEN}✓ .gitignore created${NC}"
fi

# Create example override file
echo -e "${BLUE}📝 Creating example override...${NC}"
cat > .cascade/overrides/example.yaml << 'EOF'
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
EOF
echo -e "${GREEN}✓ Example override created${NC}"

# Print success message
echo ""
echo -e "${GREEN}"
echo "═══════════════════════════════════════════════"
echo "            ✅ Setup Complete!"
echo "═══════════════════════════════════════════════"
echo -e "${NC}"

echo -e "${BLUE}What was created:${NC}"
echo "  📁 .cascade/"
echo "     ├── rules-manifest.yaml  (your config)"
echo "     ├── cache/               (auto-generated)"
echo "     ├── overrides/"
echo "     │   └── example.yaml     (custom rules)"
echo "     └── .gitignore"

echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Review .cascade/rules-manifest.yaml"
echo "  2. Customize what you need"
echo "  3. (Optional) Add custom rules in .cascade/overrides/"
echo "  4. Your AI agent will read from GitHub automatically!"

echo ""
echo -e "${BLUE}Quick customization:${NC}"
echo "  ${YELLOW}code .cascade/rules-manifest.yaml${NC}"

echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  📖 Remote Usage: ${REPO_URL}/REMOTE-USAGE.md"
echo "  🤖 AI Integration: ${REPO_URL}/AI-INTEGRATION.md"

echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
