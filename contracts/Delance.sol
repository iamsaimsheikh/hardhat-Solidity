// SPDX-License-Identifier:UNLICENSED

pragma solidity 0.8.17;

struct Request {
    string title;
    uint256 amount;
    bool locked;
    bool paid;
}

import "../node_modules/hardhat/console.sol";

contract Delance {

    Request[] public requests;
    address payable public employer;
    address payable public freelancer;
    bool locked = false;
    uint public deadline;
    uint public price;
    string private greet;

    event RequestPaid(address receiver, uint256 amount);

    constructor(string memory _greet) payable {
        console.log("Deploying Delance Contract");
        greet = _greet;
        employer = payable(msg.sender);   
    }

    function greeting() public view returns (string memory) {
        return greet;
    }

    function getFreelancer() public view returns (address) {
        return freelancer;
    }

    modifier onlyEmployer() {
        require(msg.sender == employer, "Only Employer!");
        _;
    }
    modifier onlyFreelancer(){
        require(msg.sender == freelancer,"Only Freelancer!");
        _;        
    }

    event RequestUnlocked(bool locked);

    event requestCreated(string _title, uint256 _amount, bool locked, bool paid);

    function createProject(address payable _freelancer, uint256 _deadline, uint _price) public payable onlyEmployer {
        freelancer = _freelancer;
        deadline = _deadline;
        price = _price;
    }

    function getAllRequests() public view returns (Request[] memory) {
        return requests;
    }

    function createRequests(string memory _title, uint256 _amount) public onlyFreelancer {

        Request memory request = Request({
            title: _title,
            amount: _amount,
            locked: true,
            paid: false
        });

        requests.push(request);

        emit requestCreated(_title, _amount, request.locked, request.paid);
    }

    function unlockRequest(uint256 _index) public onlyEmployer {
        Request storage request = requests[_index];
        request.locked = false;

        emit RequestUnlocked(request.locked);
    }

    function payRequest(uint256 _index) public onlyFreelancer {
        
        require(!locked,'Reentrant detected!');
        
        Request storage request = requests[_index];
        require(!request.locked, "Request is locked");
        require(!request.paid, "Already paid");
        
        locked = true;
        
        console.log(request.amount);

        (bool success, bytes memory transactionBytes) = 
        freelancer.call{value:request.amount}('');

        console.log(success);
        
        require(success, "Transfer failed.");
        
        request.paid = true;
        
        locked = false;
        
        emit RequestPaid(msg.sender, request.amount);
    }

    receive() external payable {
        price += msg.value;
    }

}