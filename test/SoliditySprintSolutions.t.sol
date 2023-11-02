pragma solidity <= 0.8.19;

import {Test} from "forge-std/Test.sol";
import {SoliditySprint2023, CREATE3} from "src/SoliditySprint2023.sol";
import {console2 as console} from "forge-std/console2.sol";
import {IERC4626, IERC20} from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IEIP712} from "src/interfaces/IEIP712.sol";
import {ISignatureTransfer} from "src/interfaces/ISignatureTransfer.sol";

interface IUniswapFactory {
    function createPair(address token1, address token2) external returns (address);
}

interface IUniswapRouter {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

contract FakeERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 100000 * 10 ** decimals());
    }
}

contract SoliditySprintSolutions is Test {
    SoliditySprint2023 sprint;

    bytes constant constructorInputData = "There can be only one";
    bytes constant firstHashInputData = "Surely you can't be serious. I am serious... and don't call me Shirley.";
    uint256 minimumGasPrice = 25000000000; //25 Gwei

    address public constant beaconChainDepositContract = 0x00000000219ab540356cBB839Cbe05303d7705Fa;
    address public constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    address public constant uniswapFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address public constant uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public constant permit2 = 0x000000000022D473030F116dDEE9F6B43aC78BA3;

    FakeERC20 public token1;
    FakeERC20 public token2;

    constructor() {
        vm.createSelectFork("goerli");

        token1 = new FakeERC20("Esther", "ESTHER");
        token2 = new FakeERC20("Harpua", "HARPUA");

        vm.label(address(token1), "token1");
        vm.label(address(token2), "token2");

        address pair = IUniswapFactory(uniswapFactory).createPair(address(token1), address(token2));
        token1.approve(uniswapRouter, type(uint256).max);
        token2.approve(uniswapRouter, type(uint256).max);
        ERC20(WETH).approve(permit2, type(uint256).max);

        sprint = new SoliditySprint2023(constructorInputData, address(0), WETH, address(token1), address(token2), pair);

        vm.txGasPrice(minimumGasPrice + 1);

        vm.label(pair, "V2Pair");
        vm.label(address(sprint), "Sprint");
        vm.label(address(uniswapRouter), "UniRouter");
        vm.label(address(uniswapFactory), "UniFactory");

        token1.transfer(address(sprint), 50000 ether);

        IUniswapRouter(uniswapRouter).addLiquidity(
            address(token1), address(token2), 50000 ether, 50000 ether, 0, 0, address(sprint), block.timestamp + 1 weeks
        );

        sprint.setFirstHash(firstHashInputData);

        sprint.start();

        sprint.registerTeam("Nexus Series 6 Replicants");
        deal(address(this), 1000 ether);
    }

    modifier pointsIncreased() {
        uint256 prePoints = sprint.scores(address(this));
        _;
        uint256 afterPoints = sprint.scores(address(this));
        require(afterPoints > prePoints, "points didn't increase");
    }

    function setUp() public {}

    function testf0() public pointsIncreased {
        sprint.f0();
    }

    function testf1() public pointsIncreased {
        uint256 highestNumber = sprint.highestNumber();
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
        sprint.setMinimumGasPrice(minimumGasPrice);
        sprint.f7();
    }

    function testf8() public pointsIncreased {
        uint256 first = 42069;
        uint256 second = ~first;

        sprint.f8(first, second);
    }

    function testf9() public pointsIncreased {
        sprint.f9(address(this));
    }

    function testf10() public pointsIncreased {
        sprint.f9(address(this));
        sprint.f10(address(this));
    }

    function testf11() public pointsIncreased {
        sprint.f11(address(this));
    }

    function testf12() public pointsIncreased {
        bytes memory concat = abi.encode(
            type(uint256).max,
            keccak256("The dark side is a path to abilities some consider...unnatural"),
            address(sprint)
        );

        sprint.f12(concat);
    }

    function testf13() public pointsIncreased {
        uint256 d = 16;
        for (uint256 x = 0; x < type(uint256).max; x++) {
            uint256 _hash = uint256(keccak256(abi.encode(x, address(this))));
            uint256 mask = 1 << d;
            if (_hash % mask == 0) {
                sprint.f13(address(this), x);
                break;
            }
        }
    }

    function testf14() public pointsIncreased {
        selfDestructable sd = new selfDestructable(sprint);
        sd.invoke();

        destroyAccount(address(sd), address(sd));

        assertEq(address(sd).code.length, 0, "self destructable contract was not destroyed");

        sprint.f14(address(sd), address(this));
    }

    function testf15() public pointsIncreased {
        new tempAttacker(address(this), address(sprint));
    }

    function testf16() public pointsIncreased {
        sprint.dripFaucet();

        uint256 balance = token1.balanceOf(address(this));
        require(balance != 0, "no tokens acquired from faucet");
        address[] memory route = new address[](2);
        route[0] = address(token1);
        route[1] = address(token2);

        IUniswapRouter(uniswapRouter).swapExactTokensForTokens(
            100 ether, 1, route, address(this), block.timestamp + 1 weeks
        );

        sprint.f16(address(this));
    }

    //TODO: Move this up in terms of points cause its pretty hard
    //https://etherscan.deth.net/address/0x000000000022D473030F116dDEE9F6B43aC78BA3
    //https://github.com/Uniswap/permit2/blob/main/test/SignatureTransfer.t.sol
    function testf17() public pointsIncreased {
        (bool success,) = address(WETH).call{value: 1 ether}("");
        require(success);
        require(ERC20(WETH).balanceOf(address(this)) != 0, "NO WETH AVAILABLE");

        ISignatureTransfer.PermitTransferFrom memory permit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: WETH, amount: type(uint256).max}),
            nonce: 0,
            deadline: block.timestamp + 100
        });

        bytes32 _TOKEN_PERMISSIONS_TYPEHASH = keccak256("TokenPermissions(address token,uint256 amount)");
        bytes32 _PERMIT_TRANSFER_FROM_TYPEHASH = keccak256(
            "PermitTransferFrom(TokenPermissions permitted,address spender,uint256 nonce,uint256 deadline)TokenPermissions(address token,uint256 amount)"
        );
        bytes32 DOMAIN_SEPARATOR = IEIP712(permit2).DOMAIN_SEPARATOR();

        bytes32 tokenPermissions = keccak256(abi.encode(_TOKEN_PERMISSIONS_TYPEHASH, permit.permitted));
        bytes32 msgHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        _PERMIT_TRANSFER_FROM_TYPEHASH, tokenPermissions, address(this), permit.nonce, permit.deadline
                    )
                )
            )
        );

        //Sign the permit info
        uint256 PRIVATE_KEY = vm.envUint("PRIVATE_KEY"); //Useful for EIP-712 Testing
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(PRIVATE_KEY, msgHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        sprint.f17(address(this), signature);
    }

    function testf18() public pointsIncreased {
        bytes memory creationCode = abi.encodePacked(type(selfDestructable).creationCode, abi.encode(address(sprint)));

        CREATE3.deploy(CREATE3.deploymentSalt, creationCode, 0);

        sprint.f18(address(this));
    }

    function testf19() public pointsIncreased {
        sprint.f19(
            address(this), 0x18F3C12cbd093B188B778C629E979c9160473CaB, 0x01C77F5b183D04fDC4f13F5Cf9fdBBf24AB619e8
        );
    }

    function testf20() public pointsIncreased {
        sprint.f20(address(this), 0xF7D34A43D1dcE8CA44f38acd1E83f1911508dfc3);
    }

    function testf21() public pointsIncreased {
        sprint.f21(address(this), 0xF7D34A43D1dcE8CA44f38acd1E83f1911508dfc3);
    }

    fallback() external {}

    function supportsInterface(bytes4 interfaceId) external pure returns (bool supported) {
        // console2.logBytes4(type(IERC20).interfaceId);
        if (interfaceId == type(Ownable).interfaceId) {
            return true;
        } else if (interfaceId == type(IERC4626).interfaceId) {
            revert("Set the gear shift for the high gear of your soul...");
        }
    }

    function onERC1155Received(address, address, uint256, uint256, bytes calldata) external pure returns (bytes4) {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function isValidSignature(bytes32, bytes calldata) external pure returns (bytes4) {
        return 0x1626ba7e;
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

contract tempAttacker {
    address public immutable teamAddr;
    address public immutable currSprint;

    constructor(address _teamAddr, address _currSprint) {
        teamAddr = _teamAddr;
        currSprint = _currSprint;
        SoliditySprint2023(currSprint).f15(teamAddr);
    }

    fallback() external {
        SoliditySprint2023(currSprint).f15(teamAddr);
    }
}
