{ fetchpatch2 }:
[
  {
    name = "patch";
    patch = fetchpatch2 {
      url = "https://raw.githubusercontent.com/armbian/build/96abb9e94490aca5b8111e359bc9b50277f1d41d/patch/kernel/rockchip-rk3588-edge/0802-wireless-add-clk-property.patch";
      hash = "sha256-pRVVLg9rGmj9z5wLbeN7VAyxVpGaMeJmZF3VgH0zkek=";
    };
  }
  {
    name = "patch";
    patch = fetchpatch2 {
      url = "https://raw.githubusercontent.com/armbian/build/27a07d918e3e010f74dc24fcc17f510a8eb35252/patch/kernel/rockchip-rk3588-edge/0801-wireless-add-bcm43752.patch";
      hash = "sha256-qTu63rRZgcD+17Utild0I0X2h1ShtoR18QqcaNdhho8=";
    };
  }
]
