// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ISUSDE.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract TokenVault is Ownable {

    // 이벤트 정의
    event TokensTransferred(address indexed token, address indexed to, uint256 amount);

    address public sUsdeTokenAddress = 0x1B6877c6Dac4b6De4c5817925DC40E2BfdAFc01b;
    address public usdeTokenAddress = 0xf805ce4F96e0EdD6f0b6cd4be22B34b92373d696;
    IERC20 public usdeToken = IERC20(usdeTokenAddress);
    ISUSDE public sUsdeToken = ISUSDE(sUsdeTokenAddress);
    constructor(address initialOwner) Ownable(initialOwner) {}

    // 토큰 전송 함수
    function transferUsde(
        address to,
        uint256 amount
    ) external onlyOwner {
        require(to != address(0), "Invalid recipient address");

        // IERC20 인터페이스로 토큰 전송
        usdeToken.transfer(to, amount);
    }

    function unstake() external onlyOwner {
        sUsdeToken.unstake(address(this));
    }

    function deposit(uint256 assets) external onlyOwner returns (uint256 shares) {
        usdeToken.approve(sUsdeTokenAddress, assets);
        return sUsdeToken.deposit(assets, address(this));
    }

    function cooldownShares() external onlyOwner {
        sUsdeToken.cooldownShares(sUsdeToken.balanceOf(address(this)));
    }

    function cooldownAssets() external onlyOwner {
        sUsdeToken.cooldownAssets(sUsdeToken.balanceOf(address(this)));
    }

    // 잔액 조회 함수 (옵션)
    function checkBalance(address token, address account) external view returns (uint256) {
        require(token != address(0), "Invalid token address");
        require(account != address(0), "Invalid account address");

        return IERC20(token).balanceOf(account);
    }
}
