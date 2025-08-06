# Release Management Troubleshooting Guide

This guide covers common issues and their solutions when working with the CDH Service API release management system.

## 🚀 Automated Release Process Issues

### Auto-Release Script Issues

#### Script Permission Denied
```bash
./scripts/auto-release.sh: Permission denied
```
**Solution:**
```bash
chmod +x scripts/auto-release.sh
chmod +x scripts/create-release-tag.sh
```

#### Working Directory Not Clean
```bash
❌ Working directory is not clean. Please commit or stash changes first.
```
**Solution:**
```bash
git status
git add . && git commit -m "your commit message"
# OR
git stash
```

#### GitHub CLI Not Found
```bash
GitHub CLI not installed. Please create PR manually
```
**Solution:**
```bash
# Install GitHub CLI
brew install gh  # macOS
# or follow https://cli.github.com/
gh auth login
```

#### Tests Fail During Release
```bash
❌ Unit tests failed. Please fix failing tests before releasing.
```
**Solution:**
```bash
# Run tests locally to debug
yarn test
yarn lint
# Fix issues, then retry release
```

### Tag Creation Issues

#### Already on Wrong Branch
```bash
❌ This script must be run on the main branch. Current branch: qa
```
**Solution:**
```bash
git checkout main
git pull origin main
./scripts/create-release-tag.sh
```

#### Tag Already Exists
```bash
❌ Tag v1.2.3 already exists
```
**Solution:**
```bash
# Check existing tags
git tag -l | grep v1.2.3

# Delete if needed (use carefully!)
git tag -d v1.2.3
git push --delete origin v1.2.3

# Or use a different version
./scripts/create-release-tag.sh 1.2.4
```

### GitHub Actions Issues

#### Workflow Not Triggering
If GitHub Actions don't trigger after creating a tag:

**Solution:**
```bash
# Check if tag was pushed
git ls-remote --tags origin

# Manually trigger release workflow
gh workflow run release.yml --ref main -f tag="v1.2.3"
```

#### Integration Tests Failing in CI
```bash
⚠️ Integration tests failed, but continuing release...
```
**Solution:**
- This is non-blocking by design
- Review integration test logs in GitHub Actions
- Fix issues in next release if needed

## 📋 Legacy Release Process Issues

## Common Release Issues

### 1. GitHub Actions Release Workflow Fails

#### Symptom
Release workflow fails with errors in GitHub Actions.

#### Possible Causes & Solutions

**Permission Issues:**
```
Error: Resource not accessible by integration
```
- **Solution**: Check repository settings → Actions → General → Workflow permissions
- Ensure "Read and write permissions" is enabled
- Verify `GITHUB_TOKEN` has sufficient permissions

**Version Not Found in CHANGELOG:**
```
Version v1.0.0 not found in CHANGELOG.md
```
- **Solution**: Ensure CHANGELOG.md has the exact version format:
  ```markdown
  ## [1.0.0] - 2025-01-06
  ```
- Version must not be marked as `[Unreleased]`
- Date format must be YYYY-MM-DD

**Tag Already Exists:**
```
fatal: tag 'v1.0.0' already exists
```
- **Solution**: Delete existing tag:
  ```bash
  git tag -d v1.0.0
  git push --delete origin v1.0.0
  ```

**Test Failures:**
```
Tests failed during release
```
- **Solution**: Fix failing tests before release:
  ```bash
  yarn test
  yarn test:int
  yarn test:e2e
  yarn lint
  ```

### 2. Manual Release Script Issues

#### Symptom
`yarn release:patch/minor/major` fails or produces errors.

#### Possible Causes & Solutions

**Working Directory Not Clean:**
```
Working directory is not clean. Please commit or stash changes first.
```
- **Solution**: 
  ```bash
  git status
  git add .
  git commit -m "commit message"
  # OR
  git stash
  ```

**Not on Main Branch:**
```
You're not on the main branch. Current branch: feat/new-feature
```
- **Solution**: Switch to main branch:
  ```bash
  git checkout main
  git pull origin main
  ```

**Script Permission Denied:**
```
Permission denied: ./scripts/release.sh
```
- **Solution**: Make script executable:
  ```bash
  chmod +x scripts/release.sh
  chmod +x scripts/generate-release-notes.js
  ```

**Node.js Module Issues:**
```
Cannot find module './package.json'
```
- **Solution**: Ensure you're in the project root:
  ```bash
  cd /path/to/cdh-service-api
  ls package.json  # Should exist
  ```

### 3. Version Generation Issues

#### Symptom
Incorrect version numbers or release notes.

#### Possible Causes & Solutions

**Semantic Versioning Errors:**
- **Issue**: Wrong version increment
- **Solution**: Use appropriate command:
  - Bug fixes: `yarn release:patch` (1.0.0 → 1.0.1)
  - New features: `yarn release:minor` (1.0.0 → 1.1.0)  
  - Breaking changes: `yarn release:major` (1.0.0 → 2.0.0)

**Release Notes Empty or Incorrect:**
- **Issue**: Script can't parse CHANGELOG.md
- **Solution**: Verify CHANGELOG.md format:
  ```markdown
  ## [1.0.0] - 2025-01-06
  
  ### Added
  - New AI agent execution features
  
  ### Changed
  - Improved flow processing performance
  ```

**Package.json Version Issues:**
```
npm ERR! Version not changed
```
- **Solution**: Check current version and increment properly:
  ```bash
  node -p "require('./package.json').version"
  ```

### 4. Git Tag and Release Issues

#### Symptom
Tags not created or GitHub releases missing.

#### Possible Causes & Solutions

**Local Tag Not Pushed:**
```bash
# Check if tag exists locally but not remotely
git tag --list | grep v1.0.0
git ls-remote --tags origin | grep v1.0.0
```
- **Solution**: Push tags manually:
  ```bash
  git push origin v1.0.0
  ```

**GitHub Release Not Created:**
- **Issue**: Tag exists but no GitHub release
- **Solution**: Check workflow logs or manually trigger:
  ```bash
  # Re-trigger release workflow by pushing tag again
  git tag -d v1.0.0
  git tag v1.0.0
  git push origin v1.0.0
  ```

**Release Workflow Doesn't Trigger:**
- **Issue**: Tag format incorrect
- **Solution**: Ensure tag starts with 'v':
  ```bash
  git tag v1.0.0  # Correct
  git tag 1.0.0   # Incorrect
  ```

## Application-Specific Issues

### 1. Database Migration Problems

#### Migration Script Fails
```
Migration failed: table already exists
```
- **Solution**: Check migration state:
  ```bash
  # Check database state
  yarn migration:status
  
  # Rollback if needed
  yarn migration:rollback
  ```

#### Database Connection Issues
```
Unable to connect to database
```
- **Solution**: Verify environment variables:
  ```bash
  echo $DATABASE_URL
  echo $MONGODB_URI
  ```

### 2. Docker Build Issues

#### Docker Image Build Fails
```
Docker build failed
```
- **Solution**: Check Dockerfile and build locally:
  ```bash
  docker build -t cdh-service-api .
  docker run -p 3000:3000 cdh-service-api
  ```

#### Container Health Check Fails
```
Health check failed
```
- **Solution**: Verify health endpoint:
  ```bash
  curl http://localhost:3000/health
  ```

### 3. Environment Configuration Issues

#### Missing Environment Variables
```
Configuration validation error
```
- **Solution**: Check required environment variables:
  ```bash
  # Copy example file
  cp .env.example .env
  
  # Verify all required variables are set
  yarn start:dev
  ```

#### AWS Services Connection Issues
```
AWS SDK configuration error
```
- **Solution**: Verify AWS credentials and region:
  ```bash
  aws configure list
  aws sts get-caller-identity
  ```

## Environment-Specific Issues

### 1. Development Environment Problems

#### Node.js Version Mismatch
```
Error: The engine "node" is incompatible
```
- **Solution**: Use Node.js 18:
  ```bash
  nvm use 18
  # OR
  nvm install 18
  ```

#### Yarn vs NPM Conflicts
```
Found both yarn.lock and package-lock.json
```
- **Solution**: Use yarn consistently:
  ```bash
  rm package-lock.json
  yarn install
  ```

#### Port Already in Use
```
Error: listen EADDRINUSE :::3000
```
- **Solution**: Kill process or use different port:
  ```bash
  lsof -ti:3000 | xargs kill -9
  # OR
  PORT=3001 yarn start:dev
  ```

### 2. CI/CD Pipeline Issues

#### GitHub Actions Runner Problems
```
Runner failed to start
```
- **Solution**: Check GitHub status page or retry workflow

#### Test Environment Setup Fails
```
Integration tests fail to start
```
- **Solution**: Check Docker services:
  ```bash
  docker-compose -f docker-compose.test.yml up -d
  docker-compose -f docker-compose.test.yml logs
  ```

#### Redis Connection Issues
```
Redis connection failed
```
- **Solution**: Verify Redis is running:
  ```bash
  docker ps | grep redis
  redis-cli ping
  ```

### 3. Package and Dependency Issues

#### Yarn Install Fails
```
yarn install failed
```
- **Solution**: Clear cache and reinstall:
  ```bash
  yarn cache clean
  rm -rf node_modules yarn.lock
  yarn install
  ```

#### Dependency Conflicts
```
Dependency resolution failed
```
- **Solution**: Check for version conflicts:
  ```bash
  yarn why package-name
  yarn audit
  ```

#### TypeScript Compilation Errors
```
TypeScript build failed
```
- **Solution**: Check TypeScript configuration:
  ```bash
  yarn build
  npx tsc --noEmit
  ```

## Recovery Procedures

### 1. Fix Failed Release

**Complete Cleanup:**
```bash
# 1. Delete bad tag locally and remotely
git tag -d v1.0.0
git push --delete origin v1.0.0

# 2. Delete GitHub release (via GitHub UI)

# 3. Reset package.json version if needed
npm version --no-git-tag-version 0.9.0

# 4. Fix CHANGELOG.md

# 5. Commit fixes
git add .
git commit -m "fix: repair failed release"

# 6. Re-run release process
yarn release:patch
```

### 2. Emergency Rollback

**Production Rollback:**
```bash
# 1. Identify last stable version
git tag --list --sort=-version:refname

# 2. Deploy from stable tag
git checkout v0.9.0

# 3. Build and deploy
docker build -t cdh-service-api:v0.9.0 .
# Deploy to your environment

# 4. Create hotfix if needed
git checkout -b hotfix/critical-fix
# Make minimal changes
yarn release:patch
```

### 3. Database Recovery

**Database Rollback:**
```bash
# 1. Backup current database
mongodump --uri="$MONGODB_URI" --out=backup-$(date +%Y%m%d)

# 2. Rollback migrations
yarn migration:rollback

# 3. Restore from backup if needed
mongorestore --uri="$MONGODB_URI" --drop backup-folder/
```

## Debugging Commands

### Check Release State
```bash
# List all tags
git tag --list --sort=-version:refname

# Check current version
node -p "require('./package.json').version"

# Verify CHANGELOG format
grep -n "## \[" CHANGELOG.md

# Check GitHub releases
gh release list

# View specific release
gh release view v1.0.0
```

### Validate Environment
```bash
# Check Node.js version
node --version

# Verify yarn
yarn --version

# Check git status
git status

# Verify current branch
git branch --show-current

# Check remote
git remote -v

# Test database connection
yarn test:db

# Check environment variables
printenv | grep -E '(DATABASE|MONGODB|AWS|REDIS)'
```

### Test Application Components
```bash
# Test release notes generation
yarn release:notes v1.0.0

# Validate scripts
./scripts/release.sh --help

# Test application build
yarn build

# Test application start
yarn start:prod

# Check health endpoint
curl http://localhost:3000/health

# Test database connection
yarn test:int
```

### Monitor Application
```bash
# Check application logs
tail -f logs/application.log

# Monitor database
mongo --eval "db.stats()"

# Check Redis
redis-cli info

# Monitor system resources
htop
docker stats
```

## Prevention Strategies

### 1. Pre-Release Validation
- Always run full test suite before releases
- Use release checklist consistently
- Test release process in development environment
- Validate database migrations in staging

### 2. Monitoring
- Set up notifications for failed workflows
- Monitor GitHub Actions regularly
- Keep release documentation updated
- Monitor application health endpoints

### 3. Backup Procedures
- Tag important milestones
- Maintain database backups
- Document custom configurations
- Keep environment variable documentation updated

## Getting Help

### Internal Resources
- Check `docs/RELEASE_PROCESS.md` for detailed procedures
- Review `docs/RELEASE_CHECKLIST.md` for step-by-step guidance
- Examine workflow files in `.github/workflows/`
- Check CODEOWNERS for approval requirements

### External Resources
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning Guide](https://semver.org/)
- [NestJS Documentation](https://docs.nestjs.com/)
- [Docker Documentation](https://docs.docker.com/)

### Emergency Contacts
- Repository Owner: Ruslan Valiyev (see CODEOWNERS)
- DevOps Team: [Contact Information]
- On-Call Engineer: [Contact Information]