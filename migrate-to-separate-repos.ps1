# Migration script: splits each project folder into its own GitHub repo
# Reads GITHUB_TOKEN from the environment variable you set before running.

param(
    [string]$Token = $env:GITHUB_TOKEN
)

if (-not $Token) {
    Write-Host "ERROR: Set your GitHub PAT first:" -ForegroundColor Red
    Write-Host '  $env:GITHUB_TOKEN = "ghp_yourTokenHere"' -ForegroundColor Yellow
    exit 1
}

$monorepoPath = "C:\Users\HP\Documents\GitHub\danielawurah"
$githubUser   = "danielawurah"

$projects = @(
    "abac-lifecycle-automation",
    "bulk-identity-provisioning",
    "identity-governance-sod",
    "locally-hosted-ai",
    "nhi-sentinel",
    "pam-jit-access",
    "saml-okta-salesforce",
    "zero-trust-ztna"
)

$headers = @{
    Authorization = "Bearer $Token"
    Accept        = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

# --- Step 1: Create repos on GitHub via API ---
Write-Host "`n=== Creating GitHub repositories ===" -ForegroundColor Cyan

foreach ($project in $projects) {
    $body = @{ name = $project; private = $false; auto_init = $false } | ConvertTo-Json
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" `
            -Method POST -Headers $headers -Body $body -ContentType "application/json"
        Write-Host "  Created: $($response.html_url)" -ForegroundColor Green
    } catch {
        $status = $_.Exception.Response.StatusCode.value__
        if ($status -eq 422) {
            Write-Host "  Already exists (skipping create): $project" -ForegroundColor Yellow
        } else {
            Write-Host "  ERROR creating $project : $_" -ForegroundColor Red
        }
    }
}

# --- Step 2: Init each folder as its own repo and push ---
Write-Host "`n=== Pushing project folders to their repos ===" -ForegroundColor Cyan

# Build authenticated remote URL using token
foreach ($project in $projects) {
    $folderPath = Join-Path $monorepoPath $project
    $remoteUrl  = "https://$Token@github.com/$githubUser/$project.git"

    Write-Host "`n--- $project ---" -ForegroundColor Cyan

    if (-not (Test-Path $folderPath)) {
        Write-Host "  Folder not found, skipping." -ForegroundColor Yellow
        continue
    }

    Push-Location $folderPath

    $nestedGit = Join-Path $folderPath ".git"
    if (Test-Path $nestedGit) { Remove-Item -Recurse -Force $nestedGit }

    git init -q
    git add .
    git commit -q -m "Initial commit: migrated from monorepo"
    git branch -M main
    git remote add origin $remoteUrl
    git push -u origin main --quiet

    Pop-Location
    Write-Host "  Pushed." -ForegroundColor Green
}

# --- Step 3: Remove folders from monorepo ---
Write-Host "`n=== Cleaning up monorepo ===" -ForegroundColor Cyan

Push-Location $monorepoPath

foreach ($project in $projects) {
    $folderPath = Join-Path $monorepoPath $project
    if (Test-Path $folderPath) {
        $nestedGit = Join-Path $folderPath ".git"
        if (Test-Path $nestedGit) { Remove-Item -Recurse -Force $nestedGit }
        git rm -r --cached $project 2>$null
        Remove-Item -Recurse -Force $folderPath
        Write-Host "  Removed: $project" -ForegroundColor Green
    }
}

# Also remove the leftover duplicate folder
$copyFolder = Join-Path $monorepoPath "abac-lifecycle-automation copy"
if (Test-Path $copyFolder) {
    git rm -r --cached "abac-lifecycle-automation copy" 2>$null
    Remove-Item -Recurse -Force $copyFolder
    Write-Host "  Removed: abac-lifecycle-automation copy (duplicate)" -ForegroundColor Green
}

# Remove the migration script itself
git rm --cached migrate-to-separate-repos.ps1 2>$null
Remove-Item -Force (Join-Path $monorepoPath "migrate-to-separate-repos.ps1")

git add -A
git commit -m "chore: migrate project folders to individual repositories"
git push origin main

Pop-Location

Write-Host "`nAll done! Visit https://github.com/$githubUser to see your new repos." -ForegroundColor Green
