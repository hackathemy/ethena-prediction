// src/Types.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BettingToken} from "./BettingToken.sol";

library Types {
    struct Game {
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
        IERC20 token;
        address[] betUsers;
        uint256 winnerTokenId;
        BettingToken bettingToken;
    }

    struct UserBet {
        bool betUp;
        uint256 amount;
        string status;
    }
}
