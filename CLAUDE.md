# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for shell configuration, aliases, scripts, and development environment setup. Supports both macOS and Linux, with separate installation profiles for "Personal" and "Work" configurations.

## Installation & Setup

### Initial Installation
```bash
# Download repository to ~/.dotfiles
make install
```

The install command:
- Prompts for verbose mode and installation type (Personal/Work)
- Updates/upgrades system packages
- Installs private dotfiles if configured
- Loads OS-specific repositories (Linux only)
- Installs packages from `packages/shared.txt` and type-specific files
- Sets zsh as default shell
- Creates necessary symlinks

### Other Make Commands
```bash
make help                    # Show all available commands
make install-references      # Install symlinks only
make install-private         # Install private dotfiles
make set-permissions         # Set executable permissions on scripts
make exec-ubuntu             # Run Ubuntu container for testing
make validate-bash           # Run shellcheck validation
```

## Architecture

### Directory Structure

- **`shell/`** - Shell configuration and aliases
  - `.shellrc` - Main shell initialization (sourced by both bash and zsh)
  - `aliases/` - Modular alias files (git, docker, ai, system, etc.)
  - `zsh/.zshrc` - Zsh-specific config with zinit plugin manager
  - `bash/.bashrc` - Bash-specific config
  - `completions/` - Shell completion scripts

- **`scripts/`** - Reusable shell functions
  - `_main` - Sources all scripts automatically
  - `_core/` - Core utilities (system, prompt, git, etc.)
  - Organized by category (ai, git, network, process, etc.)

- **`git/`** - Git configuration
  - `.gitconfig` - Global git config with conditional includes for work
  - `hooks/` - Git hooks

- **`installation/`** - Installation scripts
  - `install` - Main installation script
  - `install_utils` - Helper functions for package installation
  - `packages/` - Package management logic

- **`packages/`** - Package lists
  - `shared.txt` - Common packages for all installations
  - `personal.txt` - Personal-specific packages
  - `work.txt` - Work-specific packages
  - Format: `package_name` or `package_name:os` (os = linux|macos)

- **`private/`** - Private dotfiles (git-ignored, installed separately)
  - Used for work-specific or sensitive configurations

- **`raycast/`** - Raycast extension scripts
- **`tmux/`** - Tmux configuration
- **`fzf/`** - FZF preview configurations

### Loading Mechanism

1. Shell starts (zsh or bash)
2. Sources `shell/.shellrc` which:
   - Sets environment variables (EDITOR, colors, boolean constants)
   - Sources `shell/aliases/_main` (loads all alias files)
   - Sources `scripts/_main` (loads all script files)
   - Sources private dotfiles if they exist
   - Loads custom config from `~/.dotfiles.config`

3. `scripts/_main` sources `scripts/_core/main` which loads all core utilities
4. All scripts in `shell/aliases/` and `scripts/` are automatically sourced

### Key Design Patterns

**Auto-loading**: Both aliases and scripts use a `_main` file that automatically sources all sibling files in their directories, avoiding manual imports.

**Namespace functions**: Core utilities are namespaced (e.g., `system::install_package`, `prompt::ask_yes_no`, `git_*`).

**Conditional OS logic**: Package files support `package:os` syntax. Scripts use `system::is_linux` and `system::is_macos` for OS-specific behavior.

**Confirmation wrappers**: Destructive operations like `git reset --hard` are wrapped with `confirm_action` to require user confirmation.

**FZF integration**: Interactive selection for git branches, commit history, and aliases using fzf.

## Common Development Commands

### Testing Changes
```bash
reload                       # Reload shell configuration
source ~/.zshrc             # Alternative reload (zsh)
shell_performance           # Measure shell startup time
```

### Validation
```bash
make validate-bash          # Run shellcheck on all scripts
make set-permissions        # Fix script permissions
```

### Package Management
Packages are defined in text files under `packages/`:
- Add new packages to `shared.txt` (all installs) or `personal.txt`/`work.txt` (specific installs)
- Use `package:macos` or `package:linux` for OS-specific packages

### Adding New Aliases
1. Add to appropriate file in `shell/aliases/` (or create new category file)
2. No need to modify `_main` - auto-loaded
3. Run `reload` to apply changes

### Adding New Scripts
1. Add to appropriate file in `scripts/` (or create new category)
2. Use namespace convention: `category::function_name`
3. Run `reload` to apply changes

## Important Git Workflow

### AI-Powered Git Helpers
```bash
gcm [notes]                  # Generate commit message from staged changes
gcmc [notes]                 # Generate commit message and copy to clipboard
gcheck [notes]              # AI check for sensitive data/issues in changes
```

These functions use `ask_ai` which routes to either Gemini (if `GEMINI_API_KEY` is set) or AWS Bedrock.

### Security Guidelines

**CRITICAL**: NO sensitive data should ever be committed to this repository - not in any directory, including `private/`:
- NO API keys, tokens, or secrets
- NO passwords or credentials
- NO private keys or certificates
- NO work-specific credentials or tokens

Sensitive data must ONLY exist outside the repository:
- Use environment variables set in your shell profile (outside this repo)
- Use system keychain/credential managers
- Reference external configuration files that are never tracked

Always use `gcheck` before committing to scan for accidentally staged sensitive data. The `private/` directory is for non-sensitive work-specific configurations only, never for secrets.

### Git Worktree Management
```bash
gw <branch-name>            # Create worktree in ../<project>-trees/<branch>/
```

Creates organized worktrees outside main repo. Handles remote branch tracking automatically. Blocks protected branches (main/master/mainline).

### Common Git Aliases
See `shell/aliases/git` for extensive git shortcuts. Key ones:
- `gs`, `ga`, `gc`, `gpull`, `gpush` - Standard operations
- `gl` - Interactive fzf log viewer with preview
- `gch <branch>` - Checkout with fzf selection
- `gac "message"` - Add all + commit
- `gacpush "message"` - Add all + commit + push

## Environment Variables

Required/optional environment variables:
- `DOTFILES_PATH` - Path to dotfiles repo (set to `$HOME/.dotfiles` by install)
- `DOTFILES_PRIVATE_PATH` - Path to private dotfiles
- `EDITOR` - Auto-detected (cursor > code > idea > nano)
- `GEMINI_API_KEY` - Optional, for AI features (falls back to Bedrock)
- Shell boolean constants: `TRUE=0`, `FALSE=1` (shell exit code convention)

## Notes

- Shell uses exit code convention: `TRUE=0`, `FALSE=1` (success = 0 in shell)
- All scripts should use `system::` namespace functions for OS compatibility
- The `.no-commit` suffix is used for local overrides (e.g., `Makefile.no-commit`)
- Private dotfiles are expected at `$DOTFILES_PATH/private/dotfiles/`
- Zinit is used for zsh plugin management with lazy loading for performance
