# GitHub Enterprise (GHE) access

Use the `gh` CLI for all GitHub operations. Airbnb has two GHE instances — always set `GH_HOST` correctly before running any `gh` command.

| Context | GH_HOST |
|---|---|
| Internal Airbnb code | `git.musta.ch` |
| BizTech code | `github.airbnb.biz` |

**Usage:**
```bash
# Internal Airbnb
GH_HOST=git.musta.ch gh repo view Airbnb/some-repo

# BizTech
GH_HOST=github.airbnb.biz gh repo view Airbnb-ITX/gcp-iap-connector
```

BizTech repos are identifiable by org names like `Airbnb-ITX` or explicit mentions of "BizTech" in context. When in doubt, default to `git.musta.ch`.
