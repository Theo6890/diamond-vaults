// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {DiamondVaultStorageCollisionSetUp} from "./helpers/DiamondVaultStorageCollisionSetUp.sol";
// App
import {Vault0Facet} from "../../src/app/eth-vaults/vault0/Vault0Facet.sol";
import {Vault1Facet} from "../../src/app/eth-vaults/vault1/Vault1Facet.sol";

/**
 * @dev Launch test with `--ffi` argument as we use a python which is an arbitrary shell
 *      command
 */
contract DiamondVaultStorageCollisionTest is DiamondVaultStorageCollisionSetUp {
    function test_Vault0_Vault1_VerifyNoDataCollisionHappensOn_setYield()
        public
    {
        vault0 = Vault0Facet(address(diamond));
        vault0.setYield_Vault0(8);

        vault1 = Vault1Facet(address(diamond));
        vault1.setYield_Vault1(150);

        assertEq(vault1.getYield_Vault1(), 150);
        assertEq(vault0.getYield_Vault0(), 8);
    }
}
