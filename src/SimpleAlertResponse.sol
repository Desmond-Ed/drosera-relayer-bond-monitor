// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleAlertResponse {
    event BondThresholdAlert(uint256 threshold, uint256 timestamp);
    
    function alertLowBond(uint256 threshold) external {
        emit BondThresholdAlert(threshold, block.timestamp);
    }
}
