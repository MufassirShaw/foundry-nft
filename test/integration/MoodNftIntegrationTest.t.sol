// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    address USER = makeAddr("user");
    string constant SAD_TOKEN_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZE5mdCIsImRlc2NyaXB0aW9uIjoiQW4gTkZUIHJlZmxlY3RpbmcgdGhlIG1vb2Qgb2YgdGhlIG93bmVyIiwgImF0dHJpYnV0ZXM6W3sgInRyYWl0X3R5cGUiOiJtb29kbmllc3MiLCAidmFsdWUiOjEwMH1dLCIiaW1hZ2UiOmRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjJhV1YzUW05NFBTSXdJREFnTWpBd0lESXdNQ0lnZDJsa2RHZzlJalF3TUNJZ0lHaGxhV2RvZEQwaU5EQXdJaUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lQZ29nSUR4amFYSmpiR1VnWTNnOUlqRXdNQ0lnWTNrOUlqRXdNQ0lnWm1sc2JEMGllV1ZzYkc5M0lpQnlQU0kzT0NJZ2MzUnliMnRsUFNKaWJHRmpheUlnYzNSeWIydGxMWGRwWkhSb1BTSXpJaTgrQ2lBZ1BHY2dZMnhoYzNNOUltVjVaWE1pUGdvZ0lDQWdQR05wY21Oc1pTQmplRDBpTmpFaUlHTjVQU0k0TWlJZ2NqMGlNVElpTHo0S0lDQWdJRHhqYVhKamJHVWdZM2c5SWpFeU55SWdZM2s5SWpneUlpQnlQU0l4TWlJdlBnb2dJRHd2Wno0S0lDQThjR0YwYUNCa1BTSnRNVE0yTGpneElERXhOaTQxTTJNdU5qa2dNall1TVRjdE5qUXVNVEVnTkRJdE9ERXVOVEl0TGpjeklpQnpkSGxzWlQwaVptbHNiRHB1YjI1bE95QnpkSEp2YTJVNklHSnNZV05yT3lCemRISnZhMlV0ZDJsa2RHZzZJRE03SWk4K0Nqd3ZjM1puUGc9PSJ9";

    function setUp() public {
        DeployMoodNft deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testNftMoodFlip() public {
        vm.prank(USER);
        moodNft.mintNft();

        string memory actualUri = moodNft.tokenURI(0);

        assert(
            keccak256(abi.encodePacked(actualUri)) ==
                keccak256(abi.encodePacked(SAD_TOKEN_URI))
        );
    }
}
