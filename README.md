### These are my personal dotfiles, take whatever you want.

## Installation

### Pre-steps for Ubuntu

#### Execute the following instruction in the terminal

```bash
apt update && apt install -y git curl unzip make
```

### Steps

- Download the repository into `~/.dotfiles`
- Execute `make install`

## Configuration

- Create shortcuts to move applications between displays.
- Disable Spotlight:
  - Search in system settings and uncheck all the options.
  - Execute `sudo mdutil -a -i off` in the terminal.
  - Verify it's off: `sudo mdutil -a -s`.
- Install Autofirma.
- Configure Stats (import config from assets).
- Configure the dock.
- Configure the top bar (HiddenBar, Stats, AlDente).
