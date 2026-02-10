// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/drosera-contracts/interfaces/ITrap.sol";

interface IBondManager {
    function totalBonded() external view returns (uint256);
}

contract RelayerBondMonitor is ITrap {
    address public constant TARGET_CONTRACT = 0xA5Cc2eC93873c7393a220F25cDDc71f2307FCD2D;
    uint256 public constant BOND_THRESHOLD = 100 ether;
    
    constructor() {}
    
    function collect() external view override returns (bytes memory) {
        (bool success, bytes memory returnData) = TARGET_CONTRACT.staticcall(
            abi.encodeWithSignature("totalBonded()")
        );
        
        if (!success || returnData.length != 32) {
            return bytes("");
        }
        
        uint256 currentBond = abi.decode(returnData, (uint256));
        return abi.encode(currentBond);
    }
    
    function shouldRespond(bytes[] calldata data) 
        external 
        pure 
        override 
        returns (bool, bytes memory) 
    {
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }
        
        uint256 currentBond = abi.decode(data[0], (uint256));
        
        if (currentBond < BOND_THRESHOLD) {
            return (true, abi.encode(BOND_THRESHOLD));
        }
        
        return (false, bytes(""));
    }
}
