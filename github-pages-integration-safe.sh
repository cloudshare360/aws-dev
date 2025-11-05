#!/bin/bash

# =============================================================================
# GitHub Pages Integration & Deployment Script
# =============================================================================
# This script diagnoses and fixes GitHub Pages deployment issues
# Author: GitHub Copilot
# Date: November 5, 2025
# =============================================================================

#set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
REPO_OWNER="cloudshare360"
REPO_NAME="aws-dev"
GITHUB_PAGES_URL="https://${REPO_OWNER}.github.io/${REPO_NAME}"
BRANCH="main"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${PURPLE}===============================================${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${PURPLE}===============================================${NC}\n"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to test URL accessibility
test_url() {
    local url=$1
    local description=$2
    print_status "Testing: $description"
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200"; then
        print_success "$description is accessible (200 OK)"
        return 0
    else
        local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        print_error "$description returned status code: $status_code"
        return 1
    fi
}

# Function to check GitHub Pages status
check_github_pages_status() {
    print_header "CHECKING GITHUB PAGES STATUS"
    
    print_status "Checking if GitHub Pages is enabled..."
    
    # Test main site
    test_url "$GITHUB_PAGES_URL" "Main GitHub Pages site"
    
    # Test specific Route 53 page
    test_url "$GITHUB_PAGES_URL/AWS-Abhishek-Veeramalla/day-6-route53/" "Route 53 learning page"
    
    # Check if index.html exists on GitHub Pages
    test_url "$GITHUB_PAGES_URL/index.html" "Main index.html"
}

# Function to validate local repository structure
validate_repo_structure() {
    print_header "VALIDATING REPOSITORY STRUCTURE"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository!"
        exit 1
    fi
    
    print_success "Git repository detected"
    
    # Check current branch
    current_branch=$(git branch --show-current)
    print_status "Current branch: $current_branch"
    
    if [ "$current_branch" != "$BRANCH" ]; then
        print_warning "Not on $BRANCH branch. Switching..."
        git checkout "$BRANCH"
    fi
    
    # Check if index.html exists
    if [ -f "index.html" ]; then
        print_success "Root index.html found"
    else
        print_warning "Root index.html not found - creating one"
        create_root_index
    fi
    
    # Check Route 53 index.html
    if [ -f "AWS-Abhishek-Veeramalla/day-6-route53/index.html" ]; then
        print_success "Route 53 index.html found"
    else
        print_error "Route 53 index.html missing!"
        return 1
    fi
    
    # Check Jekyll configuration
    if [ -f "_config.yml" ]; then
        print_success "_config.yml found"
    else
        print_warning "_config.yml not found - creating one"
        create_jekyll_config
    fi
}

# Function to create root index.html
create_root_index() {
    print_status "Creating root index.html..."
    
    cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS Learning Hub - CloudShare360</title>
    <meta http-equiv="refresh" content="0; url=./AWS-Abhishek-Veeramalla/day-6-route53/">
    <style>
        body {
            font-family: 'Amazon Ember', 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #ff9a00 0%, #ffb347 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }
        .container {
            text-align: center;
            background: white;
            padding: 3rem;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            max-width: 600px;
        }
        h1 {
            color: #232f3e;
            margin-bottom: 1rem;
        }
        .aws-logo {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        .btn {
            display: inline-block;
            background: #ff9900;
            color: white;
            padding: 1rem 2rem;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            margin-top: 1rem;
            transition: background 0.3s ease;
        }
        .btn:hover {
            background: #e88800;
        }
        .loading {
            margin-top: 1rem;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="aws-logo">☁️</div>
        <h1>AWS Learning Hub</h1>
        <p>Redirecting to Route 53 Learning Platform...</p>
        <div class="loading">If not redirected automatically, click below:</div>
        <a href="./AWS-Abhishek-Veeramalla/day-6-route53/" class="btn">Enter Learning Hub</a>
    </div>
    <script>
        // Fallback redirect
        setTimeout(function() {
            window.location.href = './AWS-Abhishek-Veeramalla/day-6-route53/';
        }, 2000);
    </script>
</body>
</html>
EOF
    
    print_success "Root index.html created with auto-redirect"
}

# Function to create Jekyll configuration
create_jekyll_config() {
    print_status "Creating Jekyll configuration..."
    
    cat > _config.yml << 'EOF'
# GitHub Pages Configuration
title: AWS Learning Hub
description: Professional AWS learning materials with interactive diagrams
url: "https://cloudshare360.github.io"
baseurl: "/aws-dev"

# Jekyll Settings
markdown: kramdown
highlighter: rouge
theme: minima

# Plugins
plugins:
  - jekyll-feed
  - jekyll-sitemap

# Exclude files
exclude:
  - Gemfile
  - Gemfile.lock
  - node_modules
  - vendor
  - .bundle
  - .sass-cache
  - .jekyll-cache
  - .jekyll-metadata
  - "*.sh"

# Include files
include:
  - _pages

# Collections
collections:
  diagrams:
    output: true
    permalink: /:collection/:name/

# Defaults
defaults:
  - scope:
      path: ""
      type: "posts"
    values:
      layout: "post"
  - scope:
      path: ""
      type: "diagrams"
    values:
      layout: "default"
EOF
    
    print_success "Jekyll configuration created"
}

# Function to create GitHub Actions workflow
create_github_actions() {
    print_header "CREATING GITHUB ACTIONS WORKFLOW"
    
    mkdir -p .github/workflows
    
    cat > .github/workflows/pages.yml << 'EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true
          
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v4
        
      - name: Build with Jekyll
        run: bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
        env:
          JEKYLL_ENV: production
          
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF

    print_success "GitHub Actions workflow created"
}

# Function to create Gemfile
create_gemfile() {
    print_status "Creating Gemfile for GitHub Pages..."
    
    cat > Gemfile << 'EOF'
source "https://rubygems.org"

gem "github-pages", group: :jekyll_plugins
gem "jekyll-include-cache", group: :jekyll_plugins

# Windows and JRuby does not include zoneinfo files
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
EOF

    print_success "Gemfile created"
}

# Function to fix file permissions and structure
fix_file_structure() {
    print_header "FIXING FILE STRUCTURE"
    
    # Remove _site directory if it exists (shouldn't be committed)
    if [ -d "_site" ]; then
        print_status "Removing _site directory..."
        rm -rf _site
        print_success "_site directory removed"
    fi
    
    # Create .gitignore if it doesn't exist
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore << 'EOF'
_site/
.sass-cache/
.jekyll-cache/
.jekyll-metadata
.bundle/
vendor/
Gemfile.lock
*.gem
*.rbc
/.config
/coverage/
/InstalledFiles
/pkg/
/spec/reports/
/spec/examples.txt
/test/tmp/
/test/version_tmp/
/tmp/
EOF
        print_success ".gitignore created"
    fi
    
    # Ensure proper line endings
    if command_exists dos2unix; then
        print_status "Converting line endings..."
        find . -name "*.md" -o -name "*.html" -o -name "*.yml" | xargs dos2unix 2>/dev/null || true
    fi
}

# Function to validate and commit changes
commit_changes() {
    print_header "COMMITTING CHANGES"
    
    # Check if there are changes to commit
    if git diff --quiet && git diff --cached --quiet; then
        print_status "No changes to commit"
        return 0
    fi
    
    print_status "Staging changes..."
    git add .
    
    print_status "Committing changes..."
    git commit -m "Fix GitHub Pages deployment issues

- Add root index.html with auto-redirect
- Create proper Jekyll configuration
- Add GitHub Actions workflow for Pages
- Fix file structure and permissions
- Remove _site directory from repository

Fixes GitHub Pages 404 errors and enables proper deployment."
    
    print_success "Changes committed"
}

# Function to push changes
push_changes() {
    print_header "PUSHING TO GITHUB"
    
    print_status "Pushing to origin/$BRANCH..."
    git push origin "$BRANCH"
    
    print_success "Changes pushed to GitHub"
    print_status "GitHub Pages will redeploy automatically"
}

# Function to wait for deployment and test
test_deployment() {
    print_header "TESTING DEPLOYMENT"
    
    print_status "Waiting for GitHub Pages to deploy (this may take a few minutes)..."
    
    # Wait and test in intervals
    for i in {1..10}; do
        sleep 30
        print_status "Test attempt $i/10..."
        
        if test_url "$GITHUB_PAGES_URL" "GitHub Pages deployment"; then
            print_success "GitHub Pages is now live!"
            
            # Test Route 53 page as well
            if test_url "$GITHUB_PAGES_URL/AWS-Abhishek-Veeramalla/day-6-route53/" "Route 53 learning page"; then
                print_success "Route 53 page is accessible!"
            fi
            
            return 0
        fi
    done
    
    print_warning "Deployment is taking longer than expected. Please check GitHub repository settings."
    return 1
}

# Function to provide instructions
show_instructions() {
    print_header "NEXT STEPS"
    
    echo -e "${CYAN}1. Check GitHub Repository Settings:${NC}"
    echo "   - Go to: https://github.com/$REPO_OWNER/$REPO_NAME/settings/pages"
    echo "   - Ensure Pages is enabled"
    echo "   - Source should be 'GitHub Actions'"
    
    echo -e "\n${CYAN}2. Monitor GitHub Actions:${NC}"
    echo "   - Go to: https://github.com/$REPO_OWNER/$REPO_NAME/actions"
    echo "   - Check if the Pages workflow is running"
    
    echo -e "\n${CYAN}3. Test Live URLs:${NC}"
    echo "   - Main site: $GITHUB_PAGES_URL"
    echo "   - Route 53: $GITHUB_PAGES_URL/AWS-Abhishek-Veeramalla/day-6-route53/"
    
    echo -e "\n${CYAN}4. If issues persist:${NC}"
    echo "   - Check repository visibility (must be public for free GitHub Pages)"
    echo "   - Verify branch protection rules don't block Pages deployment"
    echo "   - Check Actions permissions in repository settings"
}

# Main execution function
main() {
    print_header "GITHUB PAGES INTEGRATION SCRIPT"
    
    print_status "Starting GitHub Pages diagnosis and fix..."
    
    # Step 1: Validate repository structure
    validate_repo_structure
    
    # Step 2: Check current GitHub Pages status
    check_github_pages_status
    
    # Step 3: Create missing files
    create_gemfile
    create_github_actions
    
    # Step 4: Fix file structure
    fix_file_structure
    
    # Step 5: Commit changes
    commit_changes
    
    # Step 6: Push changes
    push_changes
    
    # Step 7: Test deployment
    test_deployment
    
    # Step 8: Show instructions
    show_instructions
    
    print_success "GitHub Pages integration script completed!"
}

# Run the main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi