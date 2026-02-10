// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/RelayerBondMonitor.sol";

contract DeployTrap is Script {
    function run() external {
        vm.startBroadcast();
        
        RelayerBondMonitor trap = new RelayerBondMonitor();
        
        console.log("Trap deployed at:", address(trap));
        console.log("Target contract:", trap.TARGET_CONTRACT());
        console.log("Bond threshold:", trap.BOND_THRESHOLD() / 1 ether, "ETH");
        
        vm.stopBroadcast();
    }
}
