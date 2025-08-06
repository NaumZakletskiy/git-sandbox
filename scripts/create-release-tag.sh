#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

show_usage() {
    echo "Usage: $0 [version]"
    echo ""
    echo "Creates a release tag after a release PR has been merged to main."
    echo ""
    echo "Arguments:"
    echo "  version    Version to tag (e.g., 1.2.3). If not provided, will read from package.json"
    echo ""
    echo "Examples:"
    echo "  $0           # Create tag from current package.json version"
    echo "  $0 1.2.3     # Create tag for specific version"
    echo ""
    echo "Note: This script should be run on the main branch after a release PR is merged."
}

# Function to validate we're on main branch
validate_branch() {
    local current_branch=$(git branch --show-current)
    if [ "$current_branch" != "main" ]; then
        print_error "This script must be run on the main branch. Current branch: $current_branch"
        exit 1
    fi
    
    # Make sure we're up to date
    git fetch origin
    git pull origin main
    
    print_success "On main branch and up to date"
}

# Function to create and push tag
create_tag() {
    local version=$1
    local tag="v${version}"
    
    # Check if tag already exists
    if git tag -l | grep -q "^${tag}$"; then
        print_error "Tag $tag already exists"
        exit 1
    fi
    
    # Create tag
    print_info "Creating tag $tag"
    git tag -a "$tag" -m "Release $tag

This release was created by the automated release process.

Version: $version
Commit: $(git rev-parse HEAD)
Date: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    
    # Push tag
    print_info "Pushing tag $tag to remote"
    git push origin "$tag"
    
    print_success "Tag $tag created and pushed successfully"
    print_info "This will trigger the release workflow to create a GitHub release"
}

# Main function
main() {
    local version=$1
    
    # Handle help
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        show_usage
        exit 0
    fi
    
    # Validate repository state
    if [ ! -d ".git" ]; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    validate_branch
    
    # Get version
    if [ -z "$version" ]; then
        version=$(node -p "require('./package.json').version" 2>/dev/null)
        if [ -z "$version" ]; then
            print_error "Could not read version from package.json"
            exit 1
        fi
        print_info "Using version from package.json: $version"
    else
        print_info "Using provided version: $version"
    fi
    
    # Validate version format
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format: $version"
        print_error "Expected format: X.Y.Z (e.g., 1.2.3)"
        exit 1
    fi
    
    # Create tag
    create_tag "$version"
    
    print_success "🎉 Release tag created successfully!"
    print_info "Next steps:"
    print_info "1. The release workflow will automatically create a GitHub release"
    print_info "2. Production deployment will detect the tag and create the release"
    print_info "3. Check GitHub Actions for workflow progress"
}

main "$@"