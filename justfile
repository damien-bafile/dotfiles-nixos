clean:
    nix store optimise --verbose
    nix store gc --verbose

macbookpro command profile:
    darwin-rebuild {{ command }} --flake ".#macbookpro-{{profile}}"
    rm -rf ./result

desktop command:
    sudo nixos-rebuild {{ command }} --flake ".#nixosDesktop"
    rm -rf ./result

update:
    nix flake update
