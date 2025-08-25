# Ensure interactive session commands
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Add Spicetify to PATH
fish_add_path /home/nilay/.spicetify

# Bun setup
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# nvm setup (ensure nvm is sourced correctly for Fish
set --universal nvm_default_version lts

# Add Go binary path
fish_add_path /usr/local/go/bin

# PNPM setup
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path $PNPM_HOME

# Optional: Initialize Starship prompt (uncomment if you use Starship)
# starship init fish | source
set -gx PATH /snap/bin $PATH
