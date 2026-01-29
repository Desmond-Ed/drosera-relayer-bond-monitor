// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IBondManager {
    function totalBonded() external view returns (uint256);
}

contract RelayerBondMonitor {
    address public constant TARGET_CONTRACT = 0xA5Cc2eC93873c7393a220F25cDDc71f2307FCD2D;
    
    // Workshop 3: Trigger at 75 ETH, restore to 100 ETH
    uint256 public constant TRIGGER_THRESHOLD = 75 ether;
    uint256 public constant RECOVERY_VALUE = 100 ether;
    
    constructor() {}
    
    function collect() external view returns (bytes memory) {
        (bool success, bytes memory returnData) = TARGET_CONTRACT.staticcall(
            abi.encodeWithSignature("totalBonded()")
        );
        
        if (!success || returnData.length != 32) {
            return bytes("");
        }
        
        uint256 currentBond = abi.decode(returnData, (uint256));
        return abi.encode(currentBond);
    }
    
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }
        
        uint256 currentBond = abi.decode(data[0], (uint256));
        
        if (currentBond < TRIGGER_THRESHOLD) {
            return (true, abi.encode(RECOVERY_VALUE));
        }
        
        return (false, bytes(""));
    }
}
