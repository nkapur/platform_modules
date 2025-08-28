# Platform Modules
Repo to house Terraform modules and Helm charts that may be used by multiple applications.

## Repository Setup

### Remote
The following command was run once by repository admin to set up Github Pages to serve Helm charts.

```bash
gh api --method POST \
    /repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pages \ 
    -f 'source[branch]=master' -f 'source[path]=/docs'
 ```

### Local
As CODEOWNERs and branch protection rules are paid features, this repository uses Git hooks to enforce standards. To enable them, please run the following command once after cloning the repository:

```bash
chmod +x .githooks/*
git config core.hooksPath .githooks
```

## Helm Client (Local or remote) 

### Setup
```bash
helm repo add platform-modules https://nkapur.github.io/platform_modules
helm repo update
```

### Verify
```bash
helm search repo fastapi-service
```

should output the following (or similar) on stdout
```bash
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                                       
platform-modules/fastapi-service        0.1.0           1.0.0           A reusable Helm chart for deploying standard Fa...
```