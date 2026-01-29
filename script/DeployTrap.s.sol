// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {RelayerBondMonitor} from "../src/RelayerBondMonitor.sol";

contract DeployTrap is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        RelayerBondMonitor trap = new RelayerBondMonitor();
        
        console.log("RelayerBondMonitor deployed at:", address(trap));
        console.log("Target contract:", trap.TARGET_CONTRACT());
        console.log("Trigger threshold:", trap.TRIGGER_THRESHOLD() / 1 ether, "ETH");
        console.log("Recovery value:", trap.RECOVERY_VALUE() / 1 ether, "ETH");
        
        vm.stopBroadcast();
    }
}
