// SPDX-License-Identifier: UNLICENSED
pragma solidity <=0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import {IERC4626, IERC20} from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import "@solmate/tokens/ERC1155.sol";

import {ISignatureTransfer} from "./interfaces/ISignatureTransfer.sol";
import { IEIP712 } from "./interfaces/IEIP712.sol";

import {CREATE3} from "./CREATE3.sol";
import {BytesLib} from "./BytesLib.sol";
import {console2 as console} from "forge-std/console2.sol";

interface ISupportsInterface {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract SoliditySprint2023 is Ownable, ERC1155 {
    using BytesLib for bytes;

    bool public live;
    bool public timeExtended = false;

    address public constant permit2 = 0x000000000022D473030F116dDEE9F6B43aC78BA3;
    address public immutable WETH;

    mapping(address => uint256) public scores;
    mapping(address => mapping(uint256 => bool)) public progress;

    mapping(uint256 => uint256) public solves;
    mapping(bytes32 => bool) public teams;

    uint256 public highestNumber;

    bytes32 public firstHash;
    bytes32 public immutable secondHash;
    uint256 minimumGasPrice;

    IERC20 public immutable token1;
    IERC20 public immutable token2;
    address public immutable uniV2Pair;

    mapping(address _contract => bool) public hasEntered;

    uint256 public startTime;

    event registration(address indexed teamAddr, string name);

    constructor(
        bytes memory inputData,
        address uniV2Pool,
        address _weth,
        address _token1,
        address _token2,
        address pair
    ) {
        secondHash = keccak256(inputData);
        WETH = _weth;
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);

        uniV2Pair = pair;
    }

    function setFirstHash(bytes memory inputData) external onlyOwner {
        firstHash = keccak256(inputData);
    }

    function setMinimumGasPrice(uint256 minGasPrice) external onlyOwner {
        minimumGasPrice = minGasPrice;
    }

    function start() public onlyOwner {
        startTime = block.timestamp;
        live = true;
    }

    function stop() public onlyOwner {
        live = false;
    }

    function extendTime() public onlyOwner {
        timeExtended = true;
    }

    function dripFaucet() external isLive {
        token1.transfer(msg.sender, 100 ether);
    }

    modifier isLive() {
        require(live);

        if (timeExtended) {
            require(block.timestamp < startTime + 3 hours);
        } else {
            require(block.timestamp < startTime + 2 hours);
        }
        _;
    }

    modifier onlyContracts() {
        require(msg.sender != tx.origin);
        require(msg.sender.code.length != 0);
        _;
    }

    function registerTeam(string memory team) public isLive {
        bytes32 teamHash = keccak256(abi.encode(team, msg.sender));

        require(!teams[teamHash], "team already rsegistered");

        teams[teamHash] = true;
        emit registration(msg.sender, team);
    }

    function givePoints(uint256 challengeNum, address team, uint256 points) internal {
        progress[team][challengeNum] = true;

        if (challengeNum != 23) {
            scores[team] += (points - solves[challengeNum]);
        }
        solves[challengeNum]++;
    }

    //Test of your ability to call functions
    function f0() public isLive {
        uint256 fNum = 0;
        require(!progress[msg.sender][fNum]);

        givePoints(fNum, msg.sender, 200);
    }

    //Test your ability to read from the state
    function f1(uint256 num) public payable isLive {
        uint256 fNum = 1;
        require(!progress[msg.sender][fNum]);

        require(num == highestNumber + 1);
        highestNumber++;

        givePoints(fNum, msg.sender, 400);
    }

    //Test knowledge of globally available constants
    function f2(uint256 val) public isLive {
        uint256 fNum = 2;
        require(!progress[msg.sender][fNum]);

        require(val == 1 weeks + 4 days + 3 hours);

        givePoints(fNum, msg.sender, 600);
    }

    //test knowledge of bitwise-OR and XOR operator (last year I just used XOR)
    function f3(int256 val) public isLive {
        uint256 fNum = 3;
        require(!progress[msg.sender][fNum]);

        require(val == (0x123456 | 0x69420) ^ 0x80085);

        givePoints(fNum, msg.sender, 800);
    }

    //Test of understanding ether balance
    function f4(address destAddr) public isLive {
        uint256 fNum = 4;
        require(!progress[msg.sender][fNum]);

        require(
            destAddr != address(this) && destAddr != msg.sender && destAddr != address(0) && destAddr != address(0xdead)
        );

        uint256 bal = destAddr.balance;
        require(bal >= 1 ether);

        givePoints(fNum, msg.sender, 1000);
    }

    //Requires you to check the chain for a previous transaction "set first hash"
    function f5(bytes memory inputData) public isLive {
        uint256 fNum = 5;
        require(!progress[msg.sender][fNum]);

        require(keccak256(inputData) == firstHash);

        givePoints(fNum, msg.sender, 1200);
    }

    //Just like f5 but now you need to parse input data to the constructor
    function f6(bytes memory inputData) public isLive {
        uint256 fNum = 6;
        require(!progress[msg.sender][fNum]);

        require(keccak256(inputData) == secondHash);

        givePoints(fNum, msg.sender, 1400);
    }

    //Test of your ability to set a minimum gas price
    //Since gas price is unpredictable there's an admin function to manually lower it if necessary
    //if gas is abnormally high on the day of the sprint
    function f7() public isLive {
        uint256 fNum = 7;
        require(!progress[msg.sender][fNum]);

        require(tx.gasprice >= minimumGasPrice);

        givePoints(fNum, msg.sender, 1600);
    }

    //function that tests your ability to use supportsInterface
    function f8(address team) external onlyContracts isLive {
        uint256 fNum = 8;
        require(!progress[team][fNum]);

        try ISupportsInterface(msg.sender).supportsInterface(type(Ownable).interfaceId) returns (bool supported) {
            require(supported);
        } catch {}

        givePoints(fNum, team, 2000);
    }

    /*
    I want you to use supportsInterface with the same contract as f8 but I want it to revert
    on a specific input and with a specific return message.
    */
    function f9(address team) public onlyContracts isLive {
        uint256 fNum = 9;
        require(!progress[msg.sender][fNum]);
        require(progress[msg.sender][fNum - 1]);

        try ISupportsInterface(msg.sender).supportsInterface(type(IERC4626).interfaceId) returns (bool) {
            revert("Why don't you make like a tree, and get out of here...");
        } catch Error(string memory reason) {
            string memory expected = "Set the gear shift for the high gear of your soul...";

            require(
                keccak256(abi.encode(reason)) == keccak256(abi.encode(expected)),
                "Someone didn't take care of their shoes..."
            );
            givePoints(fNum, team, 2000);
        }
    }

    function f10(uint256 val1, uint256 val2) public isLive {
        uint256 fNum = 10;
        require(!progress[msg.sender][fNum]);

        require(~val1 == val2);

        givePoints(fNum, msg.sender, 2200);
    }

    function f11(address team) public onlyContracts isLive {
        uint256 fNum = 11;
        require(!progress[msg.sender][fNum]);

        _mint(msg.sender, block.timestamp, 1, "");

        givePoints(fNum, msg.sender, 2400);
    }

    //Test of ABI encoding/decoding
    function f12(bytes memory data) public isLive {
        uint256 fNum = 12;
        require(!progress[msg.sender][fNum]);

        (uint256 val1, bytes32 _hash, address _addr) = abi.decode(data, (uint256, bytes32, address));

        require(val1 == type(uint256).max);
        require(_hash == keccak256("The dark side is a path to abilities some consider...unnatural"));
        require(_addr == address(this));

        givePoints(fNum, msg.sender, 2600);
    }

    function f13(address team, bytes32 signature) public isLive {
        uint256 fNum = 13;
        require(!progress[team][fNum]);

        givePoints(fNum, team, 2800);
    }

    //Give me a contract before and aft. er it has self-destructed
    function f14(address _destination, address team) public isLive {
        uint256 fNum = 14;
        require(!progress[team][fNum]);

        if (!hasEntered[_destination]) {
            //Require contract exist
            require(msg.sender.code.length != 0);
            hasEntered[msg.sender] = true;
        } else {
            //Contract must be selfdestructed by this point
            //TODO: Add a check that the address hasn't been used already
            require(_destination.code.length == 0);
            givePoints(fNum, team, 3000);
        }
    }

    function f15(address team, address expectedSigner, bytes memory signature) external isLive {
        uint256 fNum = 15;
        require(!progress[team][fNum]);

        givePoints(fNum, team, 3200);
    }

    function f16(address team) public isLive {
        uint256 fNum = 16;
        require(!progress[team][fNum]);

        require(token2.balanceOf(msg.sender) != 0, "Looks like someone wrote a check their butt can't cash");

        givePoints(fNum, team, 3400);
    }

    //Test using Permit2. They must first approve permit2 to transfer WETH then provide a signature to do the actual transfer
    function f17(address team, bytes memory signature) public isLive {
        uint256 fNum = 17;
        require(!progress[team][fNum]);

        ISignatureTransfer(permit2).permitTransferFrom(
            ISignatureTransfer.PermitTransferFrom({
                permitted: ISignatureTransfer.TokenPermissions({token: WETH, amount: type(uint256).max}),
                nonce: 0,
                deadline: type(uint256).max
            }),
            ISignatureTransfer.SignatureTransferDetails({to: address(this), requestedAmount: 1000 wei}),
            msg.sender,
            signature
        );

        givePoints(fNum, team, 3600);
    }

    //Challenge that tests your ability to deploy using create3 library included
    function f18(address team) public isLive {
        uint256 fNum = 18;
        require(!progress[team][fNum]);

        address deployed = CREATE3.getDeployed(msg.sender, CREATE3.deploymentSalt);
        require(deployed.code.length != 0);

        givePoints(fNum, team, 3800);
    }

    //https://etherscan.io/find-similar-contracts
    function f19(address team, address contract1, address contract2) public isLive {
        uint256 fNum = 19;
        require(!progress[team][fNum]);

        assembly {
            //if the two addresses are the same revert
            if eq(xor(contract1, contract2), 0x00) { revert(0, 0) }

            //if their codehash is different revert
            if gt(xor(extcodehash(contract1), extcodehash(contract2)), 0x00) { revert(0, 0) }
        }

        givePoints(fNum, team, 4000);
    }

    function f20(address team, address addr) public isLive {
        uint256 fNum = 20;
        require(!progress[team][fNum]);

        assembly {
            //require contract to exist
            if eq(extcodesize(addr), 0x00) { revert(0, 0) }

            // set the size of the code to copy
            let size := 0x5

            // Get the next free memory slot from the memPointer
            let code := mload(0x40)
            let storageLocation := add(code, 0x20)

            //Allocate memory for the code by moving the free memory pointer to the end
            mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))

            // store length of our input in the previous memory slot
            mstore(code, size)

            // actually retrieve the code starting with the first allocated memory slot
            extcodecopy(addr, add(code, 0x20), 0, size)

            //You need to pad the code to 32 bytes because memory slots are also 32-bytes long
            let firstPrefix := 0x6080604052000000000000000000000000000000000000000000000000000000
            let secondPrefix := 0x6060604052000000000000000000000000000000000000000000000000000000

            //If the bytecode is prefixed with the first or second prefix revert
            //An ERC1167 minProxy or a huff contract or something else would pass this test
            if or(eq(mload(storageLocation), firstPrefix), eq(mload(storageLocation), secondPrefix)) { revert(0, 0) }
        }
        givePoints(fNum, team, 4200);
    }

    //TODO: Consider rewriting it to be more like f20 using raw assembly instead of using BytesLib
    function f21(address team, address _contract) public isLive {
        uint256 fNum = 21;
        require(!progress[team][fNum]);

        bytes memory magicBytes = hex"a165767970657283000309000b";

        bytes memory bytecode = _contract.code.slice(_contract.code.length - 13, 13);

        require(keccak256(bytecode) == keccak256(magicBytes), "keep trying");

        givePoints(fNum, team, 4400);
    }

    function uri(uint256) public pure override returns (string memory) {
        return "";
    }
}
