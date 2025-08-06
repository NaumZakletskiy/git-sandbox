# CDH Service API Documentation

Welcome to the CDH Service API documentation. This directory contains comprehensive guides for development, deployment, and release management.

## 📋 Documentation Index

### 🚀 Release Management

| Document | Description | When to Use |
|----------|-------------|-------------|
| **[Automated Release Process](AUTOMATED_RELEASE_PROCESS.md)** | ⭐ **Primary guide** for creating releases | For all new releases |
| **[Release Checklist](RELEASE_CHECKLIST.md)** | Quality assurance checklist | Before every release |  
| **[Troubleshooting Guide](TROUBLESHOOTING.md)** | Common issues and solutions | When things go wrong |
| **[Legacy Release Process](RELEASE_PROCESS.md)** | Original manual process | Emergency/reference only |

### 📊 Release Process Comparison

| Aspect | Automated Process | Legacy Process |
|--------|------------------|----------------|
| **Time Required** | 5 minutes | 30+ minutes |
| **Commands** | 1 command | 15+ manual steps |
| **Error Rate** | Zero (automated) | High (human errors) |
| **Documentation** | Auto-generated | Manual writing |
| **Recommended** | ✅ **Yes** | ❌ Emergency only |

## 🚀 Quick Start

### For Regular Releases
```bash
# Step 1: Create release (from qa branch)
yarn auto-release:patch

# Step 2: Review and merge the PR

# Step 3: Create tag (from main branch)
git checkout main && git pull
yarn release:tag
```

### For Preview/Testing
```bash
# See what would happen without making changes
yarn auto-release:preview
```

## 📚 Key Concepts

### Branch Workflow
- **`dev`** → Development environment (active development)  
- **`qa`** → QA environment (testing and validation)
- **`main`** → Production environment (stable releases)

### Release Types
- **Patch** (`1.0.0 → 1.0.1`) - Bug fixes, security patches
- **Minor** (`1.0.0 → 1.1.0`) - New features, backward compatible
- **Major** (`1.0.0 → 2.0.0`) - Breaking changes

### Conventional Commits
This project uses [Conventional Commits](https://www.conventionalcommits.org/) for automatic changelog generation:

```bash
feat: add user authentication        → Minor release
fix: resolve memory leak            → Patch release  
feat!: change API response format   → Major release
chore: update dependencies          → Patch release
docs: add API documentation         → Patch release
```

## 🛠 Scripts Reference

### Automated Release Scripts
```bash
yarn auto-release:patch     # Create patch release (recommended)
yarn auto-release:minor     # Create minor release  
yarn auto-release:major     # Create major release
yarn auto-release:preview   # Preview changes without making them
yarn release:tag           # Create release tag after PR merge
```

### Legacy Scripts (Manual Process)
```bash
yarn release:patch         # Legacy patch release
yarn release:minor         # Legacy minor release
yarn release:major         # Legacy major release
yarn release:notes         # Generate release notes from CHANGELOG
```

### Development Scripts
```bash
yarn test                  # Unit tests
yarn test:int             # Integration tests (requires Docker)
yarn test:e2e             # End-to-end tests
yarn lint                 # Code linting
yarn build                # Build TypeScript
```

## 🔄 Workflow Integration

### GitHub Actions
- **`release.yml`** - Creates GitHub releases from tags
- **`prod.yml`** - Deploys to production and triggers releases
- **`qa.yml`** - Deploys to QA environment
- **`dev.yml`** - Deploys to development environment

### Automated Pipeline
```
Developer → auto-release.sh → PR → Merge → Tag → Deploy → GitHub Release
```

## 🆘 Getting Help

### Quick Troubleshooting
1. **Script permission denied**: `chmod +x scripts/*.sh`
2. **Working directory dirty**: `git status` and commit changes
3. **GitHub CLI missing**: Install from [cli.github.com](https://cli.github.com/)
4. **Tests failing**: Run `yarn test` and `yarn lint` locally

### Detailed Help
- **[Troubleshooting Guide](TROUBLESHOOTING.md)** - Comprehensive issue resolution
- **Script help**: `./scripts/auto-release.sh --help`
- **Repository issues**: Create issue in GitHub repository

## 📈 Best Practices

### Before Releasing
1. ✅ **Use conventional commits** for better changelogs
2. ✅ **Run tests locally** before releasing  
3. ✅ **Preview with dry-run** for important releases
4. ✅ **Keep working directory clean**

### During Release
1. ✅ **Review generated PR** before merging
2. ✅ **Monitor GitHub Actions** for deployment status
3. ✅ **Verify release creation** after deployment
4. ✅ **Check all environments** remain stable

### After Release
1. ✅ **Monitor application metrics** for issues
2. ✅ **Update team** on significant changes
3. ✅ **Plan next milestone** if needed
4. ✅ **Document lessons learned**

## 🔗 External Resources

- **[Semantic Versioning](https://semver.org/)** - Version numbering scheme
- **[Keep a Changelog](https://keepachangelog.com/)** - CHANGELOG format
- **[Conventional Commits](https://www.conventionalcommits.org/)** - Commit message format
- **[GitHub Actions Documentation](https://docs.github.com/en/actions)** - CI/CD workflows
- **[NestJS Documentation](https://docs.nestjs.com/)** - Framework reference

---

*For questions about the release process, consult the [Troubleshooting Guide](TROUBLESHOOTING.md) or create an issue.*