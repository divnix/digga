{ lib, ... }:
{
  mkVersion = src: "${lib.substring 0 8 src.lastModifiedDate}_${src.shortRev}";
}
