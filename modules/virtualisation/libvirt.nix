{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      runAsRoot = true;
      package = pkgs.qemu_kvm;
    };
  };

  environment.systemPackages = with pkgs; [virt-manager];
}
