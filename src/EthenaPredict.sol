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
    IERC20 public usdeToken = IERC20(0xf805ce4F96e0EdD6f0b6cd4be22B34b92373d696);
    ISUSDE public sUsdeToken = ISUSDE(sUsdeTokenAddress);
    AggregatorV3Interface internal priceFeed;

    Types.Game public game;


    event GameCreated(address tokenAddress);
    event BetPlaced(address indexed user, bool betUp, uint256 amount);
    event GameEnded(uint256 lastPrice,uint256 winnerTokenId);
    event Claimed(address indexed user, uint256 reward);

    constructor(uint256 duration,uint256 minAmount, address _priceFeed, string memory upTokenURI, string memory downTokenURI) {
        require(duration > 0, "Duration must be greater than 0");
        require(minAmount > 0, "Minimum bet amount must be greater than 0");
        //duratrion은 최소 10일 이상이어야함
        //require(duration >= 864000, "Duration must be greater than 10 days");
        priceFeed = AggregatorV3Interface(_priceFeed);
        game = Types.Game({
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
            betEndTime: 0,
            gameEndTime: 0
        });

        emit GameCreated(_priceFeed);
    }

    function bet(bool betUp, uint256 amount) external {
        require(game.isEnded == false, "Game already ended");
        require(game.startTime != 0, "Game does not exist");
        require(amount >= game.minAmount, "Bet amount too low");
        require(usdeToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        usdeToken.approve(sUsdeTokenAddress, amount);
        //sUsdeToken.deposit(amount, address(this));


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


    function endBet() external {
        require(game.isBetEnded == false, "Bet already ended");


        game.isBetEnded = true;
        game.betEndTime = block.timestamp;
    }

    function endGame(uint256 lastPrice) external {
        require(game.startTime != 0, "Game does not exist");
        require(game.isEnded == false, "Game already ended");

        //require(block.timestamp >= betEndTime + 604800, "unstake time not over");
        //sUsdeToken.cooldownShares(sUsdeToken.balanceOf(address(this)));

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

    function unstake() external {
        require(game.isEnded == true, "Game not ended");
        require(block.timestamp >= game.gameEndTime + 604800, "unstake time not over");
        sUsdeToken.unstake(address(this));
        game.prizeAmount = usdeToken.balanceOf(address(this));
    }

    function claim(uint256 amount) external {
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
        usdeToken.transfer(msg.sender, reward);
        emit Claimed(msg.sender, reward);
    }

    function getGame() external view returns (Types.Game memory) {
        return game;
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
