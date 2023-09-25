// SPDX-License-Identifier: UNLICENSED
pragma solidity <=0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC4626.sol";
import "@solmate/tokens/ERC1155.sol";

interface ISupportsInterface {
    function supportsInterface(bytes4 interfaceId) external view returns(bool); 
}

contract SoliditySprint2022 is Ownable, ERC1155 {
    bool public live;
    bool public timeExtended = false;

    mapping(address => uint) public scores;
    mapping(address => mapping(uint => bool)) public progress;

    mapping(uint => uint) public solves;
    mapping(bytes32 => bool) public teams;

    uint highestNumber;

    bytes32 public firstHash;
    bytes32 public immutable secondHash;
    uint minimumGasPrice;

    uint public startTime;

    event registration(address indexed teamAddr, string name);

    constructor(bytes memory inputData, address uniV2Pool) {
        secondHash = keccak256(inputData);
    }

    function storeFirstHash(bytes memory inputData) external onlyOwner {
        firstHash = keccak256(inputData);
    }

    function setMinimumGasPrice(uint minGasPrice) external onlyOwner {
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

    modifier isLive {
        require(live);

        if (timeExtended) {
            require(block.timestamp < startTime + 3 hours);
        }
        else {
            require(block.timestamp < startTime + 2 hours);

        }
        _;
    }

    modifier onlyContracts {
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

    function givePoints(uint challengeNum, address team, uint points) internal {
        progress[team][challengeNum] = true;

        if (challengeNum != 23) {
            scores[team] += (points - solves[challengeNum]);
        }
        solves[challengeNum]++;
    }

    //Test of your ability to call functions
    function f0() public isLive {
        uint fNum = 0;
        require(!progress[msg.sender][fNum]);

        givePoints(fNum, msg.sender, 200);
    }

    //Test your ability to read from the state
    function f1(uint num) public payable isLive {
        uint fNum = 1;
        require(!progress[msg.sender][fNum]);

        require(num == highestNumber+1);
        highestNumber++;

        givePoints(fNum, msg.sender, 400);
    }

    //Test knowledge of globally available constants
    function f2(uint val) public isLive {
        uint fNum = 2;
        require(!progress[msg.sender][fNum]);
        
        require(val == 1 weeks + 4 days + 3 hours);

        givePoints(fNum, msg.sender, 600);
    }

    //test knowledge of bitwise-OR and XOR operator (last year I just used XOR)
    function f3(int val) public isLive {
        uint fNum = 3;
        require(!progress[msg.sender][fNum]);

        require(val == (0x123456 | 0x69420) ^ 0x80085);

        givePoints(fNum, msg.sender, 800);
    }

    //Test of understanding ether balance
    function f4(address destAddr) public isLive {
        uint fNum = 4;
        require(!progress[msg.sender][fNum]);

        require(destAddr != address(this) && destAddr != address(0));

        uint bal = destAddr.balance;
        require(bal >= 1 ether);

        givePoints(fNum, msg.sender, 1000);
    }

    //Requires you to check the chain for a previous transaction "set first hash"
    function f5(bytes memory inputData) public isLive {
        uint fNum = 5;
        require(!progress[msg.sender][fNum]);

        require(keccak256(inputData) == firstHash);

        givePoints(fNum, msg.sender, 1200);

    }

    //Just like f5 but now you need to parse input data to the constructor
    function f6(bytes memory inputData) public isLive {
        uint fNum = 6;
        require(!progress[msg.sender][fNum]);

        require(keccak256(inputData) == secondHash);

        givePoints(fNum, msg.sender, 1400);
    }

    //Test of your ability to set a minimum gas price
    //Since gas price is unpredictable there's an admin function to manually lower it if necessary
    //if gas is abnormally high on the day of the sprint
    function f7() public isLive {
        uint fNum = 7;
        require(!progress[msg.sender][fNum]);

        require(tx.gasprice >= minimumGasPrice);

        givePoints(fNum, msg.sender, 1600);

    }


    //function that tests your ability to use supportsInterface
    function f8(address team) external onlyContracts isLive {
        uint fNum = 9;
        require(!progress[team][fNum]);

       try ISupportsInterface(msg.sender).supportsInterface(Ownable.owner.selector) returns (bool supported) {
            require(supported);
       } catch {
           
       }

        givePoints(fNum, team, 2000);

    }

    /*
    I want you to use supportsInterface with the same contract as f8 but I want it to revert
    on a specific input.
    */
    function f9(address team) public onlyContracts isLive {
        uint fNum = 9;
        require(!progress[msg.sender][fNum]);
        require(progress[msg.sender][fNum - 1]);

       try ISupportsInterface(msg.sender).supportsInterface(IERC4626.deposit.selector) returns (bool) {
            revert("You better make like a tree, and get out of here...");
       } catch {
            givePoints(fNum, team, 2000);
       }

    }

    //Test knowledge of ERC1155-Receiver
    function f10(address team) public onlyContracts isLive {
        uint fNum = 10;
        require(!progress[msg.sender][fNum]);

        _mint(msg.sender, block.timestamp, 1, "");

        givePoints(fNum, team, 2200);

    }

    function f11(int num1, int num2) public isLive {
        uint fNum = 11;
        require(!progress[msg.sender][fNum]);

      
        givePoints(fNum, msg.sender, 2400);

    }

    function f12(bytes memory data) public isLive {
        uint fNum = 12;
        require(!progress[msg.sender][fNum]);


        givePoints(fNum, msg.sender, 2600);
    }

    function f13(address team) public isLive {
        uint fNum = 13;
        require(!progress[team][fNum]);

    

        givePoints(fNum, team, 2800);
    }

    function f14(address team) public isLive {
        uint fNum = 14;
        require(!progress[team][fNum]);

    

        givePoints(fNum, team, 3000);
    }


    function f15(address team, address expectedSigner, bytes memory signature) external isLive {
        uint fNum = 15;
        require(!progress[team][fNum]);

        givePoints(fNum, team, 3200);
    }

    function f16(address team) public isLive {
        uint fNum = 16;
        require(!progress[team][fNum]);

    
        givePoints(fNum, team, 3400);
    }

    function f17(address newContract, address team) public isLive {
        uint fNum = 17;
        require(!progress[team][fNum]);

        givePoints(fNum, team, 3600);
    }

    function f18(address team) public isLive {
        uint fNum = 18;
        require(!progress[team][fNum]);


        givePoints(fNum, team, 3800);
    }

    function f19(address team) public isLive {
        uint fNum = 19;
        require(!progress[team][fNum]);

      
        givePoints(fNum, team, 4000);
    }

    function f20(address team, bytes32[] calldata proof, bytes32 leaf) public isLive {
        uint fNum = 20;
        require(!progress[team][fNum]);
     

        givePoints(fNum, team, 4200);

    }

    function f21(address team, uint value) public isLive {
        uint fNum = 21;

        require(!progress[team][fNum]);

    

        givePoints(fNum, team, 4400);
    }
    
    function f22(address team, bytes calldata data, bytes32 hashSlingingSlasher) public isLive {
        uint fNum = 22;
        require(!progress[team][fNum]);

        
        givePoints(fNum, team, 4600);
    }

    function f23(address team, uint value) public isLive {

        uint fNum = 23;
        require(!progress[team][fNum]);

        

        givePoints(fNum, team, 4800);
    }


    function uri(uint256) public pure override returns (string memory) {
        return "";
    }
}