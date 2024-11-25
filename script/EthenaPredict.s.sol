// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/EthenaPredict.sol";
import "../src/EthenaPredictFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";

contract DeployEthenaPredict is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the BetMeme contract


        address usdeTokenAddress = 0xf805ce4F96e0EdD6f0b6cd4be22B34b92373d696; // Replace with your token address

        // Call createGame function
        uint256 duration = 864000; // 10 days
        uint256 minAmount = 1 wei;
        address memeTokenAddress = 0xf805ce4F96e0EdD6f0b6cd4be22B34b92373d696; // Replace with your token address
        EthenaPredictFactory ethenaPredictFactory = new EthenaPredictFactory();
        EthenaPredict ethenaPredict = ethenaPredictFactory.createEthenaPredict(duration, minAmount, memeTokenAddress);
        //BetMeme betMeme = new BetMeme(duration, minAmount, memeTokenAddress);
        console.log("BetMeme deployed to:", address(ethenaPredict));
        console.log("Game created");

        // Approve the BetMeme contract to spend tokens on behalf of the user
        IERC20 token = IERC20(usdeTokenAddress);
        uint256 amountToApprove = 10 wei; // Replace with the amount you want to approve
        token.approve(address(ethenaPredict), amountToApprove);
        ethenaPredict.bet(true, amountToApprove);
        ethenaPredict.endBet();
        console.log("Approved BetMeme contract to spend tokens");

        vm.stopBroadcast();
    }
}
