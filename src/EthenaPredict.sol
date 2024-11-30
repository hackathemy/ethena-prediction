// contracts/BetMeme.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BettingToken.sol";
import "./ISUSDE.sol";
import "./Types.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "chainlink-brownie-contracts/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract EthenaPredict {

    address public sUsdeTokenAddress = 0x1B6877c6Dac4b6De4c5817925DC40E2BfdAFc01b;
    address public usdeTokenAddress = 0xf805ce4F96e0EdD6f0b6cd4be22B34b92373d696;
    IERC20 public usdeToken = IERC20(usdeTokenAddress);
    ISUSDE public sUsdeToken = ISUSDE(sUsdeTokenAddress);
    AggregatorV3Interface internal priceFeed;

    uint256 public gameCounter = 1;
    mapping(uint256 => Types.Game) public games;

    event GameCreated(address tokenAddress);
    event BetPlaced(address indexed user, bool betUp, uint256 amount);
    event GameEnded(uint256 lastPrice,uint256 winnerTokenId);
    event Claimed(address indexed user, uint256 reward);
    event PrizeAmount(uint256 prizeAmount);

    constructor() {

    }

    function createGame(uint256 duration,uint256 minAmount, address _priceFeed, string memory upTokenURI, string memory downTokenURI) external {
        require(duration > 0, "Duration must be greater than 0");
        require(minAmount > 0, "Minimum bet amount must be greater than 0");
        //duratrion은 최소 10일 이상이어야함
        //require(duration >= 864000, "Duration must be greater than 10 days");
        priceFeed = AggregatorV3Interface(_priceFeed);
        games[gameCounter] = Types.Game({
            gameId: gameCounter,
            startTime: block.timestamp,
            duration: duration,
            markedPrice: getLatestPrice(),
            lastPrice: 0,
            minAmount: minAmount,
            upAmount: 0,
            downAmount: 0,
            prizeAmount: 0,
            isBetEnded: false,
            isEnded: false,
            priceFeed: _priceFeed,
            betUsers: new address[](0),
            winnerTokenId:100,
            bettingToken: new BettingToken(address(this),upTokenURI,downTokenURI),
            tokenVault: new TokenVault(address(this)),
            betEndTime: 0,
            gameEndTime: 0
        });

        emit GameCreated(_priceFeed);
        gameCounter++;
    }

    function bet(uint256 gameId,bool betUp, uint256 amount) external {
        Types.Game storage game = games[gameId];
        require(game.isEnded == false, "Game already ended");
        require(game.startTime != 0, "Game does not exist");
        require(amount >= game.minAmount, "Bet amount too low");
        require(usdeToken.transferFrom(msg.sender, address(game.tokenVault), amount), "Token transfer failed");

        //game.tokenVault.deposit(amount);


        if (betUp) {
            game.upAmount += amount;
            game.bettingToken.mint(msg.sender,1, amount, "0x");
        } else {
            game.downAmount += amount;
            game.bettingToken.mint(msg.sender,2, amount, "0x");
        }

        game.prizeAmount += amount;

        emit BetPlaced(msg.sender, betUp, amount);
    }


    function endBet(uint256 gameId) external {
        Types.Game storage game = games[gameId];
        require(game.isBetEnded == false, "Bet already ended");


        game.isBetEnded = true;
        game.betEndTime = block.timestamp;
    }

    function endGame(uint256 gameId, uint256 lastPrice) external {
        Types.Game storage game = games[gameId];
        require(game.startTime != 0, "Game does not exist");
        require(game.isEnded == false, "Game already ended");
        //require(block.timestamp >= betEndTime + 604800, "unstake time not over");

        //game.tokenVault.cooldownShares();
        game.lastPrice = lastPrice;


        if (game.lastPrice >= game.markedPrice) {
            game.winnerTokenId = 1;
        } else {
            game.winnerTokenId = 2;
        }

        emit GameEnded(lastPrice,game.winnerTokenId);
        game.isEnded = true;
        game.gameEndTime = block.timestamp;
    }

    function unstake(uint256 gameId) external {
        Types.Game storage game = games[gameId];
        require(game.isEnded == true, "Game not ended");
        require(block.timestamp >= game.gameEndTime + 604800, "unstake time not over");
        //game.tokenVault.unstake();
        game.prizeAmount = usdeToken.balanceOf(address(game.tokenVault));

        emit PrizeAmount(game.prizeAmount);
    }

    function claim(uint256 gameId, uint256 amount) external {
        Types.Game storage game = games[gameId];
        require(game.isEnded == true, "Game not ended");
        game.bettingToken.burn(msg.sender,game.winnerTokenId,amount);
        uint prizeAmount = 0;

        if (game.winnerTokenId == 1) {
            prizeAmount = game.upAmount;
        } else if (game.winnerTokenId == 2) {
            prizeAmount = game.downAmount;
        } else {
            revert("Invalid winner token id");
        }

        uint256 reward = amount * game.prizeAmount / prizeAmount;
        game.tokenVault.transferUsde(msg.sender, reward);
        emit Claimed(msg.sender, reward);
    }

    function getGame(uint256 gameId) external view returns (Types.Game memory) {
        Types.Game storage game = games[gameId];
        return game;
    }

    function getGameList() external view returns (Types.Game[] memory) {
        Types.Game[] memory gameList = new Types.Game[](gameCounter);
        for (uint256 i = 0; i < gameCounter; i++) {
            gameList[i] = games[i];
        }
        return gameList;
    }

    function getLatestPrice() public view returns (uint256) {
        (
        /* uint80 roundID */,
            int price,
        /* uint startedAt */,
        /* uint timeStamp */,
        /* uint80 answeredInRound */
        ) = priceFeed.latestRoundData();
        return uint256(price);
    }

}
