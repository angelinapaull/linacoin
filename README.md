# Linacoin (LINA)

SIP-010 compliant fungible token implemented in Clarity and developed with Clarinet.

## Requirements
- Clarinet 3.x (verified with `clarinet 3.9.1`)
- Linux/macOS shell

## Project structure
- `Clarinet.toml` — Clarinet project manifest
- `contracts/sip-010-trait.clar` — Local SIP-010 trait definition
- `contracts/linacoin.clar` — Linacoin token contract implementing the trait

## Quickstart
```bash
# Check that the project compiles
clarinet check

# Open a REPL with a local chain
clarinet console
```

## Contract interface
- Read-only
  - `get-name () -> (response (string-ascii 32) uint)`
  - `get-symbol () -> (response (string-ascii 32) uint)`
  - `get-decimals () -> (response uint uint)`
  - `get-total-supply () -> (response uint uint)`
  - `get-balance (principal) -> (response uint uint)`
  - `allowance (owner principal) (spender principal) -> (response uint uint)`
- Public
  - `transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))) -> (response bool uint)`
  - `approve (spender principal) (amount uint) -> (response bool uint)`
  - `mint (amount uint) (recipient principal) -> (response bool uint)` — owner only
  - `burn (amount uint) (from principal) -> (response bool uint)` — owner only
  - `set-owner (new-owner principal) -> (response bool uint)` — owner only

Notes:
- Decimals: 6 (i.e. 1 LINA = 1_000_000 base units).
- Owner is the deployer by default.

## Common Clarinet commands
- `clarinet check` — type-check and analyze contracts
- `clarinet console` — interactive console for local testing
- `clarinet test` — run JS/TS tests (add tests under `tests/`)

## License
MIT
