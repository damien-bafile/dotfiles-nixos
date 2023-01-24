{ pkgs, ... }:

with pkgs; [
  # programs
  cargo
  doppler
  fd
  gcc
  ghc
  jetbrains.datagrip
  just
  lazydocker
  nodejs
  powershell
  python3Full
  ripgrep
  rustc
  rustfmt
  virtualenv
  yarn

  # language servers
  gopls
  #haskell-language-server
  nil
  nodePackages."@prisma/language-server"
  nodePackages."bash-language-server"
  nodePackages."dockerfile-language-server-nodejs"
  nodePackages."graphql-language-service-cli"
  nodePackages."pyright"
  nodePackages."typescript"
  nodePackages."typescript-language-server"
  nodePackages."vscode-langservers-extracted"
  nodePackages."yaml-language-server"
  rust-analyzer
  sumneko-lua-language-server
  terraform-ls
]
