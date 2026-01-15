{pkgs, ...}: {
  virtualization.noelware.eous = {
    enable = true;
    daemon = {
      backends = ["qemu"];
      settings = {};

      qemu = pkgs.qemu_kvm;
    };
  };
}
