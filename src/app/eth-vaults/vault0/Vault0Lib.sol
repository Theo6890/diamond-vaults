// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

struct Vault0 {
    address user;
}

library Vault0Lib {
    bytes32 constant FEATURE_ONE_STORAGE_POSITION =
        keccak256("diamond.standard.vault0.storage");

    /// @notice Return the storage struct for reading and writing in Vault0.
    function getStorage() internal pure returns (Vault0 storage vault0Storage) {
        bytes32 position = FEATURE_ONE_STORAGE_POSITION;
        assembly {
            vault0Storage.slot := position
        }
    }

    function setUser(address user_) internal {
        Vault0 storage s = getStorage();
        s.user = user_;
    }

    function getUser() internal returns (address) {
        return getStorage().user;
    }
}
