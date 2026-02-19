{
  disk = {
    system = {
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
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };

    data = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y622750V";
      content = {
        type = "gpt";
        partitions = {
          crypt = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptdata";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  # --- Media ---
                  "@movies" = {
                    mountpoint = "/media/movies";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@tv" = {
                    mountpoint = "/media/tv";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@music" = {
                    mountpoint = "/media/music";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@audiobooks" = {
                    mountpoint = "/media/audiobooks";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@books" = {
                    mountpoint = "/media/books";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@games" = {
                    mountpoint = "/media/games";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  # --- Shares ---
                  "@shares-kevin" = {
                    mountpoint = "/shares/kevin";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@shares-jane" = {
                    mountpoint = "/shares/jane";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  # --- Service data ---
                  "@paperless" = {
                    mountpoint = "/data/paperless";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@consume-kevin" = {
                    mountpoint = "/data/paperless/consume/kevin";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@consume-jane" = {
                    mountpoint = "/data/paperless/consume/jane";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@consume-household" = {
                    mountpoint = "/data/paperless/consume/household";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@postgresql" = {
                    mountpoint = "/data/postgresql";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
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
