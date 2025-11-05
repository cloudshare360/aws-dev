#!/bin/bash

# GitHub Pages Navigation Test Script
echo "🧪 Testing GitHub Pages Site Structure and Navigation"
echo "======================================================"

# Test main site
echo "🌐 Testing main site..."
if curl -s https://cloudshare360.github.io/aws-dev/ | grep -q "AWS Learning Hub"; then
    echo "✅ Main site is working"
else
    echo "❌ Main site failed - checking local files"
    if [ -f "index.html" ]; then
        echo "✅ index.html exists locally"
        if grep -q "AWS Learning Hub" index.html; then
            echo "✅ index.html contains expected content"
        else
            echo "❌ index.html missing expected content"
        fi
    else
        echo "❌ index.html not found"
    fi
fi

# Check file structure
echo ""
echo "📁 Checking file structure..."
echo "Required files:"
[ -f "index.html" ] && echo "✅ index.html" || echo "❌ index.html"
[ -f "_config.yml" ] && echo "✅ _config.yml" || echo "❌ _config.yml"
[ -f ".nojekyll" ] && echo "✅ .nojekyll" || echo "❌ .nojekyll"
[ -d "AWS-Abhishek-Veeramalla" ] && echo "✅ AWS-Abhishek-Veeramalla/" || echo "❌ AWS-Abhishek-Veeramalla/"

# Check diagram directories
echo ""
echo "📊 Checking diagram directories..."
[ -d "AWS-Abhishek-Veeramalla/day-6-route53/diagrams" ] && echo "✅ Basic diagrams directory" || echo "❌ Basic diagrams directory"
[ -d "AWS-Abhishek-Veeramalla/day-6-route53/diagrams-enhanced" ] && echo "✅ Enhanced diagrams directory" || echo "❌ Enhanced diagrams directory"

# Check diagram files
echo ""
echo "📝 Checking diagram files..."
diagram_files=(
    "AWS-Abhishek-Veeramalla/day-6-route53/diagrams/README.md"
    "AWS-Abhishek-Veeramalla/day-6-route53/diagrams/01-route53-overview.md"
    "AWS-Abhishek-Veeramalla/day-6-route53/diagrams-enhanced/README.md"
    "AWS-Abhishek-Veeramalla/day-6-route53/diagrams-enhanced/01-route53-overview.md"
)

for file in "${diagram_files[@]}"; do
    [ -f "$file" ] && echo "✅ $file" || echo "❌ $file"
done

# Test navigation links in index.html
echo ""
echo "🔗 Testing navigation links in index.html..."
if [ -f "index.html" ]; then
    # Check for basic navigation elements
    grep -q "AWS-Abhishek-Veeramalla/day-6-route53/diagrams/" index.html && echo "✅ Basic diagrams link found" || echo "❌ Basic diagrams link missing"
    grep -q "AWS-Abhishek-Veeramalla/day-6-route53/diagrams-enhanced/" index.html && echo "✅ Enhanced diagrams link found" || echo "❌ Enhanced diagrams link missing"
    grep -q "AWS-Abhishek-Veeramalla/day-6-route53/notebook-nlm/" index.html && echo "✅ Original notes link found" || echo "❌ Original notes link missing"
fi

# Check GitHub Actions workflow
echo ""
echo "⚙️ Checking GitHub Actions setup..."
[ -f ".github/workflows/pages.yml" ] && echo "✅ GitHub Actions workflow exists" || echo "❌ GitHub Actions workflow missing"

# Test GitHub Pages deployment status
echo ""
echo "🚀 Testing GitHub Pages deployment..."
echo "Checking if GitHub Pages is enabled..."

# Check if site responds (might take time for first deployment)
response=$(curl -s -o /dev/null -w "%{http_code}" https://cloudshare360.github.io/aws-dev/ 2>/dev/null)
case $response in
    200)
        echo "✅ Site is live and responding (HTTP 200)"
        ;;
    404)
        echo "⚠️  Site returning 404 - GitHub Pages might not be enabled or still deploying"
        echo "   Go to: https://github.com/cloudshare360/aws-dev/settings/pages"
        echo "   Enable GitHub Pages with source: GitHub Actions"
        ;;
    *)
        echo "⚠️  Unexpected response code: $response"
        ;;
esac

# Local test option
echo ""
echo "🧪 Local testing option:"
echo "To test locally, run: python3 -m http.server 8000"
echo "Then visit: http://localhost:8000/"

echo ""
echo "📊 Test Summary:"
echo "=================="
echo "If you see ❌ for the main site but ✅ for local files,"
echo "the issue is with GitHub Pages configuration, not the content."
echo ""
echo "Next steps if site is not working:"
echo "1. Enable GitHub Pages in repository settings"
echo "2. Wait 5-10 minutes for deployment"
echo "3. Check GitHub Actions tab for deployment status"
echo "4. Clear browser cache and try again"