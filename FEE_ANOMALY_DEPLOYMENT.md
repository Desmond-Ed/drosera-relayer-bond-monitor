# FeeAnomalyTrap Deployment Guide

## Quick Start

1. **Compile the trap**
```bash
   forge build
```

2. **Deploy using Drosera CLI**
```bash
   export DROSERA_PRIVATE_KEY=0xyourprivatekeyhere
   drosera -c drosera-fee-anomaly.toml apply
```

3. **Confirm deployment**
   - Type `ofc` when prompted
   - Your trap address will be added to the config

4. **View on dashboard**
   - Visit https://app.drosera.io/
   - Connect wallet → "Traps Owned"

## Prerequisites

Get Hoodi testnet ETH from: https://app.drosera.io/ (faucet)

