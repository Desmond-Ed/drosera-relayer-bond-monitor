// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RealSetBond {
    event BondUpdated(uint256 newBond, uint256 timestamp);
    
    // Function that matches what Drosera expects
    function setBond(uint256 newBond) external {
        emit BondUpdated(newBond, block.timestamp);
    }
    
    // Fallback to accept any call (optional)
    fallback() external {
        // Accept any call, don't revert
    }
}
