// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StandardDroseraResponse {
    event ResponseTriggered(bytes data, uint256 timestamp);
    event BondAlert(uint256 bondValue, uint256 timestamp);
    
    function executeResponse(bytes calldata data) external {
        emit ResponseTriggered(data, block.timestamp);
        
        // If data contains a uint256 (bond threshold), also emit BondAlert
        if (data.length == 32) {
            uint256 bondValue = abi.decode(data, (uint256));
            emit BondAlert(bondValue, block.timestamp);
        }
    }
}
