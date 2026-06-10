# Link validation — Airbnb tooling

Extends the global link validation rule with Airbnb-specific fetch tooling.

- **Use `mcp__airbnb-core__fetch` for internal URLs** (git.musta.ch, airbnb.biz, *.airbnb.com, internal docs). Fall back to `WebFetch` for public URLs.
