// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

// Diamond standards
// Interfaces
import {IDiamondCut} from "../../src/diamond/core/DiamondCut/IDiamondCut.sol";
// Implementation
import {DiamondCutFacet} from "../../src/diamond/core/DiamondCut/DiamondCutFacet.sol";
import {DiamondInit} from "../../src/diamond/upgradeInitializers/DiamondInit.sol";
import {DiamondLoupeFacet} from "../../src/diamond/core/DiamondLoupe/DiamondLoupeFacet.sol";
import {DiamondVault} from "../../src/app/DiamondVault.sol";
import {OwnershipFacet} from "../../src/diamond/core/OwnershipFacet.sol";

contract DiamondInitiliazerHelper is Test {
    // Diamond standards
    DiamondCutFacet public cut;
    DiamondLoupeFacet public loupe;
    DiamondInit public init;
    OwnershipFacet public ownership;
    // Facets registration
    address[] public facetsAddress;
    string[] public facetsName;
    IDiamondCut.FacetCut[] public facetCuts;

    // Froundry specific variables
    address public forgeDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;
    address public msgSender = msg.sender;
    // Random address to impersonate as alice
    address public alice = 0xBaF6dC2E647aeb6F510f9e318856A1BCd66C5e19;

    DiamondVault public diamond;

    function _instanciateFacets() internal virtual {
        // deploy DiamondCutFacet
        cut = new DiamondCutFacet();
        emit log_named_address("cut addr", address(cut));
        // deploy Diamond
        diamond = new DiamondVault(forgeDeployer, address(cut));
        emit log_named_address("diamond addr", address(diamond));
        // deploy DiamondLoupeFacet
        loupe = new DiamondLoupeFacet();
        emit log_named_address("loupe addr", address(loupe));
        // deploy OwnershipFacet
        ownership = new OwnershipFacet();
        emit log_named_address("ownership addr", address(ownership));

        // deploy DiamondInit
        init = new DiamondInit();
        emit log_named_address("init addr", address(init));
    }

    function _registerFacetAddressesAndNames() internal virtual {
        facetsAddress.push(address(loupe));
        facetsName.push("DiamondLoupeFacet");
        facetsAddress.push(address(ownership));
        facetsName.push("OwnershipFacet");
    }

    function _createAllFacetCut() internal {
        // Create the FacetCut struct for this facet.
        assert(facetsName.length == facetsAddress.length);
        for (uint256 i; i < facetsName.length; ++i) {
            facetCuts.push(
                IDiamondCut.FacetCut({
                    facetAddress: facetsAddress[i],
                    action: IDiamondCut.FacetCutAction.Add,
                    functionSelectors: _generateSelectors(facetsName[i])
                })
            );
        }
    }

    function _generateSelectors(string memory _facetName)
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

    function _updateDiamondWithNewFacets() internal {
        // upgrade Diamond with new facets
        IDiamondCut(address(diamond)).diamondCut(
            facetCuts,
            address(0x0),
            ""
            // address(init),
            // abi.encodeWithSelector(bytes4(keccak256("init()")))
        );
    }
}
