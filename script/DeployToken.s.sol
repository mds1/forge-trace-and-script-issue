// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "src/MyToken.sol";

contract DeployInput {
  struct MintParams {
    address mintee;
    uint256 amount;
  }

  MintParams[] public inputs;

  function setUp() public virtual {
    inputs.push(MintParams(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 1e18));
    inputs.push(MintParams(0x4B0b71dBc20725244d037753D6E340ca7C2797C3, 1e18));
  }
}

contract DeployToken is Script, DeployInput {
  address deployer;
  MyToken token;

  function setUp() public override {
    super.setUp();
    deployer = msg.sender;
  }

  function run(bytes32 _salt) public {
    deployer = msg.sender;

    vm.broadcast(deployer);
    token = new MyToken{salt: _salt}(deployer, deployer);

    for(uint256 i = 0; i < inputs.length; i ++) {
      vm.broadcast(deployer);
      token.mint(inputs[i].mintee, inputs[i].amount);
    }
  }
}
