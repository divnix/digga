{ ... }: {
  services.stubby = {
    enable = true;
    upstreamServers = ''
      - address_data: 1.1.1.1
        tls_port: 853
        tls_auth_name: "cloudflare-dns.com"
      - address_data: 1.0.0.1
        tls_port: 853
        tls_auth_name: "cloudflare-dns.com"
    '';
  };

  environment.etc = {
    "resolv.conf" = {
      text = ''
        options edns0
        nameserver 127.0.0.1
      '';
      mode = "444";
    };
  };

  networking = {
    networkmanager.dns = "none";
    resolvconf.dnsExtensionMechanism = false;
  };
}
