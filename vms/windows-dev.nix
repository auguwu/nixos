{pkgs, ...}: let
  name = "windows-dev";
  disk = "/var/lib/noel/virtual-machines/${name}.qcow2";
  ovmf = "${pkgs.OVMF.fd}/FV/OVMF_CODE.fd";
in {
  environment.systemPackages = [pkgs.qemu_kvm];
  systemd = {
    tmpfiles.rules = [
      "d /var/lib/noel/virtual-machines root root -"
    ];

    # services.${name} = {
    #   description = "Windows VM (QEMU)";
    #   after = ["network.target"];
    #   wantedBy = ["multi-user.target"];
    #   serviceConfig = {
    #     Type = "simple";
    #     Restart = "always";
    #     ExecStart = ''
    #       ${pkgs.qemu_kvm}/bin/qemu-system-x86_64                              \
    #         -enable-kvm                                                        \
    #         -machine type=q35,accel=kvm                                        \
    #         -cpu host,hv_related,hv_vaptic,hv_spinlocks=0x1fff                 \
    #         -smp 4                                                             \
    #         -m 16G                                                             \
    #         -drive file=${disk},if=virtio,format=qcow2,cache=none,aio=io_uring \
    #         -netdev user,id=net0,hostfwd=tcp::2222-:22                         \
    #         -device virtio-net-pci,netdev=net0                                 \
    #         -nographic                                                         \
    #         -bios ${ovmf}
    #     '';
    #   };
    #};
  };
}
