// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {LibVaultCommons, Timelock, VaultCommons} from "../../default/LibVaultCommons.sol";

import {LibVault0} from "./LibVault0.sol";

contract Vault0Facet {
    function setTimelock_Vault0(Timelock time) public {
        LibVaultCommons.setVaultTimelock(LibVault0.commonStorage(), time);
    }

    function setYield_Vault0(uint8 yieldPercentage) public {
        LibVaultCommons.setVaultYield(
            LibVault0.commonStorage(),
            yieldPercentage
        );
    }

    function getTimelock_Vault0() public view returns (Timelock) {
        return LibVaultCommons.getVaultTimelock(LibVault0.commonStorage());
    }

    function getYield_Vault0() public view returns (uint8) {
        return LibVaultCommons.getVaultYield(LibVault0.commonStorage());
    }
}
