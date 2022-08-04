// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.15;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/AccessControl.sol";
import "openzeppelin-contracts/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract MyToken is ERC20, AccessControl, ERC20Permit, ERC20Votes {
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

  constructor(address _owner, address _minter) ERC20("My Token", "MT") ERC20Permit("My Token") {
    _grantRole(DEFAULT_ADMIN_ROLE, _owner);
    _grantRole(MINTER_ROLE, _minter);
  }

  function mint(address _to, uint256 _amount) public onlyRole(MINTER_ROLE) {
    _mint(_to, _amount);
  }

  // The following functions are overrides required by Solidity.

  function _afterTokenTransfer(address _from, address _to, uint256 _amount)
    internal
    override(ERC20, ERC20Votes)
  {
    super._afterTokenTransfer(_from, _to, _amount);
  }

  function _mint(address _to, uint256 _amount)
    internal
    override(ERC20, ERC20Votes)
  {
    super._mint(_to, _amount);
  }

  function _burn(address _account, uint256 _amount)
    internal
    override(ERC20, ERC20Votes)
  {
    super._burn(_account, _amount);
  }
}
