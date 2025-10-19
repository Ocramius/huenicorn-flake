# Huenicorn flake

This is a flake that provides https://gitlab.com/openjowelsofts/huenicorn as a built binary.

It will be upstreamed to nixpkgs after leveling up some systemd-fu around here :-)

## Usage

Import this in your flake:

```
{
  description = "your flake description";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    huenicorn = {
      url = "github:ocramius/huenicorn-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    }
  };
  
  outputs = { nixpkgs, dummy-extension }:
  {
    nixosConfigurations.my-system = nixpkgs.lib.nixosSystem {
      modules = [
        { pkgs, huenicorn }: {
          users.users.my-user.packages = [
            huenicorn # makes huenicorn accessible to user `my-user` on machine `my-system`
          ];
        }
      ];
    };
  };
}
```

A nixos integration (via systemd) will come later.
