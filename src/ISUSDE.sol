// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


/// @title ERC4626 interface
/// See: https://eips.ethereum.org/EIPS/eip-4626
interface ISUSDE {
  function deposit(uint256 assets, address receiver) external returns (uint256 shares);

  function cooldownAssets(uint256 assets) external returns (uint256 shares);

  function cooldownShares(uint256 shares) external returns (uint256 assets);

  function unstake(address receiver) external;

  function balanceOf(address owner) external view returns (uint256 assets);
}
