# GitHub Actions Scripts

This directory contains scripts used by the GitHub Actions workflow.

## Scripts

### `check_instructor_token.sh`

**Purpose**: Validates that the INSTRUCTOR_TESTS_TOKEN secret is configured for accessing the private test repository.

**Usage**:
```bash
INSTRUCTOR_TESTS_TOKEN=${{ secrets.INSTRUCTOR_TESTS_TOKEN }} ./check_instructor_token.sh
```

**Behavior**:
- Checks if the INSTRUCTOR_TESTS_TOKEN environment variable is set
- Provides student-friendly error messages if the token is not configured
- Exits with code 0 if token is present, code 1 if missing

**Used By**: `.github/workflows/classroom.yml`

This script ensures students receive a clear message if the instructor hasn't yet configured the required access token for automated testing.
