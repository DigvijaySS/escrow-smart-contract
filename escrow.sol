pragma solidity ^0.5.12;

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

// ----------------------------------------------------------------------------
// Escrow contract
// ----------------------------------------------------------------------------
contract Escrow is SafeMath {
    
    address agent;  // The owner of smart contract
    
    mapping(address => uint256) deposits;   // deposits pending for payee account
    
    // Modifier to allow actions to be executed only by owner
    modifier onlyAgent {
        require(msg.sender == agent);
        _;
    }
    
    constructor () public {
        agent = msg.sender;
    }
    
    // Allow only agent to perform this action.
    // Holds the value in deposits variable and does not transfer it to payee.
    function deposit(address payee) public onlyAgent payable {
        uint256 payment = msg.value;
        deposits[payee] = safeAdd(deposits[payee], payment);
    }
    
    // Allow only agent to perform this action.
    // Transfers the pending deposits amount of payee to payee account from contract account.
    // Clear the pending deposits and set it to 0.
    function withdraw(address payable payee) public onlyAgent {
        uint256 payment = deposits[payee];
        deposits[payee] = 0;
        payee.transfer(payment);
    }
    
}
