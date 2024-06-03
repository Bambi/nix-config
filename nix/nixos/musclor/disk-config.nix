{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1; # Needs to be first partition
            };
            swap = {
              size = "1G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                askPassword = true;
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  # Subvolumes must set a mountpoint in order to be mounted,
                  # unless their parent is mounted
                  subvolumes = {
                    # Subvolume name is different from mountpoint
                    "/rootfs" = {
                      mountOptions = [ "noatime" "discard=async" ];
                      mountpoint = "/";
                    };
                    # Subvolume name is the same as the mountpoint
                    "/home" = {
                      mountOptions = [ "noatime" "compress=zstd" ];
                      mountpoint = "/home";
                    };
                    # Parent is not mounted so the mountpoint must be set
                    "/nix" = {
                      mountOptions = [ "compress=zstd" "noatime" "discard=async" ];
                      mountpoint = "/nix";
                    };
                    "/var" = {
                      mountOptions = [ "compress=zstd" "noatime" "discard=async" ];
                      mountpoint = "/var";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

