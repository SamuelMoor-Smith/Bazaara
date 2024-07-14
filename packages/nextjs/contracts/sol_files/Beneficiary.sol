// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Deploy this contract on Sepolia

import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

contract MultiDepositorEscrow is CCIPReceiver {
    struct Deposit {
        uint256 amount;
        address beneficiary;
        bool isReleased;
    }

    mapping(address => Deposit) public deposits;

    event DepositReceived(address indexed depositor, uint256 amount);
    event FundsReleased(address indexed depositor, address indexed beneficiary, uint256 amount);
    event FundsWithdrawn(address indexed depositor, uint256 amount);

    // https://docs.chain.link/ccip/supported-networks/testnet
    address routerSepolia = 0x774db69637129b2C5c4A5dF9E940dCAfD46f423B;

    constructor() CCIPReceiver(routerSepolia) {}

    modifier onlyDepositor() {
        require(deposits[msg.sender].amount > 0, "Only the depositor can call this function.");
        _;
    }

    function deposit(address _depositor, address _beneficiary) external payable {
        //require(msg.value > 0, "Deposit amount must be greater than zero.");
        require(deposits[_depositor].amount == 0, "Deposit already exists.");
        deposits[_depositor] = Deposit(1, _beneficiary, false);
        emit DepositReceived(_depositor, 1);
    }

    function release() external onlyDepositor {
        Deposit storage userDeposit = deposits[msg.sender];
        require(!userDeposit.isReleased, "Funds already released.");
        userDeposit.isReleased = true;
        payable(userDeposit.beneficiary).transfer(userDeposit.amount);
        emit FundsReleased(msg.sender, userDeposit.beneficiary, userDeposit.amount);
    }

    function withdraw() external onlyDepositor {
        Deposit storage userDeposit = deposits[msg.sender];
        require(!userDeposit.isReleased, "Funds already released.");
        uint256 amount = userDeposit.amount;
        userDeposit.amount = 0;
        payable(msg.sender).transfer(amount);
        emit FundsWithdrawn(msg.sender, amount);
    }

    function updateBeneficiary(address _depositor, address _beneficiary) external {
        require(deposits[_depositor].amount > 0, "Deposit does not exist.");
        deposits[_depositor].beneficiary = _beneficiary;
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override {
        (address sender, bytes memory data) = abi.decode(message.data, (address, bytes));

        (bool success, ) = address(this).call(abi.encodePacked(data, sender));
        require(success);
    }
}