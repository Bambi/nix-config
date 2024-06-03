{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvmen1p1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "256M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "120G";
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
            encryptedSwap = {
              size = "1G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
          };
        };
      };
    };
  };
}

