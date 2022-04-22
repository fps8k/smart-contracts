/**
 *Submitted for verification at Etherscan.io on 2021-09-12
 */

pragma solidity 0.6.11;

contract VendingMachine {
    // Declare state variables of the contract
    address public owner;
    mapping(address => uint256) public cupcakeBalances;

    event Refill(
        address owner,
        uint256 amount,
        uint256 remaining,
        uint256 timestamp,
        uint256 blockNumber
    );
    event Purchase(
        address buyer,
        uint256 amount,
        uint256 remaining,
        uint256 timestamp,
        uint256 blockNumber
    );

    // When 'VendingMachine' contract is deployed:
    // 1. set the deploying address as the owner of the contract
    // 2. set the deployed smart contract's cupcake balance to 100
    constructor() public {
        owner = msg.sender;
        cupcakeBalances[address(this)] = 100;
    }

    // Allow the owner to increase the smart contract's cupcake balance
    function refill(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can refill.");
        cupcakeBalances[address(this)] += amount;
        emit Refill(
            owner,
            amount,
            cupcakeBalances[address(this)],
            block.timestamp,
            block.number
        );
    }

    // Allow anyone to purchase cupcakes
    function purchase(uint256 amount) public payable {
        require(
            msg.value >= amount * 0.01 ether,
            "You must pay at least 0.01 ETH per cupcake"
        );
        require(
            cupcakeBalances[address(this)] >= amount,
            "Not enough cupcakes in stock to complete this purchase"
        );
        cupcakeBalances[address(this)] -= amount;
        cupcakeBalances[msg.sender] += amount;
        emit Purchase(
            msg.sender,
            amount,
            cupcakeBalances[address(this)],
            block.timestamp,
            block.number
        );
    }
}
