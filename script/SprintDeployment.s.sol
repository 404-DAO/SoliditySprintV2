pragma solidity <=0.8.19;

import "forge-std/Script.sol";
import {SoliditySprint2023} from "src/SoliditySprint2023.sol";
import {FakeERC20, IUniswapRouter, IUniswapFactory} from "test/SoliditySprintSolutions.t.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SprintDeployment is Script {
    address public constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    address public constant uniswapFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address public constant uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public constant permit2 = 0x000000000022D473030F116dDEE9F6B43aC78BA3;
    uint256 minimumGasPrice = 5000000000; //25 Gwei

    bytes constant constructorInputData = "There can be only one";
    bytes constant firstHashInputData = "Surely you can't be serious. I am serious... and don't call me Shirley.";

    FakeERC20 public token1;
    FakeERC20 public token2;

    SoliditySprint2023 sprint;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(deployerPrivateKey);

        vm.startBroadcast(deployer);

        token1 = new FakeERC20("Esther", "ESTHER");
        token2 = new FakeERC20("Harpua", "HARPUA");

        address pair = IUniswapFactory(uniswapFactory).createPair(address(token1), address(token2));

        token1.approve(uniswapRouter, type(uint256).max);
        token2.approve(uniswapRouter, type(uint256).max);
        ERC20(WETH).approve(permit2, type(uint256).max);

        sprint = new SoliditySprint2023(constructorInputData, WETH, address(token1), address(token2), pair);
        token1.transfer(address(sprint), 50000 ether);

        IUniswapRouter(uniswapRouter).addLiquidity(
            address(token1), address(token2), 50000 ether, 50000 ether, 0, 0, address(sprint), block.timestamp + 1 weeks
        );

        sprint.setFirstHash(firstHashInputData);
        sprint.setMinimumGasPrice(minimumGasPrice);

        //If you also want to start the sprint
        sprint.start();

        sprint.registerTeam("FakeTeam");
        sprint.f0();

        vm.stopBroadcast();

        console.log("Sprint Address: %s", address(sprint));
        console.log("Address token1: %s", address(token1));
        console.log("Address token2: %s", address(token2));
        console.log("UniV2 Pool Address: %s", pair);
    }
}
