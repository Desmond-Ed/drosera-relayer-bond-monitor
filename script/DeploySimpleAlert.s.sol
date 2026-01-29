// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {SimpleAlertResponse} from "../src/SimpleAlertResponse.sol";

contract DeploySimpleAlert is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        SimpleAlertResponse response = new SimpleAlertResponse();
        
        console.log("SimpleAlertResponse deployed at: %s", address(response));
        
        vm.stopBroadcast();
    }
}
