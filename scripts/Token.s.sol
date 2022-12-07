// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Token.sol";

contract DeployToken is Script {
    function run() external {
        vm.startBroadcast();

        Token token = new Token();

        vm.stopBroadcast();
    }
}
