// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();
    enum Mood {
        HAPPY,
        SAD
    }
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenToUri;
    string private s_sadSvgImgUri;
    string private s_happySvgImgUri;

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory happySvgImgUri,
        string memory sadSvgImgUri
    ) ERC721("MoodNft", "MN") {
        s_happySvgImgUri = happySvgImgUri;
        s_sadSvgImgUri = sadSvgImgUri;
        s_tokenCounter = 0;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageUri;

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happySvgImgUri;
        } else {
            imageUri = s_sadSvgImgUri;
        }

        string memory tokenMetaData = Base64.encode(
            bytes(
                abi.encodePacked(
                    '{"name":"',
                    name(),
                    '","description":"An NFT reflecting the mood of the owner", "attributes:[{ "trait_type":"moodniess", "value":100}],"',
                    '"image":',
                    imageUri,
                    '"}'
                )
            )
        );

        return string(abi.encodePacked(_baseURI(), tokenMetaData));
    }

    function flipMood(uint256 tokenId) public {
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
