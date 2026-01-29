// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AlwaysWorksResponse {
    event Executed(bytes data);
    
    // This function never reverts
    function executeResponse(bytes calldata data) external {
        // Always emit event, never revert
        emit Executed(data);
    }
}
