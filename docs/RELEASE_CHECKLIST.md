# Release Checklist

Use this checklist to ensure consistent and reliable releases for CDH Service API.

## 🚀 Automated Release Process (Recommended)

For most releases, use the automated process:

### Pre-Release Checklist (Automated)
- [ ] Run `yarn auto-release:preview` to preview changes
- [ ] Verify commit messages follow [conventional commits](https://www.conventionalcommits.org/)
- [ ] Ensure working directory is clean (`git status`)
- [ ] Review generated CHANGELOG preview

### Release Process (Automated)
- [ ] Run `yarn auto-release:patch` (or minor/major)
- [ ] Review the generated release PR
- [ ] Merge the release PR via GitHub UI
- [ ] Switch to main branch: `git checkout main && git pull`
- [ ] Create release tag: `yarn release:tag`
- [ ] Monitor GitHub Actions for deployment success
- [ ] Verify GitHub release was created automatically

### Post-Release Checklist (Automated)
- [ ] GitHub release created with proper notes
- [ ] Production deployment successful
- [ ] All environments remain stable
- [ ] Branches synced automatically

---

## 📋 Manual Release Process (Legacy)

> **Note**: Only use this for emergency releases or when automated process is unavailable.
> See [Legacy Release Process](RELEASE_PROCESS.md) for full manual instructions.

## Pre-Release Checklist

### Code Quality
- [ ] All unit tests pass (`yarn test`)
- [ ] All integration tests pass (`yarn test:int`)
- [ ] All end-to-end tests pass (`yarn test:e2e`)
- [ ] Code passes linting (`yarn lint`)
- [ ] No merge conflicts in target branch
- [ ] Working directory is clean (`git status`)

### Documentation
- [ ] CHANGELOG.md updated with new version
- [ ] Breaking changes documented
- [ ] New features documented
- [ ] API changes documented
- [ ] Version follows semantic versioning rules
- [ ] Release date added to changelog

### Environment Verification
- [ ] DEV environment is stable
- [ ] QA environment is stable
- [ ] All CI/CD pipelines are passing
- [ ] No critical issues in production
- [ ] Database migrations tested (if applicable)

### Security
- [ ] Security vulnerabilities addressed
- [ ] Dependencies updated to secure versions
- [ ] Authentication and authorization tested
- [ ] API security validated

## Release Process Checklist

### Manual Release (Recommended)
- [ ] Checkout `main` branch
- [ ] Pull latest changes
- [ ] Run appropriate release command:
  - [ ] `yarn release:patch` (for bug fixes)
  - [ ] `yarn release:minor` (for new features)
  - [ ] `yarn release:major` (for breaking changes)
- [ ] Review generated changelog entry
- [ ] Confirm release when prompted
- [ ] Push changes and tags
- [ ] Monitor GitHub Actions workflow

### Automatic Release (Tag-based)
- [ ] Verify tag format (v1.0.0)
- [ ] Push tag to remote repository
- [ ] Monitor GitHub Actions workflow
- [ ] Verify release creation

## Post-Release Checklist

### Verification
- [ ] Git tag created successfully
- [ ] GitHub release published
- [ ] Release notes are accurate
- [ ] Package.json version updated
- [ ] All environments remain stable
- [ ] Docker images built successfully

### Communication
- [ ] Team notified of release
- [ ] Stakeholders informed of major changes
- [ ] API documentation updated if needed
- [ ] Next milestone planned

### Monitoring
- [ ] Monitor for deployment issues
- [ ] Check error rates and metrics
- [ ] Verify all services are healthy
- [ ] Review logs for anomalies
- [ ] Monitor database performance
- [ ] Check API response times

## Emergency Rollback Checklist

### Assessment
- [ ] Identify the issue severity
- [ ] Determine if rollback is necessary
- [ ] Identify last known good version
- [ ] Assess impact of rollback
- [ ] Check database state

### Rollback Process
- [ ] Communicate rollback decision
- [ ] Deploy from previous stable tag
- [ ] Rollback database migrations if needed
- [ ] Verify rollback success
- [ ] Monitor system stability
- [ ] Document incident

### Recovery
- [ ] Identify root cause
- [ ] Create fix for the issue
- [ ] Test fix thoroughly in all environments
- [ ] Plan new release with fix
- [ ] Update documentation and procedures

## Version-Specific Checklists

### Patch Release (X.X.Y)
- [ ] Only bug fixes included
- [ ] No new features
- [ ] No breaking changes
- [ ] Backward compatible
- [ ] No database schema changes

### Minor Release (X.Y.0)
- [ ] New features documented
- [ ] Backward compatible
- [ ] No breaking changes
- [ ] New API endpoints documented
- [ ] Database migrations tested
- [ ] Feature flags considered

### Major Release (X.0.0)
- [ ] Breaking changes documented
- [ ] Migration guide created
- [ ] Deprecation notices added
- [ ] Team trained on changes
- [ ] Extended testing performed
- [ ] Database migration strategy planned
- [ ] Client application updates coordinated

## Database Release Checklist

### Schema Changes
- [ ] Database migrations created
- [ ] Migrations tested in DEV
- [ ] Migrations tested in QA
- [ ] Rollback procedures defined
- [ ] Data integrity verified
- [ ] Performance impact assessed

### Data Changes
- [ ] Data migration scripts created
- [ ] Backup procedures verified
- [ ] Data validation rules updated
- [ ] Historical data preserved

## API Release Checklist

### Breaking Changes
- [ ] API versioning strategy applied
- [ ] Deprecation notices added
- [ ] Client applications notified
- [ ] Migration guide provided
- [ ] Backward compatibility period defined

### Non-Breaking Changes
- [ ] New endpoints documented
- [ ] Optional parameters added correctly
- [ ] Response format preserved
- [ ] Authentication requirements unchanged

## Security Release Checklist

### Pre-Release
- [ ] Security issue confirmed
- [ ] Fix developed and tested
- [ ] Security team notified
- [ ] CVE assigned if applicable
- [ ] Penetration testing performed

### Release
- [ ] Expedited release process
- [ ] Security advisory drafted
- [ ] Affected users notified
- [ ] Fix verified in all environments
- [ ] Monitoring increased

### Post-Release
- [ ] Security advisory published
- [ ] Monitoring increased
- [ ] Incident documented
- [ ] Process improvements identified
- [ ] Security scan performed

## Performance Release Checklist

### Pre-Release
- [ ] Performance benchmarks run
- [ ] Load testing performed
- [ ] Memory usage analyzed
- [ ] Database query performance verified
- [ ] API response times measured

### Post-Release
- [ ] Performance metrics monitored
- [ ] Resource utilization checked
- [ ] Database performance verified
- [ ] API performance validated
- [ ] User experience verified

## Docker Release Checklist

### Container Build
- [ ] Docker image builds successfully
- [ ] Image size optimized
- [ ] Security scan passed
- [ ] Multi-stage build used
- [ ] Environment variables configured

### Container Deployment
- [ ] Container starts successfully
- [ ] Health checks configured
- [ ] Resource limits set
- [ ] Networking configured
- [ ] Volumes mounted correctly

## Dependencies Checklist

### Updates
- [ ] Dependencies updated to latest stable versions
- [ ] Security vulnerabilities patched
- [ ] Compatibility verified
- [ ] License compliance checked
- [ ] Breaking changes in dependencies reviewed

### Monitoring
- [ ] Dependency vulnerability scanning enabled
- [ ] Automated updates configured
- [ ] License compliance monitored
- [ ] Performance impact assessed