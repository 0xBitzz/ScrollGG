// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollGuessGame {
    address public owner;
    uint256 public randomNumber;
    uint256 public constant betAmount = 0.01 ether;
    mapping(address => uint256) public userGuesses;

    event NumberGuessed(address indexed player, uint256 guessedNumber, uint256 randomNumber);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function generateRandomNumber() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % 10 + 1;
    }

    function placeBet(uint256 _guess) external payable {
        require(msg.value == betAmount, "Bet amount must be exactly 0.01 ether");
        require(userGuesses[msg.sender] == 0, "You have already placed a bet");
        userGuesses[msg.sender] = _guess;
        emit NumberGuessed(msg.sender, _guess, randomNumber);
        randomNumber = generateRandomNumber();
    }

    function revealRandomNumber() external view onlyOwner returns (uint256) {
        return randomNumber;
    }

    function claimReward() external {
        require(userGuesses[msg.sender] > 0, "You haven't placed a bet yet");
        require(randomNumber == userGuesses[msg.sender], "Your guess was incorrect");
        uint256 reward = betAmount * 2;
        payable(msg.sender).transfer(reward);
        userGuesses[msg.sender] = 0;
    }

    function withdrawFunds() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
    }

    receive() external payable {}

    fallback() external payable {}
}
