# Legacy Release Process Documentation

> **⚠️ DEPRECATED**: This is the legacy manual release process. 
> 
> **For new releases, use the [Automated Release Process](AUTOMATED_RELEASE_PROCESS.md)** which provides:
> - One-command releases (`yarn auto-release:patch`)
> - Automatic CHANGELOG generation
> - Zero manual errors
> - 95% time reduction
>
> This document is kept for reference and emergency procedures only.

---

This document outlines the complete **legacy** release management process for the CDH Service API project.

## Overview

The CDH Service API project uses semantic versioning (semver) and follows a structured release process that integrates with our existing deployment workflow.

## Semantic Versioning Strategy

We follow [Semantic Versioning 2.0.0](https://semver.org/) with the following guidelines:

- **MAJOR version (X.0.0)**: Breaking changes to API, database schema changes requiring migrations, major architecture changes
- **MINOR version (0.X.0)**: New features, new endpoints, new modules, backward-compatible functionality
- **PATCH version (0.0.X)**: Bug fixes, security patches, performance improvements, documentation updates

## Release Workflow

### Current Deployment Flow (Unchanged)
```
Feature Branch → dev → DEV environment
dev → qa → QA environment
qa → main → PROD environment
```

### Release Creation Process
1. Development continues with the standard branch workflow
2. When changes reach `main` and deploy to production successfully, releases are triggered
3. The release system creates git tags and GitHub releases automatically
4. Manual releases can be created when needed

## Release Methods

### 1. Automatic Releases (Recommended)

Releases are automatically created when:
- A git tag starting with 'v' is pushed to the repository
- The GitHub Actions workflow runs successfully
- Release notes are generated from CHANGELOG.md

**Prerequisites:**
- Update `CHANGELOG.md` with the new version section
- Ensure all changes are documented in the changelog
- Verify that the version follows semantic versioning

### 2. Manual Releases

Use these commands for manual release creation:

```bash
# Patch release (bug fixes)
yarn release:patch

# Minor release (new features)
yarn release:minor

# Major release (breaking changes)
yarn release:major
```

**Manual Release Process:**
1. Ensure working directory is clean
2. Switch to `main` branch
3. Run the appropriate release command
4. Review the generated changelog entry
5. Confirm the release when prompted
6. Push changes to trigger GitHub release creation

## Detailed Release Steps

### Step 1: Prepare the Release

1. **Update CHANGELOG.md**
   ```markdown
   ## [Unreleased]
   
   ### Added
   
   ### Changed
   
   ### Deprecated
   
   ### Removed
   
   ### Fixed
   
   ### Security
   
   ## [1.1.0] - 2025-01-06
   
   ### Added
   - New AI agent execution capabilities
   
   ### Changed
   - Improved flow processing performance
   ```

2. **Validate Changes**
   ```bash
   yarn lint
   yarn test
   yarn test:e2e
   ```

### Step 2: Create the Release

**Option A: Automatic (Recommended)**
1. Run manual release command to update CHANGELOG.md and create tag
2. Push tag to remote repository
3. GitHub Actions automatically creates the release

**Option B: Manual**
1. Run `yarn release:patch/minor/major`
2. Follow the interactive prompts
3. Confirm and push when ready

### Step 3: Verify Release

1. Check GitHub releases page
2. Verify git tag was created
3. Confirm release notes are accurate
4. Test deployment if needed

## Release Notes Generation

Release notes are automatically generated from the CHANGELOG.md file using our custom script:

```bash
# Generate release notes for a specific version
yarn release:notes v1.0.0
```

The script extracts the relevant section from CHANGELOG.md and formats it for GitHub releases.

## File Structure

```
cdh-service-api/
├── .github/workflows/release.yml    # GitHub Actions release workflow
├── scripts/
│   ├── release.sh                   # Manual release script
│   └── generate-release-notes.js    # Release notes generator
├── docs/
│   ├── RELEASE_PROCESS.md          # This documentation
│   ├── RELEASE_CHECKLIST.md        # Pre-release checklist
│   └── TROUBLESHOOTING.md          # Common issues and solutions
├── CHANGELOG.md                     # Version history
└── package.json                     # Project metadata and scripts
```

## Environment Integration

### Development Environments
- **DEV**: Deploys from `dev` branch automatically
- **QA**: Deploys from `qa` branch automatically  
- **PROD**: Deploys from `main` branch automatically

### Release Timing
- Releases are created AFTER successful production deployment
- This ensures releases represent what's actually running in production
- Tags point to the exact commit deployed to production

## Testing Requirements

Before any release, ensure:

### Unit Tests
```bash
yarn test
```

### Integration Tests
```bash
yarn test:int
```

### End-to-End Tests
```bash
yarn test:e2e
```

### Linting
```bash
yarn lint
```

## Database Considerations

### Schema Changes
- **MAJOR**: Breaking changes requiring data migration
- **MINOR**: Additive changes (new fields, indices)
- **PATCH**: No schema changes

### Migration Process
1. Test migrations in DEV environment
2. Validate in QA environment
3. Plan production migration strategy
4. Document rollback procedures

## API Versioning

### Breaking Changes (MAJOR)
- Removing endpoints
- Changing response formats
- Modifying required parameters
- Changing authentication requirements

### Non-Breaking Changes (MINOR/PATCH)
- Adding new endpoints
- Adding optional parameters
- Adding response fields
- Bug fixes

## Troubleshooting

### Common Issues

**1. Release workflow fails to create tag**
- Check if tag already exists: `git tag --list | grep v1.0.0`
- Delete existing tag if needed: `git tag -d v1.0.0 && git push --delete origin v1.0.0`

**2. Version not found in CHANGELOG.md**
- Ensure version format matches exactly (e.g., `## [1.0.0] - 2025-01-06`)
- Check that version is not still marked as `[Unreleased]`

**3. GitHub Actions workflow fails**
- Check workflow logs in GitHub Actions tab
- Verify repository permissions for GitHub token
- Ensure all required files are present

**4. Manual release script fails**
- Ensure working directory is clean: `git status`
- Check that you're on the correct branch: `git branch --show-current`
- Verify script permissions: `chmod +x scripts/release.sh`

**5. Database migration issues**
- Test migrations in isolated environment
- Verify rollback procedures
- Check for data integrity

### Recovery Procedures

**Delete a bad release:**
```bash
# Delete tag locally and remotely
git tag -d v1.0.0
git push --delete origin v1.0.0

# Delete GitHub release (via GitHub UI or API)
```

**Rollback to previous version:**
```bash
# Create new release from previous tag
git checkout v0.9.0
yarn release:patch  # This creates v0.9.1
```

## Best Practices

### Before Creating a Release
- [ ] All tests pass (unit, integration, e2e)
- [ ] Code is properly linted
- [ ] CHANGELOG.md is updated
- [ ] Database migrations tested
- [ ] Breaking changes documented
- [ ] Version number follows semantic versioning
- [ ] Security vulnerabilities addressed

### During Release Process
- [ ] Review generated release notes
- [ ] Verify tag points to correct commit
- [ ] Check that deployment was successful
- [ ] Confirm all environments are stable
- [ ] Monitor application metrics

### After Release
- [ ] Monitor for any issues
- [ ] Update API documentation if needed
- [ ] Notify stakeholders of significant changes
- [ ] Plan next release milestone
- [ ] Update deployment documentation

## Emergency Procedures

### Hotfix Release Process
1. Create hotfix branch from latest release tag
2. Make minimal necessary changes
3. Update CHANGELOG.md with patch version
4. Create release directly from hotfix branch
5. Merge hotfix back to main and dev branches

### Production Rollback
1. Identify last stable release tag
2. Deploy application from that tag
3. Rollback database if needed
4. Create new patch release if needed
5. Document incident and resolution

## Scripts Reference

### Release Scripts
- `yarn release:patch` - Create patch release (1.0.1)
- `yarn release:minor` - Create minor release (1.1.0)
- `yarn release:major` - Create major release (2.0.0)
- `yarn release:notes <version>` - Generate release notes

### Validation Scripts
- `yarn lint` - Run ESLint
- `yarn test` - Run Jest unit tests
- `yarn test:int` - Run integration tests
- `yarn test:e2e` - Run end-to-end tests

### Build Scripts
- `yarn build` - Build TypeScript
- `yarn start:prod` - Start production build

## Additional Resources

- [Semantic Versioning Specification](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [GitHub Releases Documentation](https://docs.github.com/en/repositories/releasing-projects-on-github)
- [NestJS Deployment Guide](https://docs.nestjs.com/deployment)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)