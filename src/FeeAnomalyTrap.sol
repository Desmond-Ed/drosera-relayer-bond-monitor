// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/drosera-contracts/interfaces/ITrap.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);
}

/**
 * @title FeeAnomalyTrap
 * @notice Monitors token supply changes to detect anomalies
 * @dev Implements ITrap with hardened collect() and shouldRespond()
 * 
 * FIXED based on team feedback:
 * - No constructor args (Drosera deploys in shadow-fork)
 * - Hardcoded TOKEN and THRESHOLD
 * - collect() uses staticcall (won't brick if token reverts)
 * - shouldRespond() checks lengths before decode (planner-safe)
 * - shouldRespond() is pure (not view)
 */
contract FeeAnomalyTrap is ITrap {
    // Hardcoded values - change these and redeploy for different tokens
    // Example: USDC on mainnet
    address public constant TOKEN = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    
    // Threshold in basis points (1000 = 10% change triggers alert)
    uint256 public constant SUPPLY_CHANGE_THRESHOLD = 1000;
    
    struct CollectOutput {
        uint256 supply;
    }
    
    constructor() {}
    
    /**
     * @notice Collects current token supply with hardened safety checks
     * @dev Uses extcodesize + staticcall to prevent bricking if TOKEN reverts
     */
    function collect() external view override returns (bytes memory) {
        // Check if TOKEN is a contract
        uint256 size;
        address token = TOKEN;
        assembly { 
            size := extcodesize(token) 
        }
        
        if (size == 0) {
            return bytes("");
        }
        
        // Use staticcall to safely query totalSupply
        (bool success, bytes memory returnData) = TOKEN.staticcall(
            abi.encodeWithSignature("totalSupply()")
        );
        
        // Validate response
        if (!success || returnData.length != 32) {
            return bytes("");
        }
        
        uint256 supply = abi.decode(returnData, (uint256));
        return abi.encode(CollectOutput(supply));
    }
    
    /**
     * @notice Determines if supply change warrants a response
     * @dev Planner-safe: checks lengths before decoding to prevent reverts
     */
    function shouldRespond(bytes[] calldata data) 
        external 
        pure
        override 
        returns (bool, bytes memory) 
    {
        // Guard against empty data (planner-safe)
        if (data.length < 2) {
            return (false, bytes(""));
        }
        
        // Guard against empty blobs before decoding (planner-safe)
        if (data[0].length == 0 || data[1].length == 0) {
            return (false, bytes(""));
        }
        
        // Check exact expected length (32 bytes for single uint256 in struct)
        if (data[0].length != 32 || data[1].length != 32) {
            return (false, bytes(""));
        }
        
        CollectOutput memory curr = abi.decode(data[0], (CollectOutput));
        CollectOutput memory prev = abi.decode(data[1], (CollectOutput));
        
        // Prevent division by zero
        if (prev.supply == 0) {
            return (false, bytes(""));
        }
        
        // Calculate percentage change in basis points
        uint256 change;
        if (curr.supply > prev.supply) {
            change = ((curr.supply - prev.supply) * 10000) / prev.supply;
        } else {
            change = ((prev.supply - curr.supply) * 10000) / prev.supply;
        }
        
        // Trigger if change exceeds threshold
        if (change >= SUPPLY_CHANGE_THRESHOLD) {
            return (true, abi.encode(curr.supply, prev.supply, change));
        }
        
        // Return empty bytes when not triggering (per team feedback)
        return (false, bytes(""));
    }
}
