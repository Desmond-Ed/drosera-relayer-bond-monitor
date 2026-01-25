# POC: Relayer Bond Monitor - Drosera Security Trap

## Overview
Monitors bridge/relayer bond levels to prevent under-collateralization risks.

## Technical Implementation
- **Trap Contract**: `RelayerBondMonitor.sol` (ITrap interface)
- **Response Contract**: `0x2e64a8517F2ac971498BEbba8d367b2d77133E99`
- **Target**: MockBondManager (`0xA5Cc2eC93873c7393a220F25cDDc71f2307FCD2D`)
- **Trigger**: Bond < 100 ETH
- **Response**: Emits critical alert event

## Demonstration
1. **Deployed on Hoodi**: Trap registered, operators monitoring
2. **Full cycle tested**: 
   - Safe (200 ETH): No response
   - Crisis (50 ETH): Automatic response every block
   - Reset (200 ETH): Response stops
3. **Dashboard**: Green status with active operators

## Security Impact
Prevents bridge insolvency by alerting when relayer bonds fall below safety threshold.
