// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract OrderHouse {

    // Custom errors to provide more descriptive revert messages.
    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); // Used to make sure contract has enough balance to cover the fees.
    error NothingToWithdraw(); // Used when trying to withdraw but there's nothing to withdraw.

    event MessageSent(bytes32 messageId);

    // Define a condition for matching
    struct Condition {
        string relationship; // Relationship for comparison (e.g., ">", ">=", "=", "<=", "<")
        string valueType; // Type of value to compare ("uint", "string", or "address")
    }

    // Define an Order Type
    struct OrderType {
        uint256 id;
        uint256 destinationChainId;
        string name;
        string functionSignature;
        string[5] supplierParameterKeys;
        string[5] bidderParameterKeys;
        Condition[5] conditions; // Array of up to 5 conditions for matching
        uint256[10] parametersNeeded;
        string[5] valueTypes;
    }

    // Define an Order
    struct Order {
        uint256 id;
        uint256 orderTypeId;
        address creator;
        string[5] parameterValues;
        bool isBid;
        string status;
    }

    uint256 private nextOrderTypeId;
    uint256 private nextOrderId;

    mapping(uint256 => OrderType) private orderTypes;
    mapping(uint256 => Order) private orders;

    event OrderTypeCreated(uint256 indexed orderTypeId, string name, string functionSignature);
    event OrderCreated(uint256 indexed orderId, uint256 indexed orderTypeId, address indexed creator, bool isBid);
    event OrdersMatched(uint256 indexed bidOrderId, uint256 indexed askOrderId);
    event TransactionSent(uint256 destinationChainId, bytes payload);

    constructor() {
        nextOrderTypeId = 1;
        nextOrderId = 1;
    }

    function createOrderType(
        string memory name,
        string memory functionSignature,
        uint256 destinationChainId,
        string[5] memory supplierParameters,
        string[5] memory bidderParameters,
        string[5] memory relationships,
        string[5] memory valueTypes,
        uint256[10] memory parametersNeeded
    ) external returns (uint256) {
        uint256 orderTypeId = nextOrderTypeId++;

        OrderType storage newOrderType = orderTypes[orderTypeId];
        newOrderType.id = orderTypeId;
        newOrderType.destinationChainId = destinationChainId;
        newOrderType.name = name;
        newOrderType.functionSignature = functionSignature;
        newOrderType.supplierParameterKeys = supplierParameters;
        newOrderType.bidderParameterKeys = bidderParameters;
        newOrderType.valueTypes = valueTypes;

        for (uint256 i = 0; i < 5; i++) {
            newOrderType.conditions[i] = Condition(
                relationships[i],
                valueTypes[i]
            );
        }

        newOrderType.parametersNeeded = parametersNeeded;

        emit OrderTypeCreated(orderTypeId, name, functionSignature);
        return orderTypeId;
    }

    function createBidOrder(
        uint256 orderTypeId,
        string[5] memory parameterValues
    ) external returns (uint256) {
        return _createOrder(orderTypeId, parameterValues, true);
    }

    function createAskOrder(
        uint256 orderTypeId,
        string[5] memory parameterValues
    ) external returns (uint256) {
        return _createOrder(orderTypeId, parameterValues, false);
    }

    function getOrderType(uint256 orderTypeId) external view returns (
        string memory name,
        string memory functionSignature,
        string[5] memory supplierParameters,
        string[5] memory bidderParameters,
        string[5] memory relationships,
        string[5] memory valueTypes
    ) {
        require(orderTypes[orderTypeId].id != 0, "Order type does not exist");

        OrderType storage orderType = orderTypes[orderTypeId];

        for (uint256 i = 0; i < 5; i++) {
            Condition storage condition = orderType.conditions[i];
            relationships[i] = condition.relationship;
            valueTypes[i] = condition.valueType;
        }

        return (
            orderType.name,
            orderType.functionSignature,
            orderType.supplierParameterKeys,
            orderType.bidderParameterKeys,
            relationships,
            orderType.valueTypes
        );
    }

    function getOrder(uint256 orderId) external view returns (
        uint256 orderTypeId,
        address creator,
        string[5] memory parameterKeys,
        string[5] memory parameterValues,
        bool isBid,
        string memory status
    ) {
        require(orders[orderId].id != 0, "Order does not exist");

        Order storage order = orders[orderId];
        orderTypeId = order.orderTypeId;
        creator = order.creator;

        OrderType storage orderType = orderTypes[order.orderTypeId];
        parameterKeys = order.isBid ? orderType.bidderParameterKeys : orderType.supplierParameterKeys;
        parameterValues = order.parameterValues;
        status = order.status;

        return (
            orderTypeId,
            creator,
            parameterKeys,
            parameterValues,
            order.isBid,
            status
        );
    }

    function _createOrder(
        uint256 orderTypeId,
        string[5] memory parameterValues,
        bool isBid
    ) internal returns (uint256) {
        require(orderTypes[orderTypeId].id != 0, "Order type does not exist");

        OrderType storage orderType = orderTypes[orderTypeId];

        uint256 orderId = nextOrderId++;
        Order storage newOrder = orders[orderId];
        newOrder.id = orderId;
        newOrder.orderTypeId = orderTypeId;
        newOrder.creator = msg.sender;
        newOrder.parameterValues = parameterValues;
        newOrder.isBid = isBid;
        newOrder.status = "active";

        if (isBid) {
            for (uint256 i = 0; i < 5; i++) {
                if (bytes(orderType.bidderParameterKeys[i]).length > 0) {
                    require(bytes(parameterValues[i]).length > 0, "Missing bidder parameter value");
                }
            }
        } else {
            for (uint256 i = 0; i < 5; i++) {
                if (bytes(orderType.supplierParameterKeys[i]).length > 0) {
                    require(bytes(parameterValues[i]).length > 0, "Missing supplier parameter value");
                }
            }
        }

        emit OrderCreated(orderId, orderTypeId, msg.sender, isBid);
        return orderId;
    }

    function matchOrders(uint256 bidOrderId, uint256 askOrderId, uint64 destinationChainSelector, address destinationReceiver) external returns (bool) {
        Order storage bidOrder = orders[bidOrderId];
        Order storage askOrder = orders[askOrderId];

        require(bidOrder.orderTypeId == askOrder.orderTypeId, "Orders must be of the same type");
        require(bidOrder.isBid && !askOrder.isBid, "One order must be a bid and the other an ask");
        require(keccak256(bytes(bidOrder.status)) == keccak256(bytes("active")), "Bid order is not active");
        require(keccak256(bytes(askOrder.status)) == keccak256(bytes("active")), "Ask order is not active");

        OrderType storage orderType = orderTypes[bidOrder.orderTypeId];

        // Evaluate each condition
        for (uint256 i = 0; i < 5; i++) {
            Condition storage condition = orderType.conditions[i];
            uint256 bidValue;
            uint256 askValue;

            if (bytes(condition.relationship).length == 0) {
                continue; // Skip empty values types
            }
            
            if (keccak256(bytes(condition.valueType)) == keccak256(bytes("uint256"))) {

                bidValue = parseUint(bidOrder.parameterValues[i]);
                askValue = parseUint(askOrder.parameterValues[i]);

                require(checkComparisons(condition, bidValue, askValue) == true, "uint condition doesn't match");
                
            } else if (keccak256(bytes(condition.valueType)) == keccak256(bytes("string"))) {

                bidValue = uint256(keccak256(bytes(bidOrder.parameterValues[i])));
                askValue = uint256(keccak256(bytes(askOrder.parameterValues[i])));

                require(checkComparisons(condition, bidValue, askValue) == true, "strings condition doesn't match");

            } else if (keccak256(bytes(condition.valueType)) == keccak256(bytes("address"))) {

                bidValue = uint160(parseAddress(bidOrder.parameterValues[i]));
                askValue = uint160(parseAddress(askOrder.parameterValues[i]));

                require(checkComparisons(condition, bidValue, askValue) == true, "strings condition doesn't match"); 

            } else {
                revert("Unknown value type");
            }
        }

        // Mark orders as matched
        bidOrder.status = "matched";
        askOrder.status = "matched";

        emit OrdersMatched(bidOrderId, askOrderId);

        // Send the transaction to the destination contract
        sendTransaction(orderType.destinationChainId, orderType.functionSignature, orderType.parametersNeeded, bidOrder.parameterValues, askOrder.parameterValues, orderType.valueTypes, destinationChainSelector, destinationReceiver);

        return true;
    }

    function checkComparisons(
        Condition storage _condition, 
        uint256 _bidValue,
        uint256 _askValue
    ) internal view returns (bool) {
        if (bytes(_condition.relationship).length == 0) {
            return true; // Skip empty relationships
        }

        if (keccak256(bytes(_condition.relationship)) == keccak256(bytes(">"))) {
            return _bidValue > _askValue;
        } else if (keccak256(bytes(_condition.relationship)) == keccak256(bytes(">="))) {
            return _bidValue >= _askValue;
        } else if (keccak256(bytes(_condition.relationship)) == keccak256(bytes("="))) {
            return _bidValue == _askValue;
        } else if (keccak256(bytes(_condition.relationship)) == keccak256(bytes("<="))) {
            return _bidValue <= _askValue;
        } else if (keccak256(bytes(_condition.relationship)) == keccak256(bytes("<"))) {
            return _bidValue < _askValue;
        } else {
            revert("Unknown relationship");
        }
    }


    // Function to send a transaction to the destination contract
    function sendTransaction(
        uint256 destinationChainId,
        string memory functionSignature,
        uint256[10] memory parametersNeeded,
        string[5] memory bidParameterValues,
        string[5] memory askParameterValues,
        string[5] memory valueTypes,
        uint64 destinationChainSelector,
        address destinationReceiver
    ) internal {
        // Collect the needed parameters for the function signature
        bytes memory payload = abi.encodeWithSignature(functionSignature);
        

        // Append ask parameters in the correct order (supplier parameter array)
        for (uint256 i = 0; i < parametersNeeded.length; i++) {
            if (parametersNeeded[i] == 0) {
                break;
            }
            bool isBidParameter = parametersNeeded[i] <= 5;
            uint256 index;
            string memory valueType;
            string memory value;

            if (isBidParameter) {
                index = parametersNeeded[i] - 1;
                value = bidParameterValues[index];
                valueType = valueTypes[index];
            } else {
                index = parametersNeeded[i] - 6;
                value = askParameterValues[index];
                valueType = valueTypes[index];
            }

            payload = abi.encodePacked(payload, encodeParameter(value, valueType));
        }

        // Emit the event with the encoded payload
        emit TransactionSent(destinationChainId, payload);

        sendToReceiver(payload, destinationChainSelector, destinationReceiver);
    }

    function sendToReceiver(
        bytes memory payload,
        uint64 destinationChainSelector,
        address destinationReceiver
    ) internal {

        IRouterClient router;
        LinkTokenInterface linkToken;

        // from Fuji
        address routerAddressArbitrum = 0x2a9C5afB0d0e4BAb2BCdaE109EC4b0c4Be15a165; //0xF694E193200268f9a4868e4Aa017A0118C9a8177;
        router = IRouterClient(routerAddressArbitrum);
        linkToken = LinkTokenInterface(0xb1D4538B4571d411F07960EF2838Ce337FE1E80E); //0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846);
        linkToken.approve(routerAddressArbitrum, type(uint256).max);

        // Mint from Fuji network = chain[1]
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(destinationReceiver),
            data: payload,
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 980_000})
            ),
            feeToken: address(linkToken)
        });        

        // Get the fee required to send the message
        uint256 fees = router.getFee(destinationChainSelector, message);

        if (fees > linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), fees);

        bytes32 messageId;
        // Send the message through the router and store the returned message ID
        messageId = router.ccipSend(destinationChainSelector, message);
        emit MessageSent(messageId);
    }

    // Utility function to parse string to uint
    function parseUint(string memory _a) internal pure returns (uint256) {
        bytes memory bresult = bytes(_a);
        uint256 mint = 0;
        for (uint256 i = 0; i < bresult.length; i++) {
            if ((uint8(bresult[i]) >= 48) && (uint8(bresult[i]) <= 57)) {
                mint *= 10;
                mint += uint8(bresult[i]) - 48;
            } else {
                revert("Invalid character found in string");
            }
        }
        return mint;
    }

    // Utility function to parse string to address
    function parseAddress(string memory _a) internal pure returns (address) {
        bytes memory temp = bytes(_a);
        require(temp.length == 42, "Invalid address length"); // 2 characters for "0x" prefix and 40 characters for the address

        uint160 result = 0;
        for (uint256 i = 2; i < 42; i++) {
            result *= 16;
            uint8 b = uint8(temp[i]);
            if (b >= 97 && b <= 102) {
                // a-f
                result += uint160(b - 87);
            } else if (b >= 48 && b <= 57) {
                // 0-9
                result += uint160(b - 48);
            } else if (b >= 65 && b <= 70) {
                // A-F
                result += uint160(b - 55);
            } else {
                revert("Invalid character found in address string");
            }
        }
        return address(result);
    }

    // Utility function to encode parameters based on value type
    function encodeParameter(string memory value, string memory valueType) internal pure returns (bytes memory) {
        if (keccak256(bytes(valueType)) == keccak256(bytes("address"))) {
            return abi.encode(parseAddress(value));
        } else if (keccak256(bytes(valueType)) == keccak256(bytes("uint256"))) {
            return abi.encode(parseUint(value));
        } else {
            return abi.encode(value);
        }
    }
}