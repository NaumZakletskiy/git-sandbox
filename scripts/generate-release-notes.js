#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

function generateReleaseNotes(version) {
  const changelogPath = path.join(__dirname, '..', 'CHANGELOG.md');
  
  if (!fs.existsSync(changelogPath)) {
    console.error('CHANGELOG.md not found');
    process.exit(1);
  }

  const changelog = fs.readFileSync(changelogPath, 'utf8');
  const lines = changelog.split('\n');
  
  // Remove 'v' prefix if present for matching
  const versionToFind = version.replace(/^v/, '');
  
  let inTargetVersion = false;
  let releaseNotes = [];
  let foundVersion = false;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    
    // Check if this is a version header
    if (line.startsWith('## [')) {
      if (inTargetVersion) {
        // We've reached the next version, stop collecting
        break;
      }
      
      // Check if this is our target version
      const versionMatch = line.match(/^## \[([^\]]+)\]/);
      if (versionMatch && versionMatch[1] === versionToFind) {
        inTargetVersion = true;
        foundVersion = true;
        continue; // Skip the version header itself
      }
    }
    
    // If we're in the target version section, collect the content
    if (inTargetVersion) {
      releaseNotes.push(line);
    }
  }

  if (!foundVersion) {
    console.error(`Version ${version} not found in CHANGELOG.md`);
    process.exit(1);
  }

  // Clean up the release notes
  let cleanedNotes = releaseNotes
    .filter(line => line.trim() !== '') // Remove empty lines at start/end
    .join('\n')
    .trim();

  // Add header and footer
  const output = `## What's Changed

${cleanedNotes}

**Full Changelog**: https://github.com/CloudDataHub/cdh-service-api/blob/main/CHANGELOG.md#${versionToFind.replace(/\./g, '')}`;

  console.log(output);
}

// Get version from command line argument
const version = process.argv[2];
if (!version) {
  console.error('Usage: node generate-release-notes.js <version>');
  process.exit(1);
}

generateReleaseNotes(version);