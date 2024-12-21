// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ViralEducationRewards {
    address public owner;
    uint public totalRewards;
    mapping(address => uint) public rewards;

    event RewardIssued(address indexed recipient, uint amount);
    event RewardClaimed(address indexed recipient, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function depositRewards() public payable onlyOwner {
        totalRewards += msg.value;
    }

    function issueReward(address recipient, uint amount) public onlyOwner {
        require(amount <= totalRewards, "Not enough rewards available");
        rewards[recipient] += amount;
        totalRewards -= amount;
        emit RewardIssued(recipient, amount);
    }

    function claimReward() public {
        uint reward = rewards[msg.sender];
        require(reward > 0, "No rewards available for claiming");
        
        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);

        emit RewardClaimed(msg.sender, reward);
    }

    function checkRewardBalance(address recipient) public view returns (uint) {
        return rewards[recipient];
    }

    function getTotalRewards() public view returns (uint) {
        return totalRewards;
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
        totalRewards = 0;
    }
}
