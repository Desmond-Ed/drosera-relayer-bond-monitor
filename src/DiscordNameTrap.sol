// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/drosera-contracts/interfaces/ITrap.sol";

interface IMockResponse {
    function isActive() external view returns (bool);
}

contract DiscordNameTrap is ITrap {
    address public constant RESPONSE_CONTRACT = 0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608;
    string constant DISCORD_NAME = "desmond_201";
    
    function collect() external view override returns (bytes memory) {
        // Hardened with staticcall to prevent brick
        (bool success, bytes memory returnData) = RESPONSE_CONTRACT.staticcall(
            abi.encodeWithSignature("isActive()")
        );
        
        // If call failed or returned wrong data, return empty bytes
        if (!success || returnData.length != 32) {
            return bytes("");
        }
        
        bool active = abi.decode(returnData, (bool));
        return abi.encode(active, DISCORD_NAME);
    }
    
    function shouldRespond(bytes[] calldata data) 
        external 
        pure 
        override 
        returns (bool, bytes memory) 
    {
        // Guard against empty/malformed data
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }
        
        // Decode with length check
        if (data[0].length < 64) { // Minimum size for (bool, string)
            return (false, bytes(""));
        }
        
        (bool active, string memory name) = abi.decode(data[0], (bool, string));
        
        if (!active || bytes(name).length == 0) {
            return (false, bytes(""));
        }
        
        return (true, abi.encode(name));
    }
}
