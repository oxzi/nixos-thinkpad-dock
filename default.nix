{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.thinkpad-dock;

  environment = pkgs.writeText "environment.sh" cfg.environment;
  dockEvent   = pkgs.writeText "dock.sh"        cfg.dockEvent;
  undockEvent = pkgs.writeText "undock.sh"      cfg.undockEvent;

  acpiEvent = pkgs.callPackage ./acpi_event.nix {
     inherit environment dockEvent undockEvent;
  };
in {
  options.hardware.thinkpad-dock = {
    enable = mkEnableOption "Register ThinkPad ACPI event handler for dock";

    environment = mkOption {
      default = "";
      type = types.str;
      description = "Bash script for environment variables.";
    };

    dockEvent = mkOption {
      default = "";
      type = types.str;
      description = "Bash script to be executed on docking.";
    };

    undockEvent = mkOption {
      default = "";
      type = types.str;
      description = "Bash script to be executed on undocking.";
    };
  };

  config = mkIf cfg.enable {
    services.acpid = {
      enable = true;
      logEvents = true;  # XXX

      handlers.thinkpadDock = {
        event = "ibm/hotkey";
        action = builtins.readFile acpiEvent;
      };
    };
  };
}
