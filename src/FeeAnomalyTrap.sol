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
 */
contract FeeAnomalyTrap is ITrap {
    address public immutable TOKEN;
    uint256 public immutable SUPPLY_CHANGE_THRESHOLD; // Percentage in basis points (e.g., 1000 = 10%)
    
    struct CollectOutput {
        uint256 supply;
    }
    
    /**
     * @param _token The ERC20 token address to monitor
     * @param _threshold Supply change threshold in basis points (e.g., 1000 = 10% change triggers alert)
     */
    constructor(address _token, uint256 _threshold) {
        require(_token != address(0), "Invalid token address");
        TOKEN = _token;
        SUPPLY_CHANGE_THRESHOLD = _threshold;
    }
    
    /**
     * @notice Collects current token supply with hardened safety checks
     * @dev FIX #1: Uses extcodesize guard + staticcall to prevent bricking
     * @return Encoded CollectOutput or empty bytes on failure
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
     * @dev FIX #2: Validates data lengths before decoding to prevent reverts
     * @param data Array of encoded CollectOutput data [current, previous]
     * @return shouldRespond True if supply changed beyond threshold
     * @return responseData Encoded threshold data if responding
     */
    function shouldRespond(bytes[] calldata data) 
        external 
        view
        override 
        returns (bool, bytes memory) 
    {
        // Validate we have at least 2 data points
        if (data.length < 2) {
            return (false, bytes(""));
        }
        
        // Validate both data blobs have content before decoding
        // FIX #2: Check lengths to prevent decode reverts
        if (data[0].length == 0 || data[1].length == 0) {
            return (false, bytes(""));
        }
        
        // Optional: Check exact expected length (32 bytes for single uint256)
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
        
        return (false, bytes(""));
    }
}
