// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {IDiamondWritable} from "solidstate-solidity/proxy/diamond/writable/IDiamondWritable.sol";
import {IDiamondWritableInternal} from "solidstate-solidity/proxy/diamond/writable/IDiamondWritableInternal.sol";

import {DiamondVault} from "../../src/app/DiamondVault.sol";

contract DiamondInitiliazerHelper is Test {
    // Facets registration
    address[] public facetsAddress;
    string[] public facetsName;
    IDiamondWritable.FacetCut[] public facetCuts;

    // Froundry specific variables
    address public forgeDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;
    address public msgSender = msg.sender;
    // Random address to impersonate as alice
    address public alice = 0xBaF6dC2E647aeb6F510f9e318856A1BCd66C5e19;

    DiamondVault public diamond;

    function _instanciateFacets() internal virtual {
        diamond = new DiamondVault();
        emit log_named_address("diamond addr", address(diamond));
    }

    /**
     * @notice This function is only used to populate `facetsAddress` &
     *      `facetsName`.
     * @dev Can be overridden so sub tests can either use parent's
     *      registration while adding their or only keep the name for
     *      easiness of reading.
     */
    function _registerFacetAddressesAndNames() internal virtual {}

    /**
     * @notice Creates all `FacetCut` using addresses and names from
     *         `facetsAddress` & `facetsName`.
     */
    function _createFacetCutFromFacetsAddressFacetsName() internal {
        require(
            facetsName.length == facetsAddress.length,
            "Xyz__Initiliazer.setUp(): facetsName.length != facetsAddress.length"
        );

        for (uint256 i; i < facetsName.length; ++i) {
            facetCuts.push(
                IDiamondWritableInternal.FacetCut({
                    target: facetsAddress[i],
                    action: IDiamondWritableInternal.FacetCutAction.ADD,
                    selectors: __generateSelectors(facetsName[i])
                })
            );
        }
    }

    function _triggerDiamondCut() internal {
        // upgrade Diamond with new facets
        IDiamondWritable(address(diamond)).diamondCut(
            facetCuts,
            address(0x0),
            ""
        );
    }

    /**
     * @notice Generates selectors of a given `_facetName`.
     * @dev Only used in `_createFacetCutFromFacetsAddressFacetsName()`
     */
    function __generateSelectors(string memory _facetName)
        private
        returns (bytes4[] memory selectors)
    {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }
}
