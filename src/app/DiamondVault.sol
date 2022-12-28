// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SolidStateDiamond} from "solidstate-solidity/proxy/diamond/SolidStateDiamond.sol";

/**
 * @notice A diamond contains one or more facets that implement the logic of the app.
 *
 *      The diamond only contains immutable functions, which means these functions will
 *      never be updated at any point in time.
 *
 *      The diamond serves as a storage to save all data from the facets
 *
 *
 * @dev As we use a delegatecall, `msg.sender` & `msg.value` will always depend on the
 *      diamond's context.
 *      In other words, if walletA is `msg.sender` & 10 ether is `msg.value` in the
 *      diamond, the same values will be used in called facets.
 *
 *      The diamond maps function's selector/signature to the address that implements it.
 *      Unfortunately, in the `EIP-2535` a diamond can only implement a function once. We
 *      can not use the same function selector/signature in different facets, otherwise
 *      the mapping will fail.
 *
 */
contract DiamondVault is SolidStateDiamond {

}
