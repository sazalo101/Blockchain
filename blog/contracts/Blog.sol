// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Blog {
    struct Comment {
        address commenter;
        string content;
        uint256 timestamp;
    }

    struct ArticleVersion {
        string content;
        uint256 timestamp;
    }

    struct Article {
        string title;
        ArticleVersion[] versions;
        address owner;
        uint256 upvotes;
        string[] tags;
        string category;
        Comment[] comments;
    }

    mapping(uint256 => Article) public articles;
    mapping(uint256 => bool) public articleExists;
    mapping(uint256 => mapping(address => bool)) public hasUpvoted;
    uint256 public articleCount;

    event ArticleCreated(uint256 indexed articleId, address indexed owner, string title, string content, uint256 timestamp);
    event ArticleEdited(uint256 indexed articleId, address indexed owner, string newContent, uint256 timestamp);
    event ArticleUpvoted(uint256 indexed articleId, address indexed upvoter);
    event CommentAdded(uint256 indexed articleId, address indexed commenter, string content);

    constructor() {
        articleCount = 0;
    }

    function createArticle(string memory _title, string memory _content, string[] memory _tags, string memory _category) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_content).length > 0, "Content cannot be empty");
        
        Article storage newArticle = articles[articleCount];
        newArticle.title = _title;
        newArticle.versions.push(ArticleVersion({content: _content, timestamp: block.timestamp}));
        newArticle.owner = msg.sender;
        newArticle.upvotes = 0;
        newArticle.tags = _tags;
        newArticle.category = _category;
        articleExists[articleCount] = true;
        
        emit ArticleCreated(articleCount, msg.sender, _title, _content, block.timestamp);
        articleCount++;
    }

    function editArticle(uint256 _articleId, string memory _newContent) public {
        require(_articleId < articleCount, "Article ID does not exist");
        require(articleExists[_articleId], "Article has been deleted");
        require(articles[_articleId].owner == msg.sender, "Only the owner can edit this article");

        Article storage article = articles[_articleId];
        article.versions.push(ArticleVersion({content: _newContent, timestamp: block.timestamp}));
        
        emit ArticleEdited(_articleId, msg.sender, _newContent, block.timestamp);
    }

    function upvoteArticle(uint256 _articleId) public {
        require(_articleId < articleCount, "Article ID does not exist");
        require(articleExists[_articleId], "Article has been deleted");
        require(!hasUpvoted[_articleId][msg.sender], "You have already upvoted this article");

        articles[_articleId].upvotes++;
        hasUpvoted[_articleId][msg.sender] = true;
        
        emit ArticleUpvoted(_articleId, msg.sender);
    }

    function addComment(uint256 _articleId, string memory _content) public {
        require(_articleId < articleCount, "Article ID does not exist");
        require(articleExists[_articleId], "Article has been deleted");
        require(bytes(_content).length > 0, "Comment cannot be empty");

        Comment memory newComment = Comment({
            commenter: msg.sender,
            content: _content,
            timestamp: block.timestamp
        });

        articles[_articleId].comments.push(newComment);
        
        emit CommentAdded(_articleId, msg.sender, _content);
    }

    function getArticle(uint256 _articleId) public view returns (
        string memory title,
        string memory content, 
        address owner, 
        uint256 upvotes, 
        string[] memory tags, 
        string memory category, 
        uint256 commentCount
    ) {
        require(_articleId < articleCount, "Article ID does not exist");
        require(articleExists[_articleId], "Article has been deleted");
        
        Article storage article = articles[_articleId];
        return (
            article.title,
            article.versions[article.versions.length - 1].content, 
            article.owner, 
            article.upvotes, 
            article.tags, 
            article.category, 
            article.comments.length
        );
    }

    function getComments(uint256 _articleId) public view returns (Comment[] memory) {
        require(_articleId < articleCount, "Article ID does not exist");
        require(articleExists[_articleId], "Article has been deleted");
        
        return articles[_articleId].comments;
    }
}
