// src/Types.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TokenVault.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BettingToken} from "./BettingToken.sol";

library Types {
    struct Game {
        uint256 gameId;
        uint256 startTime;
        uint256 duration;
        uint256 markedPrice;
        uint256 lastPrice;
        uint256 minAmount;
        uint256 upAmount;
        uint256 downAmount;
        uint256 prizeAmount;
        bool isBetEnded;
        bool isEnded;
        address priceFeed;
        address[] betUsers;
        uint256 winnerTokenId;
        BettingToken bettingToken;
        TokenVault tokenVault;
        uint256 betEndTime;
        uint256 gameEndTime;
    }
}
