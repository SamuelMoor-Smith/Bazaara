// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy this contract on Sepolia

import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

interface IOrderHouse {
    function createBidOrder(uint256 orderTypeId, string[5] memory parameterValues) external;
    function createAskOrder(uint256 orderTypeId, string[5] memory parameterValues) external;
}

contract OrderReceiver is CCIPReceiver {
    IOrderHouse public orderHouse;

    event OrderSendSuccessfull();
    // https://docs.chain.link/ccip/supported-networks/testnet

    constructor(address _orderHouseAddress, address _routerAddress) CCIPReceiver(_routerAddress) {
        orderHouse = IOrderHouse(_orderHouseAddress);
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        (bool success, ) = address(orderHouse).call(message.data);
        require(success);
        emit OrderSendSuccessfull();
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

    function updateOrderHouse(address _orderHouseAddress) external {
        orderHouse = IOrderHouse(_orderHouseAddress);
    }
}