// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Chatbot {
    struct Message {
        address sender;
        string content;
        string response;
    }

    Message[] public messages;

    event MessageSent(address indexed sender, string content, string response);

    function sendMessage(string memory _content) public {
        string memory response = "hello, nice to meet you";
        messages.push(Message(msg.sender, _content, response));
        emit MessageSent(msg.sender, _content, response);
    }

    function getMessage(uint _index) public view returns (address, string memory, string memory) {
        require(_index < messages.length, "Message index out of bounds");
        Message storage message = messages[_index];
        return (message.sender, message.content, message.response);
    }

    function getMessageCount() public view returns (uint) {
        return messages.length;
    }

    function getMessageWithResponse(uint _index) public view returns (string memory, string memory) {
        require(_index < messages.length, "Message index out of bounds");
        Message storage message = messages[_index];
        return (message.content, message.response);
    }
}
