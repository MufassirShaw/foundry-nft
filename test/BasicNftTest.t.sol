// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address USER = makeAddr("user");
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    string public constant TOKEN_NAME = "Cat";
    string public constant TOKEN_SYMBOL = ":smile_cat:";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testCheckInitializedCorrectly() public {
        // string memory expectedName = "Cat";
        string memory actualName = basicNft.name();
        string memory actualSymbol = basicNft.symbol();

        assertEq(
            keccak256(abi.encodePacked(TOKEN_NAME)),
            keccak256(abi.encodePacked(actualName))
        );

        assertEq(
            keccak256(abi.encodePacked(TOKEN_SYMBOL)),
            keccak256(abi.encodePacked(actualSymbol))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        uint256 balance = basicNft.balanceOf(USER);
        assert(balance == 1);
    }

    function testCheckTokenUriIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        string memory tokenUri = basicNft.tokenURI(0);
        assertEq(
            keccak256(abi.encodePacked(PUG_URI)),
            keccak256(abi.encodePacked(tokenUri))
        );
    }
}
