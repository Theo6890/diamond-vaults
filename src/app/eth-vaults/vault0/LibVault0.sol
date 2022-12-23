// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {LibVaultCommons, Timelock, VaultAttributes, DepositData, RewardsData, VaultCommons} from "../../default/LibVaultCommons.sol";

library LibVault0 {
    bytes32 constant FEATURE_ONE_STORAGE_POSITION =
        keccak256("diamond.vault.0.storage");

    /// @return vaultCommons Common storage mapping accross all vaults implemented by Vault0
    function commonStorage()
        internal
        pure
        returns (VaultCommons storage vaultCommons)
    {
        bytes32 position = FEATURE_ONE_STORAGE_POSITION;
        assembly {
            vaultCommons.slot := position
        }
    }
}
