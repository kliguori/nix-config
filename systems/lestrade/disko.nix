{
  disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NG0N214175Z";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        crypt = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            content = {
              type = "lvm_pv";
              vg = "vg";
            };
          };
        };
      };
    };
  };

  lvm_vg."vg" = {
    type = "lvm_vg";
    lvs = {
      swap = {
        size = "40G"; 
        content = {
          type = "swap";
          resumeDevice = true;
        };
      };

      root = {
        size = "100%FREE";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "@nix" = {
              mountpoint = "/nix";
              mountOptions = [ "compress=zstd" "noatime" ];
            };
            "@home" = {
              mountpoint = "/home";
              mountOptions = [ "compress=zstd" "noatime" ];
            };
            "@persist" = {
              mountpoint = "/persist";
              mountOptions = [ "compress=zstd" "noatime" ];
            };
          };
        };
      };
    };
  };
}
