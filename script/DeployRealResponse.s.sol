// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {RealBondResponse} from "../src/RealBondResponse.sol";

contract DeployRealResponse is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy response contract pointing to your MockBondManager
        RealBondResponse response = new RealBondResponse(0x7fD8C8A6296c95913b0b04a2203c3E3F00488FB2);
        
        console.log("RealBondResponse deployed at: %s", address(response));
        console.log("Target MockBondManager: 0x7fD8C8A6296c95913b0b04a2203c3E3F00488FB2");
        
        vm.stopBroadcast();
    }
}
