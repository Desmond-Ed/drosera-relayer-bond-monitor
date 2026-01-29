// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MockBondManager} from "../src/MockBondManager.sol";

contract DeployMock is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        // Start with 50 ETH bond (below 100 ETH threshold to trigger trap)
        MockBondManager mock = new MockBondManager(50 * 10**18);
        
        console.log("MockBondManager deployed at: %s", address(mock));
        console.log("Initial bond: 50 ETH (50000000000000000000 wei)");
        
        vm.stopBroadcast();
    }
}
