// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {DiamondInitiliazerHelper} from "../../../helpers/DiamondInitiliazerHelper.sol";

import {Vault0Facet} from "../../../../src/app/eth-vaults/vault0/Vault0Facet.sol";

contract Vault0Initializer is DiamondInitiliazerHelper {
    Vault0Facet vault0;

    function setUp() public {
        _instanciateFacets();
        _registerFacetAddressesAndNames();
        _createFacetCutFromFacetsAddressFacetsName();
        _triggerDiamondCut();
    }

    /**
     * @dev `DiamondInitiliazerHelper._instanciateFacets()` instanciate
     *      `DiamondVault` contract.
     */
    function _instanciateFacets() internal override {
        DiamondInitiliazerHelper._instanciateFacets();
        // deploy Vault0Facet
        vault0 = new Vault0Facet();
        emit log_named_address("vault0 addr", address(vault0));
    }

    /**
     * @dev Overrides `DiamondInitiliazerHelper._registerFacetAddressesAndNames`
     *      without calling previous implementation as it does not exist in
     *      `DiamondInitiliazerHelper`.
     */
    function _registerFacetAddressesAndNames() internal override {
        facetsAddress.push(address(vault0));
        facetsName.push("Vault0Facet");
    }
}
