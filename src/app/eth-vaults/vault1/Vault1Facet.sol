// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {LibVaultCommons, Timelock, VaultCommons} from "../../default/LibVaultCommons.sol";

import {LibVault1} from "./LibVault1.sol";

contract Vault1Facet {
    function setTimelock_Vault1(Timelock time) public {
        LibVaultCommons.setVaultTimelock(LibVault1.commonStorage(), time);
    }

    function setYield_Vault1(uint8 yieldPercentage) public {
        LibVaultCommons.setVaultYield(
            LibVault1.commonStorage(),
            yieldPercentage
        );
    }

    function getTimelock_Vault1() public returns (Timelock) {
        return LibVaultCommons.getVaultTimelock(LibVault1.commonStorage());
    }

    function getYield_Vault1() public returns (uint8) {
        return LibVaultCommons.getVaultYield(LibVault1.commonStorage());
    }
}
