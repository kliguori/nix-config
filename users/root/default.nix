{ config, lib, ... }:
let
  enabled = lib.elem "root" config.systemOptions.users;
in
lib.mkIf enabled {
  users.users.root.hashedPassword = "$6$UZmN9CmJmm2mYMVc$Ia3O4psbyXfjM59NEbZY5PBfy.IxIA8yta9F9hYOJ4MVuuFwyrRB1E0uysmG5f8Q1mfZjzlLJ0sES1RQymCUt.";
}
