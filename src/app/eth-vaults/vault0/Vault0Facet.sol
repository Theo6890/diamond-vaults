// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Vault0Lib} from "./Vault0Lib.sol";

contract Vault0Facet {
    function setUser(address user_) public returns (address) {
        Vault0Lib.setUser(user_);
    }

    function getUser() public returns (address) {
        return Vault0Lib.getUser();
    }
}
