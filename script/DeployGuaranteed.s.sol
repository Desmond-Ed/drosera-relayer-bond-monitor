// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {GuaranteedResponse} from "../src/GuaranteedResponse.sol";

contract DeployGuaranteed is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        GuaranteedResponse response = new GuaranteedResponse();
        
        console.log("GuaranteedResponse deployed at: %s", address(response));
        
        vm.stopBroadcast();
    }
}
