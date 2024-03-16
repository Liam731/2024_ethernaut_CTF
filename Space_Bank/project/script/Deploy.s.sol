// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-ctf/CTFDeployment.sol";
import {Script, console2} from "forge-std/Script.sol";
import "src/Challenge.sol";
import "src/SpaceBank.sol";
import {Attacker} from "src/Attacker.sol";
import {Create2ContractAddress} from "src/Create2ContractAddress.sol";

contract Deploy is Script {
    // function deploy(address system, address) internal override returns (address challenge) {
    //     vm.startBroadcast(system);

    //     SpaceToken token = new SpaceToken();

    //     SpaceBank spacebank = new SpaceBank(address(token));

    //     token.mint(address(spacebank), 1000);

    //     challenge = address(new Challenge(spacebank));

    //     vm.stopBroadcast();
    // }

    function run() public returns (address challenge) {
        vm.startBroadcast(vm.envUint("DEV_PRIVATE_KEY"));

        SpaceToken token = new SpaceToken();

        SpaceBank spacebank = new SpaceBank(address(token));



        // spacebank.withdraw(500);
        // spacebank.deposit(100, new bytes(0x01));

        challenge = address(new Challenge(spacebank));
        
        Attacker attacker = new Attacker(challenge, address(spacebank), address(token));

        token.mint(address(spacebank), 1000);
        token.mint(address(attacker), 10000);

        bytes32 MagicNumber = bytes32(block.number);
        bytes memory data = abi.encodeWithSignature("address(this).call{value:0.001 ether}("")");
        address newContractAddress;
        assembly {
            newContractAddress := create2(0, add(data, 0x20), mload(data), MagicNumber)
        }
        console2.log(newContractAddress);
        // (bool success,) = address(newContractAddress).call{value:0.001 ether}("");
        // require(success, "Call failed");
        attacker.attack_1();
        attacker.attack_1();
  
        bool result = Challenge(challenge).isSolved();
        console2.log("bank token balance = ",token.balanceOf(address(spacebank)));
        console2.log("bank balance = ");
        console2.log("bank balance = ",token.balanceOf(address(spacebank)));
        console2.log(result);
        
        vm.stopBroadcast();
    }
}
