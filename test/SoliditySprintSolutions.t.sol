pragma solidity >= 0.8.5;

import { Test } from "forge-std/Test.sol";
import { SoliditySprint2023, CREATE3 } from "src/SoliditySprint2023.sol";
import { console2 as console } from "forge-std/console2.sol";
import { IERC4626, IERC20 } from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC1155Receiver } from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";

contract SoliditySprintSolutions is Test {

    SoliditySprint2023 sprint;

    bytes constant constructorInputData = "There can be only one";
    bytes constant firstHashInputData = "Surely you can't be serious. I am serious... and don't call me Shirley.";
    uint minimumGasPrice = 25000000000; //25 Gwei

    address public constant beaconChainDepositContract = 0x00000000219ab540356cBB839Cbe05303d7705Fa;

    constructor() {
        vm.createSelectFork("mainnet");

        address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        sprint = new SoliditySprint2023(constructorInputData, address(0));

        sprint.setFirstHash(firstHashInputData);
        sprint.setMinimumGasPrice(minimumGasPrice);

        sprint.start();

        sprint.registerTeam("Nexus Series 6 Replicants");
    }

    modifier pointsIncreased {
        uint prePoints = sprint.scores(address(this));
        _;
        uint afterPoints = sprint.scores(address(this));
        require(afterPoints > prePoints, "points didn't increase");
    }

    function setUp() public {
    }

    function testf0() public pointsIncreased {
        sprint.f0();
    }
    
    function testf1() public pointsIncreased {
        uint highestNumber = sprint.highestNumber();
        sprint.f1(++highestNumber);
    }
    
    function testf2() public pointsIncreased {
        sprint.f2(1 weeks + 4 days + 3 hours);
    }

    function testf3() public pointsIncreased {
        sprint.f3((0x123456 | 0x69420) ^ 0x80085);
    }

    function testf4() public pointsIncreased {
        sprint.f4(beaconChainDepositContract);
    }

    function testf5() public pointsIncreased {
        sprint.f5(firstHashInputData);
    }

    function testf6() public pointsIncreased {
        sprint.f6(constructorInputData);
    }

    function testf7() public pointsIncreased {
        sprint.f7();
    }

    function testf8() public pointsIncreased {
        sprint.f8(address(this));
    }

    function testf9() public pointsIncreased {
        sprint.f8(address(this));

        sprint.f9(address(this));
    }

    function testf10() public pointsIncreased {
        sprint.f10(address(this));
    }

    function testf11() public pointsIncreased {
        uint first = 42069;
        uint second = ~first;

        sprint.f11(first, second);
    }

    function testf12() public pointsIncreased {
        bytes memory concat = abi.encode(type(uint).max, keccak256("The dark side is a path to abilities some consider...unnatural"), address(sprint));

        sprint.f12(concat);
    }

    function testf13() public pointsIncreased {
    }

    function testf14() public pointsIncreased {
        selfDestructable sd = new selfDestructable(sprint);
        sd.invoke();

        destroyAccount(address(sd), address(sd));

        assertEq(address(sd).code.length, 0, "self destructable contract was not destroyed");

        sprint.f14(address(sd), address(this));
    }

    function testf15() public pointsIncreased {
      
    }

    function testf16() public pointsIncreased {
    }

    function testf17() public pointsIncreased {
       
    }


    function testf18() public pointsIncreased {
        bytes memory creationCode = abi.encodePacked(
            type(selfDestructable).creationCode,
            abi.encode(address(sprint)));

        address deployed = CREATE3.deploy(CREATE3.deploymentSalt, creationCode, 0);

        sprint.f18(address(this));

    }

    function testf19() public pointsIncreased {
    }

    function testf20() public pointsIncreased {
    }

    function testf21() public pointsIncreased {

    }

    function testf22() public pointsIncreased {
  
    }

    function testf23() public pointsIncreased {


    }

    fallback() external {
        
    }

    function supportsInterface(bytes4 interfaceId) external returns (bool) {
        // console2.logBytes4(type(IERC20).interfaceId);
        if (interfaceId == type(Ownable).interfaceId) {
            return true;
        }

        else if (interfaceId == type(IERC4626).interfaceId) {
            revert("do something");
        }
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }
}

contract selfDestructable {
    SoliditySprint2023 sprint;
    address immutable owner;

    constructor(SoliditySprint2023 _sprint) {
        sprint = _sprint;
        owner = msg.sender;
    }

    function invoke() public {
        require(msg.sender == owner);
        sprint.f14(address(this), owner);
        selfdestruct(payable(address(this)));
    }
}

