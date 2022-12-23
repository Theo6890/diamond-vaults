// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

enum Timelock {
    ONE_MONTH,
    TWO_MONTH,
    THREE_MONTH,
    SIX_MONTH,
    ONE_YEAR
}

struct VaultAttributes {
    uint8 yield; // always an integer reprensenting the exact yield percentage
    Timelock timelock;
    uint256 withdrawTimelock; // 0 by default
    address supportedCurrency; // address(0) = native chain currency
}

struct DepositData {
    uint256 totalDeposited;
    mapping(address => uint256) amountDepositedBy;
}

struct RewardsData {
    uint256 totalRewardsClaimed;
    mapping(address => uint256) rewardsClaimedBy;
}

struct VaultCommons {
    VaultAttributes attributes;
    DepositData depositData;
    RewardsData rewardsData;
}

/**
 * @notice Common library used accross ALL vaults.
 */
library LibVaultCommons {
    function setVaultTimelock(VaultCommons storage vault, Timelock time)
        internal
    {
        vault.attributes.timelock = time;
    }

    function setVaultYield(VaultCommons storage vault, uint8 yieldPercentage)
        internal
    {
        vault.attributes.yield = yieldPercentage;
    }

    function getVaultTimelock(VaultCommons storage vault)
        internal
        view
        returns (Timelock)
    {
        return vault.attributes.timelock;
    }

    function getVaultYield(VaultCommons storage vault)
        internal
        view
        returns (uint8)
    {
        return vault.attributes.yield;
    }

    function claimRewards() external {}

    function amountDepositedBy(address) external pure returns (uint256) {}

    function pendingRewardsOf(address) public pure returns (uint256) {}

    function rewardsClaimedBy() external pure returns (uint256) {}

    function totalDeposited() external pure returns (uint256) {}

    function totalRewardsClaimed() external pure returns (uint256) {}
}
