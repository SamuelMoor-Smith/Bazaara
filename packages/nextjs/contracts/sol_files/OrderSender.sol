// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy this contract on Fuji

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract OrderSender {

    // Custom errors to provide more descriptive revert messages.
    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); // Used to make sure contract has enough balance to cover the fees.
    error NothingToWithdraw(); // Used when trying to withdraw but there's nothing to withdraw.

    IRouterClient public router;
    LinkTokenInterface public linkToken;
    uint64 public destinationChainSelector;
    address public owner;
    address public destinationReceiver;

    event MessageSent(bytes32 messageId);

    constructor(address _routerAddress, address _linkTokenAddress, address _destinationReceiver, uint64 _destinationChainSelector) {
        owner = msg.sender;
        destinationChainSelector = _destinationChainSelector;

        router = IRouterClient(_routerAddress);
        linkToken = LinkTokenInterface(_linkTokenAddress);
        linkToken.approve(_routerAddress, type(uint256).max);

        // to Receiver
        destinationReceiver = _destinationReceiver;
    }

    function createBidMessage(
        uint256 orderTypeId,
        string[5] memory parameterValues
    ) internal view returns (Client.EVM2AnyMessage memory) {
        return Client.EVM2AnyMessage({
            receiver: abi.encode(destinationReceiver),
            data: abi.encodeWithSignature("createBidOrder(uint256,string[5])", orderTypeId, parameterValues),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 980_000})
            ),
            feeToken: address(linkToken)
        });
    }

    function createAskMessage(
        uint256 orderTypeId,
        string[5] memory parameterValues
    ) internal view returns (Client.EVM2AnyMessage memory) {
        return Client.EVM2AnyMessage({
            receiver: abi.encode(destinationReceiver),
            data: abi.encodeWithSignature("createAskOrder(uint256,string[5])", orderTypeId, parameterValues),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 980_000})
            ),
            feeToken: address(linkToken)
        });
    }

    function sendOrder(
        uint256 orderTypeId,
        string[5] memory parameterValues,
        bool isBid
    ) external {
        
        Client.EVM2AnyMessage memory message;
        if (isBid) {
            message = createBidMessage(orderTypeId, parameterValues);
        } else {
            message = createAskMessage(orderTypeId, parameterValues);
        }  

        // Get the fee required to send the message
        uint256 fees = router.getFee(destinationChainSelector, message);

        if (fees > linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), fees);

        bytes32 messageId;
        // Send the message through the router and store the returned message ID
        messageId = router.ccipSend(destinationChainSelector, message);
        emit MessageSent(messageId);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function linkBalance (address account) public view returns (uint256) {
        return linkToken.balanceOf(account);
    }

    function withdrawLINK(
        address beneficiary
    ) public onlyOwner {
        uint256 amount = linkToken.balanceOf(address(this));
        if (amount == 0) revert NothingToWithdraw();
        linkToken.transfer(beneficiary, amount);
    }
}