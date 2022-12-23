// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Vault0Initializer} from "./Vault0Initializer.sol";
import {DiamondLoupeFacet} from "../../../../src/diamond/core/DiamondLoupe/DiamondLoupeFacet.sol";
// App
import {Vault0Facet} from "../../../../src/app/eth-vaults/vault0/Vault0Facet.sol";

contract Vault0FacetTest is Vault0Initializer {
    /*//////////////////////////////////////////////////////////////
                            COMMON DIAMOND FEATURES
    //////////////////////////////////////////////////////////////*/
    function test_DiamondLoupeFacet_FetchFacetAddressFrom_setYield_Vault0()
        public
    {
        address facetAddress = DiamondLoupeFacet(address(diamond)).facetAddress(
            bytes4(keccak256("setYield_Vault0(uint8)"))
        );

        assertTrue(facetAddress != address(0));
    }

    /*//////////////////////////////////////////////////////////////
                            COMMON VAULT FEATURES
    //////////////////////////////////////////////////////////////*/
    function test_setYield_Vault0() public {
        vault0 = Vault0Facet(address(diamond));
        vault0.setYield_Vault0(8);

        assertEq(vault0.getYield_Vault0(), 8);
    }
}
