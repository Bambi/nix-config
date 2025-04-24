{ self, inputs, ... }:
inputs.namaka.lib.load {
  src = ./tests;
  inputs = {
    nixosConfs = self.nixosConfigurations;
  };
}
