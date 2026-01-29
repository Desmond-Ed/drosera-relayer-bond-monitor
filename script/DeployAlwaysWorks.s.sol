// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {AlwaysWorksResponse} from "../src/AlwaysWorksResponse.sol";

contract DeployAlwaysWorks is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        AlwaysWorksResponse response = new AlwaysWorksResponse();
        
        console.log("AlwaysWorksResponse deployed at: %s", address(response));
        
        vm.stopBroadcast();
    }
}
