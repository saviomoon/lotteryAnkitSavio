# Lottery DApp

> Lottery DAPP is a block chain based lottery smart contract

### Features

- The User registers with his wallet address and the smart contract makes sure that the address is unique

- The user then adds tokens to his account to be able to buy a lottery

- Each lottery is valid for only the day selected and is a combination of 3 numbers with value >= 0 and value < 100

- A user is able to add as much lotteries as they wish as long as they have enough tokens in their account

- The winning lottery numbers for a day are generated randomly each day

- If there is a matching lottery combination the user then gets all the tokens that were added to the contract otherwise the amount gets rolled over

- If there are multiple users that have winning numbers, then the amount is split between users

### Setup

- Clone repo: `git clone https://github.com/saviomoon/lotteryAnkitSavio`

- Change directory to cloned copy and run: `npm install`

- Run ganache AppImage

- Compile truffle contracts: `truffle compile`

- Deploy the contracts in Ganache

- Migrate truffle contract to blockchain: `truffle migrate`

- Run server: `npm run dev`

- Open `http://localhost:8080` in browser


### References

- [Truffle Docs](truffleframework.com/docs/)

- [GeegsForGeegs](https://www.geeksforgeeks.org/how-to-use-ganache-truffle-suite-to-deploy-a-smart-contract-in-solidity-blockchain/)

- [solidity](https://docs.soliditylang.org/en/v0.7.4/)