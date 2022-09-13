// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20Child } from "./IERC20Child.sol";

contract SideBridge {
    IERC20Child private sideToken;
    bool bridgeInitState;
    address owner;
    address gateway;
    uint256 public commisionValue;
    uint256 public commission;

    event BridgeInitialized(uint indexed timestamp);
    event TokensReturned(address indexed requester, uint amount, address addressTo, uint timestamp);
    
    constructor () {
        gateway = msg.sender;
        owner = msg.sender;
    }

    function initializeBridge (address _childTokenAddress) onlyOwner external  returns (bool){
        sideToken = IERC20Child(_childTokenAddress);
        bridgeInitState = true;

        uint decimals = 18;
        commisionValue = 5;
        commission = commisionValue * 10**decimals;

        return true;
    }

    function bridgeTokens (address _requester, uint _bridgedAmount) verifyInitialization onlyGateway  external  returns (bool){
        sideToken.mint(_requester,_bridgedAmount);
        return true;
    }

    function returnTokens (uint _bridgedAmount, address _addressTo) verifyInitialization external  returns (bool){
        address requester = msg.sender;
        require(_bridgedAmount>commission,"You cannot send less than comisision");
        require(_bridgedAmount <= sideToken.balanceOf(requester),"Check to have enough tokens (including the commision)");
        sideToken.burnFrom(requester, _bridgedAmount);
        emit TokensReturned(requester, _bridgedAmount, _addressTo, block.timestamp);
        return true;
    }

    function changeCommissionValue(uint256 value) verifyInitialization onlyOwner public {
        commisionValue = value;
        commission = commisionValue * 10**18;
    }

    modifier verifyInitialization {
      require(bridgeInitState, "Bridge has not been initialized");
      _;
    }
    
    modifier onlyGateway {
      require(msg.sender == gateway, "Only gateway can execute this function");
      _;
    }

    modifier onlyOwner {
      require(msg.sender == owner, "Only owner can execute this function");
      _;
    }
    

}