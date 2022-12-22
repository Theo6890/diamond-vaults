// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {LibDiamond} from "../src/diamond/core/LibDiamond.sol";
import {OwnershipFacet} from "../src/diamond/core/OwnershipFacet.sol";
import {DiamondCutFacet} from "../src/diamond/core/DiamondCut/DiamondCutFacet.sol";
import {IDiamondCut} from "../src/diamond/core/DiamondCut/IDiamondCut.sol";
import {DiamondInit} from "../src/diamond/upgradeInitializers/DiamondInit.sol";
import {DiamondLoupeFacet} from "../src/diamond/core/DiamondLoupe/DiamondLoupeFacet.sol";

import {DiamondVault} from "../src/app/DiamondVault.sol";
import {Vault0Facet} from "../src/app/eth-vaults/vault0/Vault0Facet.sol";
import {Vault0Lib} from "../src/app/eth-vaults/vault0/Vault0Lib.sol";

/**
 * @dev Launch test with `--ffi` argument as we use a python which is an arbitrary shell
 *      command
 */
contract DiamondVaultTest is Test {
    DiamondCutFacet private cut;
    DiamondVault private diamond;
    DiamondInit private init;
    DiamondLoupeFacet private loupe;
    OwnershipFacet private ownership;

    // IDiamondCut diamondCut;

    address[] facetsAddress;
    string[] facetsName;
    IDiamondCut.FacetCut[] private _facetCuts;

    Vault0Facet vault0;
    address forgeDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;
    address msgSender = msg.sender;

    address alice = 0xBaF6dC2E647aeb6F510f9e318856A1BCd66C5e19;

    function setUp() public {
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
        // deploy Vault0Facet
        vault0 = new Vault0Facet();
        emit log_named_address("vvault0 addr", address(vault0));

        // deploy DiamondInit
        init = new DiamondInit();
        emit log_named_address("init addr", address(init));

        facetsAddress.push(address(loupe));
        facetsName.push("DiamondLoupeFacet");
        facetsAddress.push(address(ownership));
        facetsName.push("OwnershipFacet");
        facetsAddress.push(address(vault0));
        facetsName.push("Vault0Facet");

        // Create the FacetCut struct for this facet.
        assert(facetsName.length == facetsAddress.length);
        for (uint256 i; i < facetsName.length; ++i) {
            _facetCuts.push(
                IDiamondCut.FacetCut({
                    facetAddress: facetsAddress[i],
                    action: IDiamondCut.FacetCutAction.Add,
                    functionSelectors: _generateSelectors(facetsName[i])
                })
            );
        }

        // upgrade Diamond with facets
        IDiamondCut(address(diamond)).diamondCut(
            _facetCuts,
            address(0x0),
            ""
            // address(init),
            // abi.encodeWithSelector(bytes4(keccak256("init()")))
        );
    }

    function _generateSelectors(string memory _facetName)
        internal
        returns (bytes4[] memory selectors)
    {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    /*//////////////////////////////////////////////////////////////
                                 BASIC ATTRIBUTES
    //////////////////////////////////////////////////////////////*/
    function test_FindVault0FromSetOwnerSelector() public {
        address facetAddress = DiamondLoupeFacet(address(diamond)).facetAddress(
            bytes4(keccak256("setUser(address)"))
        );

        assertTrue(facetAddress != address(0));
    }

    function test_OwnershipFacet() public {
        ownership = OwnershipFacet(address(diamond));
        emit log_named_address("owner", ownership.owner());
    }

    function test_Vault0_SetUser() public {
        vault0 = Vault0Facet(address(diamond));
        vault0.setUser(alice);

        assertEq(vault0.getUser(), alice);
    }
}
