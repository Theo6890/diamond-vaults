// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Vault0Lib} from "./Vault0Lib.sol";

contract Vault0Facet {
    function setOwner(address owner_) public returns (address) {
        Vault0Lib.setOwner(owner_);
    }

    function getOwner() public returns (address) {
        Vault0Lib.getOwner();
    }
}
