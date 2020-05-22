{ stdenv, lib
, dockEvent ? null
, undockEvent ? null
}:

stdenv.mkDerivation {
  name = "thinkpad-dock-acpi_event.sh";

  src = lib.cleanSource ./.;

  postPatch = ''
    substituteInPlace acpi_event.sh \
      --subst-var-by dockEvent ${dockEvent} \
      --subst-var-by undockEvent ${undockEvent}
  '';

  installPhase = "cp acpi_event.sh $out";
}
