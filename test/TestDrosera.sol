// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/RelayerBondMonitor.sol";

contract TestDrosera is Test {
    RelayerBondMonitor trap;
    
    function setUp() public {
        trap = new RelayerBondMonitor();
    }
    
    function testCollect() public view {
        bytes memory data = trap.collect();
        uint256 bond = abi.decode(data, (uint256));
        console.log("Current bond:", bond);
        console.log("Bond in ETH:", bond / 1e18);
    }
    
    function testShouldRespondHighBond() public view {
        // Test with high bond (200 ETH)
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encode(200 ether);
        
        (bool should, bytes memory response) = trap.shouldRespond(data);
        console.log("High bond (200 ETH):", should ? "SHOULD RESPOND" : "OK");
        if (should) {
            uint256 bond = abi.decode(response, (uint256));
            console.log("Response bond:", bond / 1e18, "ETH");
        }
    }
    
    function testShouldRespondLowBond() public view {
        // Test with low bond (50 ETH)
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encode(50 ether);
        
        (bool should, bytes memory response) = trap.shouldRespond(data);
        console.log("Low bond (50 ETH):", should ? "SHOULD RESPOND" : "OK");
        if (should) {
            uint256 bond = abi.decode(response, (uint256));
            console.log("Response bond:", bond / 1e18, "ETH");
        }
    }
}
