//SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

contract SBank
{

    bool locked;

    //This mapping stores the account information for each user, with their Ethereum address as the key.
    mapping (address => Account) public Accounts; 

    //his array stores the list of all account addresses for easier iteration.
    address[] internal AccountArr;

    //Defines the structure for each account, containing balance and last interaction time.
    struct Account
    {
        uint256 balance;
        uint256 lastinteractiontime;
    }

    //Event emitted when a new account is created.
    event AccountCreated(address indexed user);
    //Event emitted when a deposit is made to an account.
    event Deposit(address indexed user, uint256 amt);
    //Event emitted when a withdrawal is made from an account.
    event Withdrawal(address indexed user, uint256 amt);
    //Event emitted when funds are transferred between accounts.
    event Transfer(address indexed from, address indexed to, uint256 amount);
    //Event emitted when interest is calculated and added to an account.
    event InterestFeature(address indexed lastinteractiontime, uint256 interest);

    //Checks if the sender has an existing account.
    modifier accountExists() 
    {
        require(Accounts[msg.sender].balance > 0, "Account does not exist");
        _;
    }

    // To condition rentry
    modifier noRentry()
    {
        require(!locked, "No rentry allowed");
        locked = true;
        _;
        locked = false;
    }

    //Creates a new account for the caller.
    function accountCreation() public 
    {
        require(Accounts[msg.sender].balance == 0, "Account already exists");
        Accounts[msg.sender].lastinteractiontime = block.timestamp;
        emit AccountCreated(msg.sender);
    }

    //Retrieves the balance of the caller's account.
    function getBalance() public view accountExists returns(uint256)
    {
        return (Accounts[msg.sender].balance);
    }

    //Deposits Ether into the caller's account.
    function deposit() public payable accountExists noRentry
    {
        Accounts[msg.sender].balance += msg.value;
        Accounts[msg.sender].lastinteractiontime = block.timestamp;
        emit Deposit(msg.sender, msg.value);
    }

    //Withdraws Ether from the caller's account.
    function withdrawal(uint256 amt) public accountExists noRentry
    {
        require(Accounts[msg.sender].balance < amt, "Insufficient Balance.");
        Accounts[msg.sender].balance -= amt;
        payable(msg.sender).transfer(amt);
        emit Withdrawal(msg.sender, amt);
    }

    //Transfers Ether from the caller's account to another account.
    function transfer(address to, uint256 amt) public accountExists noRentry
    {
        require(to != address(0), "Invalid recipient");
        require(Accounts[msg.sender].balance < amt, "Insufficient Balance");
        Accounts[msg.sender].balance -= amt;
        Accounts[to].balance += amt;
        emit Transfer(msg.sender, to, amt);
    } 

    //Calculates and adds interest to all accounts.
    function interest_cal() external 
    {
        uint256 currenttimestamp = block.timestamp;
        uint256 InterestPerSec = 100  ;
        for(uint256 i=0; i < AccountArr.length; i++)
        {
            address user =  AccountArr[i];
            uint256 elapsedtimestamp = currenttimestamp - Accounts[user].lastinteractiontime;
            uint256 elapsedtimeday = elapsedtimestamp / 1 days ;
            uint256 interest = (elapsedtimeday * InterestPerSec * Accounts[user].balance)/36500;
            Accounts[user].balance += interest;
            Accounts[user].lastinteractiontime  = block.timestamp;
            emit InterestFeature(user, interest);
        }
    }

    // Fallback function: Revert any transactions that try to send Ether to the contract without specifying a function to call
    fallback() external payable 
    {
        revert("Fallback function not allowed");
    }

    // Receive function: Accept incoming Ether transactions
    receive() external payable 
    {
        revert("Receive function not implemented");
    }
}




