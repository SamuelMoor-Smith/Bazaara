// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy this contract on Sepolia

import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

contract TransactionReceiver is CCIPReceiver {

    event TransactionSendSuccessfull(Client.Any2EVMMessage message);
    // https://docs.chain.link/ccip/supported-networks/testnet

    constructor(address _routerAddress) CCIPReceiver(_routerAddress) {
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        emit TransactionSendSuccessfull(message);
    }

    // function testMint() external {
    //     // Mint from Sepolia
    //     nft.mintFrom(msg.sender, 0);
    // }

    // function testMessage() external {
    //     // Mint from Sepolia
    //     bytes memory message;
    //     message = abi.encodeWithSignature("mintFrom(address,uint256)", msg.sender, 0);

    //     (bool success, ) = address(nft).call(message);
    //     require(success);
    //     emit MintCallSuccessfull();
    // }
}