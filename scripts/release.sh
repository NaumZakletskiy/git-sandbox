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

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to validate semantic version
validate_version() {
    local version=$1
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format. Expected format: X.Y.Z (e.g., 1.0.0)"
        exit 1
    fi
}

# Function to update changelog
update_changelog() {
    local version=$1
    local date=$(date +%Y-%m-%d)
    
    print_info "Updating CHANGELOG.md with version $version"
    
    # Replace [Unreleased] with [version] - date
    sed -i "s/## \[Unreleased\]/## [$version] - $date/" CHANGELOG.md
    
    # Add new Unreleased section at the top
    sed -i "/^## \[$version\] - $date/i\\
## [Unreleased]\\
\\
### Added\\
\\
### Changed\\
\\
### Deprecated\\
\\
### Removed\\
\\
### Fixed\\
\\
### Security\\
\\
" CHANGELOG.md
    
    print_success "CHANGELOG.md updated"
}

# Function to update package.json version
update_package_version() {
    local version=$1
    print_info "Updating package.json version to $version"
    npm version --no-git-tag-version "$version"
    print_success "package.json updated"
}

# Function to create git tag and commit
create_release() {
    local version=$1
    local tag="v$version"
    
    print_info "Creating release commit and tag"
    
    # Add changes
    git add CHANGELOG.md package.json
    
    # Commit changes
    git commit -m "chore: release $tag

- Update CHANGELOG.md
- Bump version to $version"
    
    # Create tag
    git tag -a "$tag" -m "Release $tag"
    
    print_success "Created tag $tag"
    
    # Ask if user wants to push
    read -p "Push changes and tag to remote? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin main
        git push origin "$tag"
        print_success "Changes and tag pushed to remote"
    else
        print_warning "Changes and tag created locally. Push manually with:"
        echo "  git push origin main"
        echo "  git push origin $tag"
    fi
}

# Main script
main() {
    local release_type=$1
    local custom_version=$2
    
    # Check if we're in a git repository
    if [ ! -d ".git" ]; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    # Check if working directory is clean
    if [ -n "$(git status --porcelain)" ]; then
        print_error "Working directory is not clean. Please commit or stash changes first."
        exit 1
    fi
    
    # Check if we're on main branch
    current_branch=$(git branch --show-current)
    if [ "$current_branch" != "main" ]; then
        print_warning "You're not on the main branch. Current branch: $current_branch"
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Get current version from package.json
    current_version=$(node -p "require('./package.json').version")
    print_info "Current version: $current_version"
    
    # Determine new version
    if [ -n "$custom_version" ]; then
        validate_version "$custom_version"
        new_version="$custom_version"
    else
        case $release_type in
            patch)
                new_version=$(echo $current_version | awk -F. '{print $1"."$2"."$3+1}')
                ;;
            minor)
                new_version=$(echo $current_version | awk -F. '{print $1"."$2+1".0"}')
                ;;
            major)
                new_version=$(echo $current_version | awk -F. '{print $1+1".0.0"}')
                ;;
            *)
                print_error "Invalid release type. Use: patch, minor, major, or provide custom version"
                echo "Usage: $0 <patch|minor|major> [custom_version]"
                exit 1
                ;;
        esac
    fi
    
    print_info "New version: $new_version"
    
    # Confirm with user
    read -p "Create release $new_version? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Release cancelled"
        exit 0
    fi
    
    # Perform release steps
    update_changelog "$new_version"
    update_package_version "$new_version"
    create_release "$new_version"
    
    print_success "Release $new_version created successfully!"
    print_info "GitHub release will be created automatically when changes are pushed to main branch"
}

# Run main function with arguments
main "$@"