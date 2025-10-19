# Huenicorn flake

This is a flake that provides https://gitlab.com/openjowelsofts/huenicorn as a built binary.

It will be upstreamed to nixpkgs after leveling up some systemd-fu around here :-)

Note that this is still very rough, and won't really be usable immediately (other than having a pre-built binary
in the nix store): help welcome.

## Usage

Import this in your flake:

```nix
{
  description = "your flake description";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    huenicorn = {
      url = "github:ocramius/huenicorn-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { nixpkgs, huenicorn }:
  {
    nixosConfigurations.my-system = nixpkgs.lib.nixosSystem {
      modules = [
        { huenicorn }: {
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
