// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {StandardDroseraResponse} from "../src/StandardDroseraResponse.sol";

contract DeployStandardResponse is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        StandardDroseraResponse response = new StandardDroseraResponse();
        
        console.log("StandardDroseraResponse deployed at: %s", address(response));
        console.log("Function: executeResponse(bytes)");
        
        vm.stopBroadcast();
    }
}
