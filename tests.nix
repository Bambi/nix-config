{ self, inputs, ... }:
inputs.namaka.lib.load {
  src = ./tests;
  inputs = {
    bianca = self.nixosConfigurations.bianca;
    musclor = self.nixosConfigurations.musclor;
    popeye = self.nixosConfigurations.popeye;
  };
}
