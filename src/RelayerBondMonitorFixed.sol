// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/drosera-contracts/interfaces/ITrap.sol";

interface IMockBondManager {
    function totalBonded() external view returns (uint256);
    function setBond(uint256 _newBond) external;
}

contract RelayerBondMonitorFixed is ITrap {
    // FIX 1: Correct address (the actual mock we deployed)
    address public constant TARGET_CONTRACT = 0xA5Cc2eC93873c7393a220F25cDDc71f2307FCD2D;
    uint256 public constant BOND_THRESHOLD = 100 ether;
    uint256 public constant SAFE_BOND_LEVEL = 200 ether;
    
    constructor() {
        // FIX 2: No args needed
    }

    // FIX 3: Use correct function name with error handling
    function collect() external view override returns (bytes memory) {
        (bool success, bytes memory data) = TARGET_CONTRACT.staticcall(
            abi.encodeWithSignature("totalBonded()")
        );
        
        if (!success || data.length != 32) {
            return abi.encode(uint256(0));
        }
        
        uint256 bond = abi.decode(data, (uint256));
        return abi.encode(bond);
    }

    // FIX 4: Proper response logic + FIX 5: Empty bytes on false
    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length == 0) {
            return (false, bytes(""));
        }

        uint256 currentBond = abi.decode(data[0], (uint256));
        
        if (currentBond == 0) {
            return (false, bytes(""));
        }

        // FIX 6: Actually mitigate by setting to safe level
        if (currentBond < BOND_THRESHOLD) {
            return (true, abi.encode(SAFE_BOND_LEVEL));
        }

        return (false, bytes(""));
    }
}
