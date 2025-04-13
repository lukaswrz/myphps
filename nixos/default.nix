phps: {
  lib,
  config,
  ...
}: let
  cfg = config.programs.phps;
  inherit (lib) types;
in {
  options.services.myphps = {
    enable = lib.mkEnableOption "myphps";
    phps = lib.mkOption {
      description = ''
        PHPs to use.
      '';
      default = phps;
      type = types.attrsOf types.package;
    };
    prefix = lib.mkOption {
      description = ''
        The prefix for every PHP installation.
      '';
      default = "/var/lib/phps";
      type = types.str;
    };
  };

  config = {
    systemd.tmpfiles.settings =
      builtins.mapAttrs (name: drv: {
        "${cfg.prefix}/${name}"."L+".argument = drv.outPath;
      })
      phps;
  };
}
