{
  disk = {
    # --- System disk ---
    system = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NG0N214175Z";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0022"
                "dmask=0022"
              ];
              extraArgs = [
                "-n"
                "MYCBOOT"
              ];
            };
          };

          root = {
            name = "root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-L"
                "mycsys"
              ];
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
                  mountOptions = [ "compress=zstd" ];
                };
              };
            };
          };
        };
      };
    };

    # --- Data disk ---
    data = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y622750V";
      content = {
        type = "gpt";
        partitions = {
          data = {
            name = "data";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-L"
                "mycdata"
              ];
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
                  mountOptions = [ "compress=zstd" ];
                };
                "@shares-wife" = {
                  mountpoint = "/shares/wife";
                  mountOptions = [ "compress=zstd" ];
                };

                # --- Service data ---
                "@paperless" = {
                  mountpoint = "/data/paperless";
                  mountOptions = [ "compress=zstd" ];
                };
                "@consume-kevin" = {
                  mountpoint = "/data/paperless/consume/kevin";
                  mountOptions = [ "compress=zstd" ];
                };
                "@consume-jane" = {
                  mountpoint = "/data/paperless/consume/jane";
                  mountOptions = [ "compress=zstd" ];
                };
                "@consume-household" = {
                  mountpoint = "/data/paperless/consume/household";
                  mountOptions = [ "compress=zstd" ];
                };
                "@postgresql" = {
                  mountpoint = "/data/postgresql";
                  mountOptions = [ "compress=zstd" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
