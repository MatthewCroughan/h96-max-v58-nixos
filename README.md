# h96-max-v58-nixos

![h96-max-v58](https://github.com/MatthewCroughan/h96-max-v58-nixos/assets/26458780/160e2ea4-484f-4da2-874c-7390ec5c5f74)

This repository is for my own research, development and bringup of the H96 Max V58. Eventual support may be added to [nixos-hardware](https://github.com/NixOS/nixos-hardware/) depending on time and interest.

# Helpful resources

- https://github.com/ncravino/H96_MAX_V58
- https://github.com/colemickens/h96-max-v58-investigation

# Thanks

- [samueldr](https://github.com/samueldr/)
- [colemickens](https://github.com/colemickens/)
- [aciceri](https://github.com/aciceri/)
- [clever22](https://github.com/cleverca22/)
- [k900](https://github.com/k900)
- A few people from the armbian discord

# Usage

1. Get the device into maskrom or loader mode
2. `nix build .#h96-max-v58-image`
3. `rkdeveloptool wl 0 ./result/sd-image/*.img`

# What works?

Working:

- Ethernet
- WiFi
- HDMI
- GPU
- RTC
- USB 3.0
- USB 2.0

Not working:

- Bluetooth
- HDMI Audio
- LEDs
- Infrared Receive

# Todo

- Document usage of `rkdeveloptool` to load SPL via maskrom, provide as flake input, etc.
- Create expect scripts for initial installation similar to [visionfive-nix](https://github.com/MatthewCroughan/visionfive-nix)
- Document decompiled dts and other processes used to get to this point
- Make a pure GPT based image instead of using nixpkgs sdImage infrastructure, because `rkdeveloptool ppt` doesn't like this MBR hybrid stuff
  - Maybe use [holey](https://github.com/samueldr/holey) instead?
  - Figure out how to use systemd-repart as in ./repart.nix.unused
    - It seems that systemd-repart doesn't allow you to set the GPT table
      length, meaning partitions are limited to 2048 for the sector start size.
      But the rk3588 wants u-boot to be placed at sector 64.
