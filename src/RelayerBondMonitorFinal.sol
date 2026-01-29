// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "lib/drosera-contracts/interfaces/ITrap.sol";

interface IMockBondManager {
    function totalBonded() external view returns (uint256);
}

contract RelayerBondMonitorFinal is ITrap {
    // FIXED: Using correct address from drosera.toml
    address public constant TARGET_CONTRACT = 0x7fD8C8A6296c95913b0b04a2203c3E3F00488FB2;
    uint256 public constant BOND_THRESHOLD = 100 * 10**18; // 100 ETH

    constructor() {}

    function collect() external view returns (bytes memory) {
        // FIXED: Safe call with error handling
        (bool success, bytes memory data) = 
            TARGET_CONTRACT.staticcall(abi.encodeWithSignature("totalBonded()"));
        
        if (!success || data.length != 32) {
            return bytes(""); // Prevents trap from going blind
        }
        
        uint256 currentBond = abi.decode(data, (uint256));
        return abi.encode(currentBond);
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if (data.length == 0) {
            return (false, bytes(""));
        }
        
        bytes memory latestData = data[0];
        if (latestData.length == 0) {
            return (false, bytes("")); // collect() failed
        }
        
        uint256 currentBond = abi.decode(latestData, (uint256));
        
        if (currentBond < BOND_THRESHOLD) {
            // FIXED: Return threshold value to actually fix the problem
            return (true, abi.encode(BOND_THRESHOLD));
        }
        
        // FIXED: Empty bytes on false
        return (false, bytes(""));
    }
}
