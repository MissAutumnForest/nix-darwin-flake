# nix-darwin-flake
Autum's Nix Darwin Flake :)

## Instructions

1. Install nix-darwin `sh <(curl -L https://nixos.org/nix/install)`
2. Clone this repo
3. Copy `flake.nix` into the `~/.config/nix-darwin/` directory (`cp ./flake.nix ~/.config/nix-darwin/flake.nix`)
4. Bootstrap nix-darwin with `nix run nix-darwin -- switch --flake ~/.config/nix-darwin`
5. Going forward you can update nix with `darwin-rebuild switch --flake ~/.config/nix-darwin`
