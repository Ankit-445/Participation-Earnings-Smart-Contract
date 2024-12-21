// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ParticipationEarnings {
    address public owner;
    uint256 public rewardPerEvent; // Reward per learning event

    struct Participant {
        uint256 totalEventsParticipated;
        uint256 totalEarnings;
    }

    mapping(address => Participant) public participants;

    event EventParticipation(address indexed participant, uint256 indexed eventsParticipated, uint256 totalEarnings);
    event RewardWithdrawn(address indexed participant, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor(uint256 _rewardPerEvent) {
        owner = msg.sender;
        rewardPerEvent = _rewardPerEvent;
    }

    function participateInEvent() public {
        participants[msg.sender].totalEventsParticipated += 1;
        participants[msg.sender].totalEarnings += rewardPerEvent;

        emit EventParticipation(msg.sender, participants[msg.sender].totalEventsParticipated, participants[msg.sender].totalEarnings);
    }

    function withdrawRewards() public {
        uint256 rewardAmount = participants[msg.sender].totalEarnings;
        require(rewardAmount > 0, "No rewards available to withdraw.");

        participants[msg.sender].totalEarnings = 0;
        payable(msg.sender).transfer(rewardAmount);

        emit RewardWithdrawn(msg.sender, rewardAmount);
    }

    function updateRewardPerEvent(uint256 _newReward) public onlyOwner {
        rewardPerEvent = _newReward;
    }

    // Contract can receive Ether
    receive() external payable {}

    function withdrawContractBalance() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}