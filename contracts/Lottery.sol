// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    function getPlayers() public view returns (address payable[] memory){
        return players;
    }

    // Payable = function caller must send in some amount of ether
    function enter() public payable {
        // We can pass a boolean to it, if false, the execution of the function stops.
        // msg.value is in wei, 'ether' converts the value to wei
        require(msg.value > .01 ether);
        players.push(payable(msg.sender));
    }

    // As there is no random number generator in Solidity, develop a pseudo-random method
    function random() private view returns (uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        payable(players[index]).transfer(address(this).balance);
        players = new address payable[](0); // New empty dynamic array
    }

    // In order to avoid code duplication
    modifier restricted() {
        // Only the manager should be able to call this function
        require(msg.sender == manager);

        // In compile time, this placeholder is replaced with the code of the function that uses this modifier
        _;
    }
}