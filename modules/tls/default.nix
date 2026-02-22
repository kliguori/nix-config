{ config, lib, ... }:
let
  cfg = config.systemOptions.tls;
  impermanenceEnabled = config.systemOptions.impermanence.enable;

  sopsFile = ../../secrets/secrets.yaml;
in
{
  options.systemOptions.tls.enable = lib.mkEnableOption "Enable ACME TLS (Cloudflare DNS-01)";

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      cloudflareToken = {
        inherit sopsFile;
        key = "cloudflare/dns_api_token";
        owner = "root";
        group = "root";
        mode = "0400";
      };

      acmeEmail = {
        inherit sopsFile;
        key = "users/kevin/email";
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };

    sops.templates.cloudflare-dns = {
      content = ''
        CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflareToken"}
      '';
      owner = "root";
      group = "root";
      mode = "0400";
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = config.sops.placeholder."acmeEmail";
      certs."liguorihome.com" = {
        domain = "liguorihome.com";
        extraDomainNames = [ "*.liguorihome.com" ];
        dnsProvider = "cloudflare";
        credentialsFile = config.sops.templates.cloudflare-dns.path;
        group = "acme";
      };
    };

    environment.persistence."/persist".directories = lib.mkIf impermanenceEnabled [
      "/var/lib/acme"
    ];
  };
}
