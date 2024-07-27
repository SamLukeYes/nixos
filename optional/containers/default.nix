{
  services.kubernetes = {
    masterAddress = "127.0.0.1";
    roles = [ "master" "node" ];
  };
}