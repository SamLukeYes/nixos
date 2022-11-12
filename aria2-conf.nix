{ stdenvNoCC
, bt-tracker
}:

stdenvNoCC.mkDerivation {
  name = "aria2-conf";
  buildCommand = ''
    printf "bt-tracker=" | cat - ${bt-tracker} > $out
  '';
}