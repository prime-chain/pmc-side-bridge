// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* Contract Imports */

import "./ERC20.sol";
import { ERC20Burnable } from "./ERC20Burnable.sol";

contract TokenChild is ERC20, ERC20Burnable {
    
    address bridge = 0x000000000000000000000000000000000;

    constructor () ERC20("Lusso", "LSO") {
    }

    /**
    * @dev Only callable by account with access (gateway role)
    */
    function mint( address recipient, uint256 amount) public virtual onlyBridge {
        _mint(recipient, amount);
    }

    /**
    * @dev Only callable by account with access (gateway role)
    * @inheritdoc ERC20Burnable
    */
    function burn(uint256 amount) public override(ERC20Burnable) virtual onlyBridge {
        super.burn(amount);
    }

    /**
    * @dev Only callable by account with access (gateway role)
    * @inheritdoc ERC20Burnable
    */
    function burnFrom(address account, uint256 amount) public override(ERC20Burnable) virtual onlyBridge {
        super.burnFrom(account, amount);
    }

    modifier onlyBridge {
      require(msg.sender == bridge, "only bridge has access to this child token function");
      _;
    }

}