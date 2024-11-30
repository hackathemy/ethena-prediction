// src/EthenaPredictFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./EthenaPredict.sol";
import "./Types.sol";


event CreateEthenaPredict(uint256 duration, uint256 minAmount, address tokenAddress, string  upTokenURI, string  downTokenURI);

contract EthenaPredictFactory {

    mapping(uint256 => address) public games;
    uint256 public gameCounter;


    function createEthenaPredict(uint256 duration, uint256 minAmount, address tokenAddress, string memory upTokenURI, string memory downTokenURI) external returns (EthenaPredict) {
        EthenaPredict ethenaPredict = new EthenaPredict(duration, minAmount, tokenAddress, upTokenURI, downTokenURI);
        games[gameCounter] = address(ethenaPredict);
        gameCounter++;

        emit CreateEthenaPredict(duration, minAmount, tokenAddress, upTokenURI, downTokenURI);

        return ethenaPredict;
    }
    function getGameList() external view returns (Types.Game[] memory) {
        Types.Game[] memory gameList = new Types.Game[](gameCounter);
        for (uint256 i = 0; i < gameCounter; i++) {
            gameList[i] = EthenaPredict(games[i]).getGame();
        }
        return gameList;
    }

    function getEndedGameList() external view returns (Types.Game[] memory) {
        Types.Game[] memory gameList = new Types.Game[](gameCounter);
        uint256 endedGameCount = 0;
        for (uint256 i = 0; i < gameCounter; i++) {
            Types.Game memory gmae = EthenaPredict(games[i]).getGame();
            if (gmae.isEnded) {
                gameList[endedGameCount] = gmae;
                endedGameCount++;
            }
        }
        return gameList;
    }

    function getActiveGameList() external view returns (Types.Game[] memory) {
        Types.Game[] memory gameList = new Types.Game[](gameCounter);
        uint256 activeGameCount = 0;
        for (uint256 i = 0; i < gameCounter; i++) {
            Types.Game memory gmae = EthenaPredict(games[i]).getGame();
            if (!gmae.isEnded) {
                gameList[activeGameCount] = gmae;
                activeGameCount++;
            }
        }
        return gameList;
    }

    function getGame(address gameAddress) external view returns (Types.Game memory) {
        return EthenaPredict(gameAddress).getGame();
    }

}
