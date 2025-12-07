#!/usr/bin/env powershell
# Zenith Framework v1.0.0 - GitHub Release Deployment Script
# 
# Usage (after creating the GitHub repository at https://github.com/zenithframework/zenlang):
#   powershell -ExecutionPolicy Bypass -File deploy-to-github.ps1
#
# Steps performed:
#   1. Configure Git remote (origin)
#   2. Ensure main branch
#   3. Push main branch to GitHub
#   4. Push v1.0.0 tag to GitHub
#   5. Verify push succeeded
#   6. Display next manual steps (create release on GitHub web)

param(
    [string]$GithubOrg = "zenithframework",
    [string]$RepoName = "zenlang"
)

$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"

Write-Host @"
========================================
 Zenith Framework v1.0.0
 GitHub Release Deployment Script
========================================
`n
"@ -ForegroundColor Cyan

# Verify we are in the correct directory
if (-not (Test-Path ".git" -Type Container)) {
    Write-Host "ERROR: Not in a Git repository directory. Please run from repository root." -ForegroundColor Red
    exit 1
}

$repoUrl = "https://github.com/$GithubOrg/$RepoName.git"

Write-Host "[1/5] Configuring Git remote..." -ForegroundColor Yellow
git remote set-url origin $repoUrl
if ($LASTEXITCODE -ne 0) {
    Write-Host "  WARNING: Could not update remote (may not exist yet)" -ForegroundColor Yellow
}

Write-Host "[2/5] Ensuring main branch..." -ForegroundColor Yellow
git branch -M main
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Could not rename branch to main" -ForegroundColor Red
    exit 1
}

Write-Host "[3/5] Pushing main branch to GitHub..." -ForegroundColor Yellow
git push -u origin main --force
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Could not push main branch" -ForegroundColor Red
    Write-Host "  Verify repository exists at: $repoUrl" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✓ Main branch pushed successfully" -ForegroundColor Green

Write-Host "[4/5] Pushing v1.0.0 tag..." -ForegroundColor Yellow
git push origin v1.0.0
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Could not push v1.0.0 tag" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ v1.0.0 tag pushed successfully" -ForegroundColor Green

Write-Host "[5/5] Verifying push..." -ForegroundColor Yellow
$mainLog = git log origin/main --oneline -1 2>&1 | Out-String
$tagList = git ls-remote --tags origin 2>&1 | Where-Object { $_ -match "v1\.0\.0" } | Out-String

if ($mainLog -and $tagList) {
    Write-Host "  ✓ Remote verification successful" -ForegroundColor Green
} else {
    Write-Host "  WARNING: Could not verify remote push; check GitHub manually" -ForegroundColor Yellow
}

Write-Host @"
`n
========================================
 DEPLOYMENT COMPLETE
========================================

Repository: https://github.com/$GithubOrg/$RepoName
Branch: main
Tag: v1.0.0

Next Steps:

1. VERIFY ON GITHUB (automatic):
   - GitHub Actions CI should start automatically
   - Check: https://github.com/$GithubOrg/$RepoName/actions

2. CREATE RELEASE (manual):
   - Go to: https://github.com/$GithubOrg/$RepoName/releases
   - Click "Create a new release"
   - Select tag: v1.0.0
   - Title: "Zenith v1.0.0 - Production Release"
   - Description: Copy from RELEASE_DRAFT.md (or paste the text below)
   - Check "Set as the latest release"
   - Click "Publish release"

3. MONITOR CI (automatic):
   - CI workflow should test on Windows and Ubuntu
   - Pages workflow should deploy docs to GitHub Pages

========================================

Release Body (copy this for the GitHub release):

"@ -ForegroundColor Cyan

# Read and display release draft
if (Test-Path "RELEASE_DRAFT.md") {
    $releaseDraft = Get-Content "RELEASE_DRAFT.md" -Raw
    Write-Host $releaseDraft
} else {
    Write-Host "(RELEASE_DRAFT.md not found in current directory)" -ForegroundColor Yellow
}

Write-Host @"
`n
========================================
 Questions or Issues?
========================================

- Read GITHUB_QUICK_START.md for step-by-step web UI instructions
- Read CONTRIBUTING.md for development guidelines
- Check GitHub Actions logs: https://github.com/$GithubOrg/$RepoName/actions

========================================
"@ -ForegroundColor Cyan
