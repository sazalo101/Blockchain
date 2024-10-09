// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArticleWritingDApp {
    struct Article {
        uint id;
        address author;
        string title;
        string content;
        uint timestamp;
    }

    uint public articleCount;
    mapping(uint => Article) public articles;

    event ArticleCreated(
        uint id,
        address author,
        string title,
        string content,
        uint timestamp
    );

    // Function to create an article
    function createArticle(string memory _title, string memory _content) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_content).length > 0, "Content cannot be empty");

        articleCount++;

        articles[articleCount] = Article(
            articleCount,
            msg.sender,
            _title,
            _content,
            block.timestamp
        );

        emit ArticleCreated(articleCount, msg.sender, _title, _content, block.timestamp);
    }

    // Function to fetch an article by ID
    function getArticle(uint _id) public view returns (
        uint, 
        address, 
        string memory, 
        string memory, 
        uint
    ) {
        require(_id > 0 && _id <= articleCount, "Invalid article ID");
        Article storage article = articles[_id];
        return (
            article.id,
            article.author,
            article.title,
            article.content,
            article.timestamp
        );
    }
}
