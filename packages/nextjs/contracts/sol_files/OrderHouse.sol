// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract OrderHouse {
    // Define a condition for matching
    struct Condition {
        uint256 bidParameterIndex;
        uint256 askParameterIndex;
        string relationship; // Relationship for comparison (e.g., ">", ">=", "=", "<=", "<")
        string valueType; // Type of value to compare ("uint" or "string")
    }

    // Define an Order Type
    struct OrderType {
        uint256 id;
        string name;
        string functionSignature;
        string[5] supplierParameterKeys;
        string[5] bidderParameterKeys;
        Condition[5] conditions; // Array of up to 5 conditions for matching
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

    constructor() {
        nextOrderTypeId = 1;
        nextOrderId = 1;
    }

    // Create a new Order Type with function signature and conditions
    function createOrderType(
        string memory name,
        string memory functionSignature,
        string[5] memory supplierParameters,
        string[5] memory bidderParameters,
        uint256[5] memory bidParameterIndices,
        uint256[5] memory askParameterIndices,
        string[5] memory relationships,
        string[5] memory valueTypes
    ) external returns (uint256) {
        uint256 orderTypeId = nextOrderTypeId++;

        OrderType storage newOrderType = orderTypes[orderTypeId];
        newOrderType.id = orderTypeId;
        newOrderType.name = name;
        newOrderType.functionSignature = functionSignature;
        newOrderType.supplierParameterKeys = supplierParameters;
        newOrderType.bidderParameterKeys = bidderParameters;

        for (uint256 i = 0; i < 5; i++) {
            newOrderType.conditions[i] = Condition(
                bidParameterIndices[i],
                askParameterIndices[i],
                relationships[i],
                valueTypes[i]
            );
        }

        emit OrderTypeCreated(orderTypeId, name, functionSignature);
        return orderTypeId;
    }

    // Create a new Bid Order
    function createBidOrder(
        uint256 orderTypeId,
        string[5] memory parameterValues
    ) external returns (uint256) {
        return _createOrder(orderTypeId, parameterValues, true);
    }

    // Create a new Ask Order
    function createAskOrder(
        uint256 orderTypeId,
        string[5] memory parameterValues
    ) external returns (uint256) {
        return _createOrder(orderTypeId, parameterValues, false);
    }

    // Get Order Type details
    function getOrderType(uint256 orderTypeId) external view returns (
        string memory name,
        string memory functionSignature,
        string[5] memory supplierParameters,
        string[5] memory bidderParameters,
        uint256[5] memory bidParameterIndices,
        uint256[5] memory askParameterIndices,
        string[5] memory relationships,
        string[5] memory valueTypes
    ) {
        require(orderTypes[orderTypeId].id != 0, "Order type does not exist");

        OrderType storage orderType = orderTypes[orderTypeId];

        for (uint256 i = 0; i < 5; i++) {
            Condition storage condition = orderType.conditions[i];
            bidParameterIndices[i] = condition.bidParameterIndex;
            askParameterIndices[i] = condition.askParameterIndex;
            relationships[i] = condition.relationship;
            valueTypes[i] = condition.valueType;
        }

        return (
            orderType.name,
            orderType.functionSignature,
            orderType.supplierParameterKeys,
            orderType.bidderParameterKeys,
            bidParameterIndices,
            askParameterIndices,
            relationships,
            valueTypes
        );
    }

    // Get Order details
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

    // Internal function to create a new order
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

        for (uint256 i = 0; i < 5; i++) {
            if (bytes(orderType.supplierParameterKeys[i]).length > 0) {
                require(bytes(parameterValues[i]).length > 0, isBid ? "Missing bidder parameter value" : "Missing supplier parameter value");
            }
        }

        emit OrderCreated(orderId, orderTypeId, msg.sender, isBid);
        return orderId;
    }

    // Function to match two orders based on the matching logic
    function matchOrders(uint256 bidOrderId, uint256 askOrderId) external returns (bool) {
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
            if (bytes(condition.relationship).length == 0) {
                continue; // Skip empty conditions
            }

            if (keccak256(bytes(condition.valueType)) == keccak256(bytes("uint"))) {
                uint256 bidValue = parseUint(bidOrder.parameterValues[condition.bidParameterIndex]);
                uint256 askValue = parseUint(askOrder.parameterValues[condition.askParameterIndex]);

                if (keccak256(bytes(condition.relationship)) == keccak256(bytes(">"))) {
                    require(bidValue > askValue, "Condition not satisfied: bidValue > askValue");
                } else if (keccak256(bytes(condition.relationship)) == keccak256(bytes(">="))) {
                    require(bidValue >= askValue, "Condition not satisfied: bidValue >= askValue");
                } else if (keccak256(bytes(condition.relationship)) == keccak256(bytes("="))) {
                    require(bidValue == askValue, "Condition not satisfied: bidValue == askValue");
                } else if (keccak256(bytes(condition.relationship)) == keccak256(bytes("<="))) {
                    require(bidValue <= askValue, "Condition not satisfied: bidValue <= askValue");
                } else if (keccak256(bytes(condition.relationship)) == keccak256(bytes("<"))) {
                    require(bidValue < askValue, "Condition not satisfied: bidValue < askValue");
                } else {
                    revert("Unknown relationship");
                }
            } else if (keccak256(bytes(condition.valueType)) == keccak256(bytes("string"))) {
                if (keccak256(bytes(condition.relationship)) == keccak256(bytes("="))) {
                    require(keccak256(bytes(bidOrder.parameterValues[condition.bidParameterIndex])) == keccak256(bytes(askOrder.parameterValues[condition.askParameterIndex])), "Condition not satisfied: string values do not match");
                } else if (keccak256(bytes(condition.relationship)) == keccak256(bytes("!="))) {
                    require(keccak256(bytes(bidOrder.parameterValues[condition.bidParameterIndex])) != keccak256(bytes(askOrder.parameterValues[condition.askParameterIndex])), "Condition not satisfied: string values match when they should not");
                } else {
                    revert("Unknown relationship for string");
                }
            } else {
                revert("Unknown value type");
            }
        }

        // Mark orders as matched
        bidOrder.status = "matched";
        askOrder.status = "matched";

        emit OrdersMatched(bidOrderId, askOrderId);

        return true;
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
}