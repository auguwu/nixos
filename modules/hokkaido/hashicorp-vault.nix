{
  services.vault = {
    enable = true;
    storageBackend = "file";
    telemetryConfig = ''
      prometheus_retention_time = "30s"
      disable_hostname = true
    '';

    extraConfig = ''
      ui = true
      ui_addr = "http://localhost:8201"
      cluster_name = "Noel"
    '';
  };
}
