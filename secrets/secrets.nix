let
  # set ssh public keys here for your system and user
  system = "";
  user = "";
  allKeys = [ system user ];
in
{
  "secret.age".publicKeys = allKeys;
}
