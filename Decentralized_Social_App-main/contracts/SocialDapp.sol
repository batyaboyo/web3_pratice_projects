// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


contract SocialDapp is ERC721("SocialDApp", "SDP") {
    uint256 tokenId;
    post[] public posts;

    struct post{
        string name;
        string description;
        uint256 upvotes;
        string[] comments;
        address fromAddress;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name":', '"', posts[_tokenId].name, '",'  '"description":' , '"',  posts[_tokenId].description, '"', ',' ,
            
            '"attributes":', '[', '{', '"trait_type":', '"Upvotes",' , '"value":', Strings.toString(posts[_tokenId].upvotes), '}', ']' , '}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function writePost(string memory prefName, string memory prefDesc) public {
        _safeMint(msg.sender, tokenId);
        posts.push(post({
            name: prefName,
            description: prefDesc,
            upvotes: 0,
            comments: new string[](0),
            fromAddress: msg.sender
        }));
        tokenId = tokenId + 1;
    }

    function upvote(uint postIndex) public {
        posts[postIndex].upvotes += 1;
    }

    function addComment(uint256 postIndex, string memory prefComments) public {
        posts[postIndex].comments.push(prefComments);
    }

    function getAllPosts() public view returns(post[] memory) {
        return posts;
    }
}