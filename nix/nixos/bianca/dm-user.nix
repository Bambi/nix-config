_: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dm = {
    hashedPassword = "$y$j9T$gnbdTw.SyjFsl82aWGKzj0$yDoP35i/sMQ/iaKwla3IngMMLFKirPgCdVC9XL6E2TB";
    isNormalUser = true;
    description = "dm";
    extraGroups = [ "input" "wheel" "video" "audio" ];
  };
}
