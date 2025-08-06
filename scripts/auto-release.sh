#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
MAIN_BRANCH="main"
QA_BRANCH="qa"
DEV_BRANCH="dev"
RELEASE_BRANCH_PREFIX="release/"
REPO_URL="https://github.com/CloudDataHub/cdh-service-api"

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

print_step() {
    echo -e "${PURPLE}🚀 $1${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 <release_type> [options]"
    echo ""
    echo "Release Types:"
    echo "  patch    - Bug fixes (1.0.0 -> 1.0.1)"
    echo "  minor    - New features (1.0.0 -> 1.1.0)"
    echo "  major    - Breaking changes (1.0.0 -> 2.0.0)"
    echo ""
    echo "Options:"
    echo "  --dry-run         Preview changes without making them"
    echo "  --skip-tests      Skip test validation (not recommended)"
    echo "  --changelog-only  Only update changelog, don't create release"
    echo "  --auto-merge      Automatically merge the release PR"
    echo "  --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 patch                    # Create patch release"
    echo "  $0 minor --dry-run          # Preview minor release"
    echo "  $0 major --skip-tests       # Major release without tests"
}

# Function to validate semantic version
validate_version() {
    local version=$1
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format. Expected format: X.Y.Z (e.g., 1.0.0)"
        exit 1
    fi
}

# Function to calculate new version
calculate_new_version() {
    local current_version=$1
    local release_type=$2
    
    case $release_type in
        patch)
            echo $current_version | awk -F. '{print $1"."$2"."$3+1}'
            ;;
        minor)
            echo $current_version | awk -F. '{print $1"."$2+1".0"}'
            ;;
        major)
            echo $current_version | awk -F. '{print $1+1".0.0"}'
            ;;
        *)
            print_error "Invalid release type: $release_type"
            exit 1
            ;;
    esac
}

# Function to parse conventional commits
parse_conventional_commits() {
    local last_tag=$1
    local current_commit=${2:-HEAD}
    
    # Get commits since last tag
    local commits=$(git log --pretty=format:"%s" ${last_tag}..${current_commit} 2>/dev/null || git log --pretty=format:"%s")
    
    # Parse commits and categorize
    local added=()
    local changed=()
    local fixed=()
    local breaking=()
    local other_changes=()
    
    while IFS= read -r commit; do
        if [[ $commit =~ ^feat(\(.+\))?!?: ]]; then
            if [[ $commit =~ ! ]]; then
                breaking+=("$commit")
            else
                added+=("$commit")
            fi
        elif [[ $commit =~ ^fix(\(.+\))?: ]]; then
            fixed+=("$commit")
        elif [[ $commit =~ ^(chore|docs|style|refactor|perf|test)(\(.+\))?: ]]; then
            changed+=("$commit")
        else
            other_changes+=("$commit")
        fi
    done <<< "$commits"
    
    # Generate changelog content
    local changelog_content=""
    
    if [ ${#added[@]} -gt 0 ]; then
        changelog_content+="\n### Added\n"
        for commit in "${added[@]}"; do
            # Clean up conventional commit format for changelog
            local clean_commit=$(echo "$commit" | sed -E 's/^feat(\([^)]+\))?!?:\s*//')
            changelog_content+="- ${clean_commit}\n"
        done
    fi
    
    if [ ${#changed[@]} -gt 0 ]; then
        changelog_content+="\n### Changed\n"
        for commit in "${changed[@]}"; do
            local clean_commit=$(echo "$commit" | sed -E 's/^(chore|docs|style|refactor|perf|test)(\([^)]+\))?:\s*//')
            changelog_content+="- ${clean_commit}\n"
        done
    fi
    
    if [ ${#fixed[@]} -gt 0 ]; then
        changelog_content+="\n### Fixed\n"
        for commit in "${fixed[@]}"; do
            local clean_commit=$(echo "$commit" | sed -E 's/^fix(\([^)]+\))?:\s*//')
            changelog_content+="- ${clean_commit}\n"
        done
    fi
    
    if [ ${#other_changes[@]} -gt 0 ]; then
        changelog_content+="\n### Other Changes\n"
        for commit in "${other_changes[@]}"; do
            changelog_content+="- ${commit}\n"
        done
    fi
    
    if [ ${#breaking[@]} -gt 0 ]; then
        changelog_content+="\n### BREAKING CHANGES\n"
        for commit in "${breaking[@]}"; do
            local clean_commit=$(echo "$commit" | sed -E 's/^feat(\([^)]+\))?!:\s*//')
            changelog_content+="- ${clean_commit}\n"
        done
    fi
    
    echo -e "$changelog_content"
}

# Function to update changelog
update_changelog() {
    local version=$1
    local date=$(date +%Y-%m-%d)
    local changelog_content="$2"
    
    print_info "Updating CHANGELOG.md with version $version"
    
    # Create backup
    cp CHANGELOG.md CHANGELOG.md.backup
    
    # Create new changelog content
    local temp_file=$(mktemp)
    
    # Read existing changelog
    local in_unreleased=false
    local unreleased_content=""
    
    while IFS= read -r line; do
        if [[ $line == "## [Unreleased]" ]]; then
            in_unreleased=true
            echo "$line" >> "$temp_file"
            continue
        elif [[ $line =~ ^##\ \[.*\] && $in_unreleased == true ]]; then
            in_unreleased=false
            # Add new version section
            echo "" >> "$temp_file"
            echo "### Added" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "### Changed" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "### Deprecated" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "### Removed" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "### Fixed" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "### Security" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "## [$version] - $date" >> "$temp_file"
            echo -e "$changelog_content" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "$line" >> "$temp_file"
        elif [[ $in_unreleased == false ]]; then
            echo "$line" >> "$temp_file"
        fi
    done < CHANGELOG.md
    
    # Replace original changelog
    mv "$temp_file" CHANGELOG.md
    
    print_success "CHANGELOG.md updated successfully"
}

# Function to update package.json version
update_package_version() {
    local new_version=$1
    
    print_info "Updating package.json version to $new_version"
    
    # Use npm to update version (this ensures proper semver handling)
    npm version --no-git-tag-version "$new_version" > /dev/null
    
    print_success "Package.json version updated to $new_version"
}

# Function to run tests
run_tests() {
    if [[ "$SKIP_TESTS" == "true" ]]; then
        print_warning "Skipping tests as requested"
        return
    fi
    
    print_step "Running tests..."
    
    # Check if dependencies are installed
    if [ ! -d "node_modules" ]; then
        print_info "Installing dependencies..."
        yarn install --frozen-lockfile
    fi
    
    # Run linting
    print_info "Running linting..."
    if yarn lint; then
        print_success "Linting passed"
    else
        print_error "Linting failed. Please fix linting errors before releasing."
        exit 1
    fi
    
    # Run unit tests
    print_info "Running unit tests..."
    if yarn test --passWithNoTests; then
        print_success "Unit tests passed"
    else
        print_error "Unit tests failed. Please fix failing tests before releasing."
        exit 1
    fi
    
    print_success "All tests passed"
}

# Function to create release branch and PR
create_release_pr() {
    local version=$1
    local release_branch="${RELEASE_BRANCH_PREFIX}v${version}"
    
    print_step "Creating release branch and PR..."
    
    # Create and switch to release branch
    git checkout -b "$release_branch"
    
    # Commit changes
    git add CHANGELOG.md package.json package-lock.json 2>/dev/null || git add CHANGELOG.md package.json
    git commit -m "chore: release v${version}

- Update CHANGELOG.md for v${version}
- Bump version to ${version}"
    
    # Push release branch
    git push origin "$release_branch"
    
    # Create PR
    local pr_body="## Release v${version}

This PR contains the release changes for version ${version}.

### Changes included:
- Updated CHANGELOG.md with release notes
- Bumped package.json version to ${version}

### Release Process:
1. ✅ Tests passed
2. ✅ Version updated
3. ✅ CHANGELOG updated
4. ⏳ Ready for review and merge
5. ⏳ Will deploy to production after merge
6. ⏳ GitHub release will be created after successful deployment

**This is an automated release PR generated by auto-release.sh**"
    
    local pr_url
    if command -v gh >/dev/null 2>&1; then
        pr_url=$(gh pr create --title "Release v${version}" --body "$pr_body" --base "$MAIN_BRANCH" --head "$release_branch")
        print_success "Release PR created: $pr_url"
        
        if [[ "$AUTO_MERGE" == "true" ]]; then
            print_info "Auto-merging PR..."
            gh pr merge "$pr_url" --merge --delete-branch
            print_success "PR merged successfully"
        fi
    else
        print_warning "GitHub CLI not installed. Please create PR manually:"
        print_info "  Branch: $release_branch -> $MAIN_BRANCH"
        print_info "  Title: Release v${version}"
    fi
    
    return 0
}

# Function to validate git repository state
validate_git_state() {
    print_step "Validating repository state..."
    
    # Check if we're in a git repository
    if [ ! -d ".git" ]; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    # Check if working directory is clean (unless dry run)
    if [[ "$DRY_RUN" != "true" ]] && [ -n "$(git status --porcelain)" ]; then
        print_error "Working directory is not clean. Please commit or stash changes first."
        git status --short
        exit 1
    fi
    
    # Fetch latest changes
    git fetch origin
    
    # Check if we're on qa branch (or switch to it)
    current_branch=$(git branch --show-current)
    if [ "$current_branch" != "$QA_BRANCH" ]; then
        print_info "Switching to $QA_BRANCH branch..."
        git checkout "$QA_BRANCH"
        git pull origin "$QA_BRANCH"
    else
        # Make sure we're up to date
        git pull origin "$QA_BRANCH"
    fi
    
    print_success "Repository state validated"
}

# Function to cleanup on error
cleanup_on_error() {
    print_error "Release process failed. Cleaning up..."
    
    # Remove backup files
    [ -f "CHANGELOG.md.backup" ] && mv CHANGELOG.md.backup CHANGELOG.md
    
    # Switch back to original branch if needed
    local current_branch=$(git branch --show-current)
    if [[ $current_branch =~ ^${RELEASE_BRANCH_PREFIX} ]]; then
        git checkout "$QA_BRANCH" 2>/dev/null || true
        git branch -D "$current_branch" 2>/dev/null || true
    fi
    
    print_info "Cleanup completed"
    exit 1
}

# Main release function
main() {
    local release_type=$1
    shift
    
    # Parse options
    DRY_RUN=false
    SKIP_TESTS=false
    CHANGELOG_ONLY=false
    AUTO_MERGE=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --skip-tests)
                SKIP_TESTS=true
                shift
                ;;
            --changelog-only)
                CHANGELOG_ONLY=true
                shift
                ;;
            --auto-merge)
                AUTO_MERGE=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Validate release type
    if [[ ! "$release_type" =~ ^(patch|minor|major)$ ]]; then
        print_error "Invalid release type: $release_type"
        show_usage
        exit 1
    fi
    
    # Set error trap
    trap cleanup_on_error ERR
    
    print_info "🚀 Starting automated release process..."
    print_info "Release type: $release_type"
    [[ "$DRY_RUN" == "true" ]] && print_warning "DRY RUN MODE - No changes will be made"
    
    # Validate repository state
    validate_git_state
    
    # Get current version
    local current_version=$(node -p "require('./package.json').version" 2>/dev/null || echo "0.0.0")
    print_info "Current version: $current_version"
    
    # Calculate new version
    local new_version=$(calculate_new_version "$current_version" "$release_type")
    validate_version "$new_version"
    print_info "New version: $new_version"
    
    # Get last tag for changelog generation
    local last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    if [ -z "$last_tag" ]; then
        print_warning "No previous tags found. Will use all commits for changelog."
        last_tag=""
    else
        print_info "Last tag: $last_tag"
    fi
    
    # Generate changelog content from commits
    print_step "Generating changelog from commits..."
    local changelog_content=$(parse_conventional_commits "$last_tag")
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "=== DRY RUN PREVIEW ==="
        print_info "Version: $current_version -> $new_version"
        print_info "Changelog content:"
        echo -e "$changelog_content"
        print_info "=== END PREVIEW ==="
        exit 0
    fi
    
    # Run tests
    run_tests
    
    # Update files
    update_changelog "$new_version" "$changelog_content"
    update_package_version "$new_version"
    
    if [[ "$CHANGELOG_ONLY" == "true" ]]; then
        print_success "Changelog updated. Exiting as requested (--changelog-only)."
        exit 0
    fi
    
    # Create release PR
    create_release_pr "$new_version"
    
    # Clean up backup files
    rm -f CHANGELOG.md.backup
    
    print_success "🎉 Release process completed successfully!"
    print_info "Next steps:"
    print_info "1. Review and merge the release PR"
    print_info "2. After PR is merged, create release tag:"
    print_info "   cd to main branch: git checkout main && git pull"
    print_info "   Create tag: ./scripts/create-release-tag.sh"
    print_info "3. Production deployment will detect the tag and create GitHub release"
    print_info "4. Branches will be synced automatically"
}

# Script entry point
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

# Handle help flag at top level
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    exit 0
fi

main "$@"