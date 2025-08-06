# Changelog

All notable changes to the CDH Service API project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security


## [1.0.1] - 2025-08-06

### Added
-  added eslint
-  added gitignore
-  added changelog
-  added auto releases
-  add something new
-  add something new

### Fixed
-  updated  test script
-  updated  test script
-  updated gitignore

### Other Changes
- Merge remote-tracking branch 'origin/dev' into dev
- Merge branch 'main' into dev
- Merge pull request #8 from NaumZakletskiy/dev
- Merge pull request #6 from NaumZakletskiy/dev
- Created executeByChunks2.ts
- Merge pull request #5 from NaumZakletskiy/dev
- Merge pull request #4 from NaumZakletskiy/main
- Added releaserc.json
- Merge pull request #3 from NaumZakletskiy/dev
- Added package.json
- Merge pull request #2 from NaumZakletskiy/dev
- Created executeByChunks function
- Create release.yml
- Merge pull request #1 from NaumZakletskiy/dev
- Merge branch 'main' into dev
- created fiture function
- deleted fiture function
- Updated fiture function
- Merge branch 'dev'
- Updated main function

## [1.3.0] - 2025-07-31

### Added
-  enhance automated release process
-  add automated release process

### Changed
-  update yarn.lock
-  bump version to v1.2.2 and finalize CHANGELOG
-  update CHANGELOG.md for v1.2.2 release
-  update CHANGELOG.md for v1.2.1 release

### Fixed
-  improve help functionality in auto-release script
-  clean up duplicate changelog entries
-  add missing port name for ECS service compatibility

### Other Changes
- Deploy to QA (#833)
- Merge Qa Tt Dev (#834)
- Added p-asserted-identity (#832)
- Added P-Asserted-Identity to dial
- Added P-Asserted-Identity to dial
- Added P-Asserted-Identity to dial
- Merge branch 'main' into qa
- Deploy to QA (#829)
- Merge qa into dev (#830)
- Merge remote-tracking branch 'origin/qa' into merge-qa-into-dev
- Fix/recognition max duration (#828)
- Merge branch 'dev' into fix/recognition-max-duration
- added asrTimeout
- added recognitionTimeoutMs
- Deploy to QA (#826)
- Merge qa into dev (#827)
- Merge remote-tracking branch 'origin/qa' into merge-qa-into-dev
- Fixed subflow execution (#825)
- Fixed subflow execution
- Merge remote-tracking branch 'origin/main' into qa
- Deploy to QA (#819)
- Creo 3007 add the ability to select a specific node in the flow extension (#821)
- Added Fix
- Added nodeId to flowIntegration extension type
- Merge qa into dev (#818)
- Fixed ws node execution events for child flow (#817)
- Merge remote-tracking branch 'origin/qa' into hotfix/ws-events
- Hotfix/deletion flow context after agent execution (#814)

## [1.2.2] - 2025-07-24

### Added
- ASR timeout configuration for speech recognition
- Recognition timeout configuration for improved call handling

### Changed

### Deprecated

### Removed

### Fixed
- Recognition timeout handling in Jambonz call processing
- Subflow execution issues in flow processing
- Duplicate changelog entries cleanup

### Security


## [1.2.1] - 2025-07-15

### Added
- Node selection capability in flow extension functionality
- NodeId support in flowIntegration extension type

### Changed

### Deprecated

### Removed

### Fixed
- WebSocket node execution events for child flow execution
- Flow context deletion after agent execution in asynchronous flows
- Flow context deletion in synchronous agent execution
- ECS service compatibility with missing port name
- WebSocket event handling for nested flow structures
- Repository URL in release notes script

### Security


## [1.2.0] - 2025-06-26

### Added
- DTMF (Dual-Tone Multi-Frequency) functionality for Jambonz webhook handling
- Dial functionality with configurable caller ID support
- Flow integration logic for executing sub-flows
- Tags endpoint for flows with filtering capabilities
- Session ID support in async flow execution responses
- Session ID tracking in extension execution and WebSocket events
- Enhanced logging for Jambonz response strategies

### Changed
- Improved flow execution process with better node execution handling
- Enhanced Jambonz call handling service with support for digits and dial targets
- Refactored flow node execution service for better performance
- Updated release workflow to include --passWithNoTests flag

### Deprecated
- Old Jambonz webhook endpoint (marked for future removal)

### Fixed
- Flow ID format issues
- Session handling for cron triggers
- Target assignment in dial strategy


## [1.1.0] - 2025-06-17

### Added
- AI Agent Flow module with controller, service, and interface for managing AI-powered workflows
- Flow phone trigger endpoint with proper permission controls

### Changed
- Phone trigger permissions changed from DELETE to READ for getFlowPhoneTrigger method
- Refactored flow retrieval to include projection in flowsByParams method
- Improved Jambonz webhook handling with organization ID header support
- Refactored FlowController to separate phone trigger logic into PhoneTriggerController

### Deprecated

### Removed
- Phone trigger handling from FlowController (moved to dedicated PhoneTriggerController)

### Fixed

### Security
- Removed error details from response in handleCall method to prevent information leakage


## [1.0.1] - 2025-06-13

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [1.0.0] - 2025-01-06

### Added
- Professional release management system with semantic versioning
- Automated GitHub release workflow (.github/workflows/release.yml)
- Release automation scripts (scripts/release.sh, scripts/generate-release-notes.js)
- Comprehensive release process documentation (docs/RELEASE_PROCESS.md)
- Release troubleshooting guide (docs/TROUBLESHOOTING.md)
- Release checklist for consistent processes (docs/RELEASE_CHECKLIST.md)
- CODEOWNERS file to require approval for changes to the repository
- Initial production-ready version of CDH Service API
- Complete NestJS application with comprehensive modules:
  - AI Agent management and execution
  - Flow-based automation system
  - User and organization management
  - Authentication and authorization
  - Data upload and processing
  - Analytics and logging
  - WebSocket real-time communication
  - Trigger-based workflows (cron, email, phone, endpoint)
  - Widget and dashboard management
- Docker containerization support
- Comprehensive test suite with unit and integration tests
- AWS integration for Cognito, S3, SES, and Lambda services
- Jambonz integration for voice communications
- Redis caching and session management
- MongoDB database with schema definitions
- Bull queue system for background processing
- Sentry error tracking and monitoring
- Swagger API documentation

### Changed

### Deprecated

### Removed

### Fixed

