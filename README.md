# Personal Dotfiles

A comprehensive shell configuration system for macOS and Linux with AI-powered git workflows, modular aliases, and automated environment setup.

## Quick Start

### Prerequisites

**Ubuntu/Linux:**
```bash
apt update && apt install -y git curl unzip make
```

**macOS:**
```bash
# Xcode Command Line Tools
xcode-select --install
```

### Installation

```bash
# Clone repository
git clone <your-repo-url> ~/.dotfiles

# Run installation
cd ~/.dotfiles
make install
```

The installer will:
1. Prompt for installation type (Personal/Work)
2. Install all packages from `packages/shared.txt` and type-specific packages
3. Set up shell configuration (zsh with zinit plugin manager)
4. Create necessary symlinks
5. Configure git with custom hooks

### Post-Installation

Restart your terminal or run:
```bash
reload
```

## Customization

### Adding Packages
Edit package lists in `packages/`:
- `shared.txt` - All installations
- `personal.txt` - Personal-only
- `work.txt` - Work-only

OS-specific syntax: `package:macos` or `package:linux`

### Adding Aliases
Create or edit files in `shell/aliases/`:
```bash
# Add to existing category or create new file
echo 'alias myalias="command"' >> shell/aliases/custom
reload
```

### Adding Scripts
Add functions to `scripts/`:
```bash
# Use namespace convention
my_function() {
    echo "Hello"
}
```

### Environment Configuration
Custom configuration in `~/.dotfiles.config` (not tracked):
```bash
export MY_CUSTOM_VAR="value"
```

## AI Features Setup

### Using Gemini (Recommended)
```bash
export GEMINI_API_KEY="your-api-key"
```

### Using AWS Bedrock
Configure AWS credentials with profile `cline-profile` for Bedrock access.

## Security

## Development

### Testing
```bash
make exec-ubuntu         # Test installation in Ubuntu container
make validate-bash       # Run shellcheck validation
shell_performance        # Measure shell startup time
```

### Making Changes
1. Edit files in appropriate directory
2. Run `make set-permissions` if adding new scripts
3. Run `reload` to apply changes
4. Test thoroughly before committing

## Contributing

These are personal dotfiles, but feel free to:
- Fork and adapt for your own use
- Open issues for bugs
- Submit PRs for improvements

## License

Take whatever you want. No restrictions.
