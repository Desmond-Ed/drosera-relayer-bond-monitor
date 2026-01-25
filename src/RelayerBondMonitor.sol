// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/drosera-contracts/interfaces/ITrap.sol";

interface IMockBondManager {
    function totalBond() external view returns (uint256);
}

contract RelayerBondMonitor is ITrap {
    address public constant TARGET_CONTRACT = 0x66cdD40e95366C298e990a9b5a2469bA26729480;
    uint256 public constant BOND_THRESHOLD = 100 ether;

    constructor() {}

    function collect() external view override returns (bytes memory) {
        uint256 bond = IMockBondManager(TARGET_CONTRACT).totalBond();
        return abi.encode(bond);
    }

    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length == 0) return (false, bytes("No data"));
        uint256 currentBond = abi.decode(data[0], (uint256));
        if (currentBond < BOND_THRESHOLD) return (true, abi.encode(currentBond));
        return (false, bytes("Bond OK"));
    }
}
