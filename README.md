# home

## Desired components

* rails

## Secrets Management Roadmap

### Current state

All managed files are unencrypted. The `private_` prefix on `private_dot_ssh/` controls file permissions but does not encrypt contents. No secrets are stored in this repo.

### Strategy

Use **1Password CLI (`op`)** as the primary secrets backend via chezmoi's built-in `onepassword` template functions. 1Password is already bootstrapped on target machines via `run_once_install_1password.sh`, so `op` authentication becomes the single prerequisite for `chezmoi init --apply` to fully hydrate a new machine.

Use **age** encryption as a secondary backend for environments where 1Password is unavailable at apply time (e.g. airgapped or disconnected workstations).

### Candidates for encryption

| File | Approach | Notes |
|------|----------|-------|
| `private_dot_ssh/` | 1Password documents | SSH keys and host configs with sensitive entries |
| `dot_gitconfig-work.tmpl` | 1Password fields | Signing key references |
| `dot_gitconfig-personal.tmpl` | 1Password fields | Signing key references |
| `dot_bashrc.tmpl` | Review for tokens | Encrypt if env vars contain secrets |

### Bootstrap sequence (new machine)

1. Install chezmoi
2. Install and authenticate 1Password CLI (`op signin`)
3. `chezmoi init --apply bigfleet/home`

### TODO

- [ ] Set up age key pair and store private key in 1Password
- [ ] Convert `private_dot_ssh/` to `encrypted_private_dot_ssh/` or 1Password document templates
- [ ] Add 1Password template functions to gitconfig templates for signing keys
- [ ] Audit `dot_bashrc.tmpl` for any values that should be secret
- [ ] Test full `chezmoi init --apply` cycle from clean machine
- [ ] Document WSL-specific 1Password CLI integration
