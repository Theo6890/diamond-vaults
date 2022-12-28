// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {DiamondInitiliazerHelper} from "../../helpers/DiamondInitiliazerHelper.sol";

import {Vault0Facet} from "../../../src/app/eth-vaults/vault0/Vault0Facet.sol";
import {Vault1Facet} from "../../../src/app/eth-vaults/vault1/Vault1Facet.sol";

contract DiamondVaultStorageCollisionSetUp is DiamondInitiliazerHelper {
    Vault0Facet vault0;
    Vault1Facet vault1;

    function setUp() public {
        _instanciateFacets();
        _registerFacetAddressesAndNames();
        _createAllFacetCut();
        _triggerDiamondCut();
    }

    function _instanciateFacets() internal override {
        super._instanciateFacets();
        // deploy Vault0Facet
        vault0 = new Vault0Facet();
        emit log_named_address("vault0 addr", address(vault0));
        // deploy Vault1Facet
        vault1 = new Vault1Facet();
        emit log_named_address("vault1 addr", address(vault1));
    }

    function _registerFacetAddressesAndNames() internal override {
        super._registerFacetAddressesAndNames();
        facetsAddress.push(address(vault0));
        facetsName.push("Vault0Facet");
        facetsAddress.push(address(vault1));
        facetsName.push("Vault1Facet");
    }
}
