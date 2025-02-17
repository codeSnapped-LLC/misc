# GitFlow Workflow Guide

## Overview
This repository follows the GitFlow branching model with:
- `main` branch for production releases
- `develop` branch for integration of features
- Feature branches branched from `develop`
- Release branches for preparing releases

## Branching Strategy

### Feature Development
1. Start from develop branch:
```bash
git checkout develop
git pull
```
2. Create feature branch:
```bash
git flow feature start STORY-123-short-description
```
3. Make commits and push:
```bash
git push -u origin feature/STORY-123
```
4. Finish feature (merges to develop):
```bash
git flow feature finish STORY-123
```

### Release Preparation
1. Start release branch:
```bash
git flow release start 1.2.0
```
2. Update version numbers/changelog
3. Finish release (merges to main and develop):
```bash
git flow release finish 1.2.0
```

## Automated Versioning
This repo includes GitVersion configuration that:
- Automatically increments semantic versions
- Generates version numbers based on git history
- Available via CI pipelines or local `gitversion` CLI

## Setup Requirements
- git-flow AVH edition
- GitVersion (brew install gitversion)
