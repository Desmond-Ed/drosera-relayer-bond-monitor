// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/drosera-contracts/interfaces/ITrap.sol";

/**
 * @title DiscordNameTrap - Working Version
 * @notice Registers Discord name "desmond_201" via AlwaysWorksResponse
 * @dev Uses executeResponse(bytes) which actually exists in AlwaysWorksResponse
 */
contract DiscordNameTrap is ITrap {
    address public constant RESPONSE_CONTRACT = 0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608;
    string constant DISCORD_NAME = "desmond_201";
    
    // Simple flag to control when to respond
    bool public constant ALWAYS_RESPOND = true;
    
    constructor() {}
    
    /**
     * @notice Collects Discord name data
     * @dev No external calls - just returns the Discord name
     */
    function collect() external view override returns (bytes memory) {
        return abi.encode(ALWAYS_RESPOND, DISCORD_NAME);
    }
    
    /**
     * @notice Always responds to register Discord name
     * @dev Returns encoded Discord name for executeResponse(bytes)
     */
    function shouldRespond(bytes[] calldata data) 
        external 
        pure 
        override 
        returns (bool, bytes memory) 
    {
        // Guard against empty data
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }
        
        // Decode the data
        (bool shouldTrigger, string memory name) = abi.decode(data[0], (bool, string));
        
        // If flag is true and name exists, respond
        if (shouldTrigger && bytes(name).length > 0) {
            // Return encoded Discord name for executeResponse(bytes)
            return (true, abi.encode(name));
        }
        
        return (false, bytes(""));
    }
}
