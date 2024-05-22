# Smart Bank Smart Contract

## Overview

SBank is a simple Ethereum smart contract that serves as a basic bank, allowing users to create accounts, deposit and withdraw Ether, transfer funds between accounts, and earn interest on their deposits.

## Features

- **Account Creation:** Users can create accounts to manage their funds.
- **Deposit:** Users can deposit Ether into their accounts.
- **Withdrawal:** Users can withdraw Ether from their accounts.
- **Transfer:** Users can transfer Ether from their accounts to other users' accounts.
- **Interest Calculation:** The contract automatically calculates and adds interest to account balances over time.
- **Concurrency Protection:** Includes a mechanism to prevent reentrant attacks.

## Getting Started

### Prerequisites

- **Solidity Compiler:** Ensure you have a Solidity compiler installed to compile the contract code.
- **Ethereum Network:** Deploy the contract to an Ethereum network (e.g., Rinkeby, Ropsten, or a local development network).

### Deployment

1. Compile the Solidity contract using a Solidity compiler.
2. Deploy the compiled contract to an Ethereum network of your choice.
3. Interact with the deployed contract using a compatible Ethereum wallet or through a web3.js application.

### Interacting with the Contract

1. **Account Creation:** Call the `accountCreation` function to create a new account.
2. **Deposit:** Use the `deposit` function to deposit Ether into your account.
3. **Withdrawal:** Call the `withdrawal` function to withdraw Ether from your account.
4. **Transfer:** Use the `transfer` function to transfer Ether from your account to another account.
5. **Interest Calculation:** Execute the `interest_cal` function to calculate and add interest to all accounts.

## Security Considerations

- Ensure to thoroughly test the contract functionalities before deploying it to the mainnet.
- Use appropriate access control mechanisms to prevent unauthorized access to sensitive functions.
- Keep the contract up-to-date with the latest security best practices and Solidity compiler versions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
