// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockBondManager {
    uint256 public totalBonded;
    
    constructor(uint256 _initialBond) {
        totalBonded = _initialBond;
    }
    
    function setBond(uint256 _newBond) external {
        totalBonded = _newBond;
    }
}
