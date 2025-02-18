{config,...}:
let
in
{
  users.users.nouseforaname = {
    isNormalUser = true;
    description = "nouseforaname";
    extraGroups = [ "docker" "dialout" "tty" "networkmanager" "wheel" "adbusers" ];
  };
}
