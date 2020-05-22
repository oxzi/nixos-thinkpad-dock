{ stdenv, lib
, environment ? null
, dockEvent ? null
, undockEvent ? null
}:

stdenv.mkDerivation {
  name = "thinkpad-dock-acpi_event.sh";

  src = lib.cleanSource ./.;

  postPatch = ''
    substituteInPlace acpi_event.sh \
      --subst-var-by environment ${environment} \
      --subst-var-by dockEvent ${dockEvent} \
      --subst-var-by undockEvent ${undockEvent}
  '';

  installPhase = "cp acpi_event.sh $out";
}
