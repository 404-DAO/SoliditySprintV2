# Intro

Below are the solutions for the Solidity Spring and my explanations. I'm busy and kinda lazy so it took me a while to finally write these out. You can find an example contract that solves every challenge in `SoliditySprintSolutions.t.sol`

The goal of the solidity sprint is to acquire points by solving the challenges. Solving the challenge means executing the function without it reverting. Some of these require you to provide a specific input, and some require you to execute it as a contract. We're gonna walk through how to solve every one.

## Challenge 0

```solidity
    function f0() public isLive {
        uint256 fNum = 0;
        require(!progress[msg.sender][fNum]);

        givePoints(fNum, msg.sender, 200);
    }
```

First challenge is meant to get your feet wet with interacting with smart contracts. All you need to do is call the function f0, and you get 200 points. You can do this however you want, but if you're new to solidity, we recommend using Etherscan or Remix.

## Challenge 1

```solidity
function f1(uint256 num) public payable isLive {
        uint256 fNum = 1;
        require(!progress[msg.sender][fNum]);

        require(num == highestNumber + 1);
        highestNumber++;

        givePoints(fNum, msg.sender, 400);
    }
```

This next challenge requires you to provide an input of some kind. A single uint that fills the requirement of `num == higherNumber + 1`. This means we need to find out what the current highestNumber is. You can find the highestNumber by calling the `highestNumber` function on etherScan. Once you have the highest number, you can add one and call the function with the correct input and get 400 points.

## Challenge 2

```solidity
    function f2(uint256 val) public isLive {
        uint256 fNum = 2;
        require(!progress[msg.sender][fNum]);

        require(val == 1 weeks + 4 days + 3 hours);

        givePoints(fNum, msg.sender, 600);
    }
```

This next function asks you to learn something about how time is calculated in solidity, specifically the notion of time as a constant. In solidity to track the passage of time, constants are pre-defined in solidity for weeks, days, hours, minutes, and seconds. But all of these are just abstractions to represent a specific number of seconds. You can find these constants in the solidity documentation. Once you know the values of these constants, you can add them together and call the function with the correct input to get 600 points.

`1 weeks = 604800 seconds`

`1 days = 86400 seconds`

`1 hours = 3600 seconds`

`1 weeks + 4 days + 3 hours = 604800 + 345600 + 10800 = 964200`

## Challenge 3

```solidity
    function f3(int256 val) public isLive {
        uint256 fNum = 3;
        require(!progress[msg.sender][fNum]);

        require(val == (0x123456 | 0x69420) ^ 0x80085);

        givePoints(fNum, msg.sender, 800);
    }
```

This next function asks you to learn something about bitwise operators. Specifically, the `|` operator, the `^` operator, and the `&` operator. The `|` operator is the bitwise OR operator, the `^` operator is the bitwise XOR operator, and the `&` operator is the bitwise AND operator. You can find the values of these operators by using a bitwise calculator or by using the `web3.utils.toBN` function in web3. Once you have the correct value, you can call the function with the correct input to get 800 points.

`0x123456 | 0x69420 = 0x7B776`

`0x7B776 ^ 0x80085 = 0xFB7F3`

## Challenge 4

```solidity
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
```

This next function asks you to learn something about the `address` type in solidity. Specifically, the `balance` property of the `address` type. You can find the balance of an address by looking at an address on etherscan. The challenge asks you to provide an address that is NOT the address of the challenge `(address(this))`, not yourself `(msg.sender)`, not the zero address `(address(0))`, and not the dead address `address(0xdead)`. These are common targets and the challenge wanted you to explore the blockchain to find an address that meets the requirements. Once you have the correct address, you can call the function with the correct input to get 1000 points.

## Challenge 5

```solidity
    function f5(bytes memory inputData) public isLive {
        uint256 fNum = 5;
        require(!progress[msg.sender][fNum]);

        require(keccak256(inputData) == firstHash);

        givePoints(fNum, msg.sender, 1200);
    }
```

This next function asks you to learn something about the `keccak256` function in solidity. Specifically, the `keccak256` function is a hashing function that takes in a `bytes` type and returns a `bytes32` type. The value of the `firstHash` but expects you to try and figure out what the value of `firstHash` is. While you can try to brute force this solution, we wanted you to realize that this is not a good strategy because the search space is simply too large. Instead, you need to get creative. A big part of developing in Solidity is understanding the transparent nature of the blockchain history. You can find the value of `firstHash` by looking at the transaction history of the contract.

Earlier in the contract on line 70, there's a function

```solidity
    function setFirstHash(bytes memory inputData) external onlyOwner {
        firstHash = keccak256(inputData);
    }
```

This function sets the hash value with the original input data. The challenge wanted you to realize that you can find the value of `firstHash` by looking at the transaction history of the contract, and then call the function with the same input to get 1200 points.

## Challenge 6

```solidity
    function f6(bytes memory inputData) public isLive {
        uint256 fNum = 6;
        require(!progress[msg.sender][fNum]);

        require(keccak256(inputData) == secondHash);

        givePoints(fNum, msg.sender, 1400);
    }
```

This next function is similar to the last one, but the value of `secondHash` is different. If you look at the tx history you won't see a unique tx where secondHash is set. However, it has to be set somewhere in order for the challenge to work. If you look at the constructor of the contract, you'll see that `secondHash` is set in the first parameter. This means that you can find the value of `secondHash` by looking at the contract creation transaction. If you parse through the input data to the contract creation transaction, you'll find the value of `secondHash`. Input data is formatted uniquely when supplied to a constructor, and so you'll need to visit the solidity and ethereum documentation to understand how to parse the input data.

Once you have the correct value, you can call the function with the correct input to get 1400 points.

There's also a second way to solve this, and many other challenges though. Every time someone calls a function to solve a challenge, the input that they used to solve it is public, by looking at the transaction history. Many of the challenges don't require a different input depending on who is solving it. This means that you can look at the transaction history of the contract and find the input that someone else used to solve the challenge, and then just copy that input exactly to solve the challenge yourself. The idea is to work smarter, not harder.

## Challenge 7

```solidity
    function f7() public isLive {
        uint256 fNum = 7;
        require(!progress[msg.sender][fNum]);

        require(tx.gasprice >= minimumGasPrice);

        givePoints(fNum, msg.sender, 1600);
    }
```

This function is less difficult, and asks you to form a transaction with a specific gas price. You can find the current gas price by looking at the transaction history of the contract, where we called the function `setMinimumGasPrice`. You can configure the gas price in your wallet when submitting the transaction. We wanted you to learn about configuring your payment options when submitting a transaction. Once you have the correct gas price, you can call the function with the correct input to get 1600 points.

## Challenge 8

```solidity
    function f8(uint256 val1, uint256 val2) public isLive {
        uint256 fNum = 10;
        require(!progress[msg.sender][fNum]);

        require(~val1 == val2);

        givePoints(fNum, msg.sender, 1800);
    }
```

This function asks you to learn something about the `~` operator in solidity. The `~` operator is the bitwise NOT operator. This means that it takes the binary representation of a number and flips all the bits. So if you have a number `0b1010`, the `~` operator would return `0b0101`. However, the we don't want you to actually do the bitwise NOT operation, we want you to realize that you can just use the `~` operator to find the value of `val2` by using the value of `val1`. Using a command-line interpreter like `chisel` or an online tool, you can find the value of `val2` by using the `~` operator the easy way.

Once you have the correct value, you can call the function with the correct input to get 1800 points.

## Challenge 9

```solidity
    function f9(address team) external onlyContracts isLive {
        uint256 fNum = 8;
        require(!progress[team][fNum]);

        try ISupportsInterface(msg.sender).supportsInterface(type(Ownable).interfaceId) returns (bool supported) {
            require(supported);
        } catch {}

        givePoints(fNum, team, 2000);
    }
```

This challenge is where things get a little tougher. There's a new modifier, `onlyContracts`

```solidity
    modifier onlyContracts() {
        require(msg.sender != tx.origin);
        require(msg.sender.code.length != 0);
        _;
    }
```

Without going into too much length, the idea is that when the modifier is active, the function can only be called by ANOTHER smart contract. So from this point on, you're gonna have to deploy your own smart contracts to solve the challenges.

Let's look at what this try-catch loop does.

```solidity
    try ISupportsInterface(msg.sender).supportsInterface(type(Ownable).interfaceId) returns (bool supported);
```

Looking at the files in the contract, you'll see that `ISupportsInterface` is an interface that has a function `supportsInterface` that takes in a `bytes4` type and returns a `bool`. So at first glance it seems like the challenge wants you to implement this function and return true. However, the challenge is a little more complex than that.

`type(Ownable).interfaceId` is a new feature in solidity that allows you to get the interface id of a contract. The interface id is a unique identifier for a contract that is derived from the contract's function signatures. An interfaceId is a 4 byte identifier that is derived from the unique collection of functions implemented by an interface. This means that the `type(Ownable).interfaceId` is a unique identifier for the `Ownable` contract that this contract is importing from OpenZeppelin libraries. The contract wants you to return true if the contract that is calling the function supports the `Ownable` interface. This doesn't mean that you actually need to implement the `Ownable` interface, but that you need to return true if the input value is the interface id of the `Ownable` contract. In the real world, this would be a bad practice, but the challenge is meant to teach you about the `type` function and the `interfaceId` property. This is because determining whether a function actually implements an interface is entirely up to the developer and voluntary, and the `supportsInterface` function is a way to check if a contract implements a specific interface. You would not want to proclaim to the world that your contract implements an interface that it does not, because it would be a lie and can cause lots of unexpected behavior.

However, you should also notice that if the `supportsInterface` function does not exist, the `try` block will fail and the `catch` block will execute. This means that you can just call the function with a contract that does not implement the `supportsInterface` function and it will execute correctly anyways. This might seem like a design flaw but the next challenge will show you why it's not.

## Challenge 10

```solidity
    function f10(address team) public onlyContracts isLive {
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
            givePoints(fNum, team, 2200);
        }
    }
```

This challenge looks pretty similar to the last one, but it's got some additional intricacy. In the beginning notice how it says `require(progress[msg.sender][fNum - 1]);`. This means that you can only call this function if you've already called the previous function.

The `try` block is also different. It's checking if the contract that is calling the function supports the `IERC4626` interface. If it does, it will revert with a specific error message. If it doesn't, it will revert with a different error message. However, this time, the `givePoints` function is in the catch block. We want that to execute. This means that you need to call the function with a contract that does not implement the `IERC4626` interface. This is a little more difficult than the last challenge, because you can't just call the function with a contract that doesn't implement the `supportsInterface` function. You need to implement the function and then it checks the value of the error returned. Specifically it's gonna check and see if the error returned matches the error that it's expecting. The way to accomplish this is to build a branch into the `supportsInterface` method that reverts with the error message that the challenge is expecting, but ONLY if the input value is the interface id of the `IERC4626` contract.

The trick of this challenge is realizing that to solve this challenge, you need to implement `supportsInterface`. However, if you implement the function, then you also need to implement it in a way that also satisfies the previous challenge. So the way to solve the challenge is to implement the function such that if the input `interfaceId` is equal to `type(Ownable).interfaceId`, then return true. If the input `interfaceId` is equal to `type(IERC4626).interfaceId`, then revert with the error message that the challenge is expecting. This is a little tricky, but it's meant to teach you about the `supportsInterface` function and the `interfaceId` property.

## Challenge 11

```solidity
    function f11(address team) public onlyContracts isLive {
        uint256 fNum = 11;
        require(!progress[msg.sender][fNum]);

        _mint(msg.sender, block.timestamp, 1, "");

        givePoints(fNum, team, 2400);
    }
```

This challenge is a fun one because it asks you to do some reading on common ERC-standards. First, it doesn't ask you for any inputs. Only for the address to award points to. But it does specify `onlyContracts`. The challenge calls the function `_mint`. However, if you look at the contracts, we don't define that function anywhere, it's inherited. If you go back to the contract start you'll notice that the sprint contract inherits from two other contracts `contract SoliditySprint2023 is Ownable, ERC1155`.

The `ERC1155` contract is a standard for fungible and non-fungible tokens. The `_mint` function is a function that is defined in the ERC1155 standard. The `_mint` function is a function that is used to mint new tokens. The `_mint` function takes in 4 parameters, the address to mint the tokens to, the id of the token to mint, the amount of tokens to mint, and the data to associate with the minting. You don't need to worry too much about how the token-standard works. But if you tried to just call the function with a contract, you would realize that the transaction would fail. This is because of a lesser-known quirk of how the 1155-standard operates. Under the ERC-standard, if the recipient of a newly minted 1155-token is a contract, then the token needs to attempt to call the function

```solidity
function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC1155TokenReceiver.onERC1155Received.selector;
    }
```

on the receiver. If the recipient does not implement the `onERC1155Received` function, then the transaction will fail. This is a security feature of the ERC1155 standard that is used to prevent the accidental minting of tokens to contracts that are not prepared to receive them. The challenge wanted you to read through the debug logs of the tx and the token-standard to identify how to be compliant with the ERC1155 standard. The function is easy to implement, and only returns a constant, but identifying that you need to implement it is the challenge. The challenge is marked `onlyContracts` becuase if we allowed you to interact with the function without a contract, then you would not be required to implement the `onERC1155Received` function, and the challenge would be too easy.

This is a little tricky, but it's meant to teach you about the ERC1155 standard and the `onERC1155Received` function.

## Challenge 12

```solidity
    function f12(bytes memory data) public isLive {
        uint256 fNum = 12;
        require(!progress[msg.sender][fNum]);

        (uint256 val1, bytes32 _hash, address _addr) = abi.decode(data, (uint256, bytes32, address));

        require(val1 == type(uint256).max);
        require(_hash == keccak256("The dark side is a path to abilities some consider...unnatural"));
        require(_addr == address(this));

        givePoints(fNum, msg.sender, 2600);
    }
```

This challenge is a little more difficult, and asks you to learn something about the `abi.decode` function in solidity. The `abi.decode` function is a function that is used to decode `bytes` data into a specific type or collection of types. The `abi.decode` function takes in two parameters, the `bytes` data to decode, and the lits of types to decode the data into. The `abi.decode` function is a powerful function that is used to decode data that is passed to a contract in the case where the types might change or to avoid compiler-issues like "stack too deep". The `abi.decode` function is used to decode the `data` parameter of a transaction. The `data` parameter of a transaction is a `bytes` type that

This challenge asks you to provide 3 abi-encoded values. The first value is a `uint256` type, the second value is a `bytes32` type, and the third value is an `address` type. The challenge wants you to provide the correct values for these types. The first value is the maximum value of a `uint256` type, the second value is the keccak256 hash of a specific string, and the third value is the address of the contract. You can find the maximum value of a `uint256` type by using the `type(uint256).max` constant in solidity, and you can find the keccak256 hash of a string by using the `keccak256` function in solidity. Once you have the correct values, encode them together with `abi.encode(val1, val2, val3)` and you can call the function with the correct input to get 2600 points.

## Challenge 13

```solidity
    function f13(address team, uint256 nonce) public isLive {
        uint256 fNum = 13;
        require(!progress[team][fNum]);

        uint256 d = solves[fNum] + 16;
        uint256 _hash = uint256(keccak256(abi.encode(nonce, msg.sender)));
        uint256 mask = 1 << d;
        require(_hash % mask == 0);

        givePoints(fNum, team, 2800);
    }
```

This challenge asks you to provide a single euint value, such that when a series of mathematical and hashing operations are applied to it, the result is a specific value. The challenge wants you to provide a value for `nonce` such that the value of `_hash` is divisible by `mask`. The operations it is doing here may look difficult, but are irrelevant for the purposes of solving it. The idea is that since we know the operations that are going to be performed, we can calculate them off-chain and then provide the correct input to the function. Since we know the value of `msg.sender` and `solves[fNum] + 16`, we can calculate the value of `_hash` off-chain, and then provide the correct value of `nonce` such that the value of `_hash` is divisible by `mask`.

The challenge has an additional layer of complexity though. variable `d` increases with every team that solves the challenge. This means that the value of `mask` increases with every team that solves the challenge. This means that the value of `nonce` that you provide will be unique to you. This means that you can't just copy the value of `nonce` from someone else who solved the challenge. You need to calculate the value of `nonce` yourself. However, when solving this, you would quickly notice that as mask increases rapidly, finding a hash that is divisible by mask is very difficult. This is because the hash function is a one-way function, and finding a specific hash is very difficult. This is a feature of the hash function that is used to secure the blockchain. The longer you wait to solve this challenge, the more difficult it becomes because the number of hashes you need to calculate increases.

A common complaint was that if you were trying to write a smart contract to brute-force a solution, you would very quickly hit the block gas-limit, and the execution would stop. This is because the operations that are being performed are very computationally expensive. This was on purpose. There are thus 2 potential ways to get around this

1. Increase the block gas limit on your tests to exorbitantly high amounts and hope that your brute force solution works before you run out of gas. This is the recommended way to solve the challenge cause it is easier to increase gas instead of rewriting your solver in a different language.

2. Use a different programming language to solve the hash, such as python, javascript, or rust that is not bounded by gas consumption. This is a little more difficult, but it's meant to teach you about the limitations of the EVM and the gas limit.

## Challenge 14

```solidity
    function f14(address _destination, address team) public isLive {
        uint256 fNum = 14;
        require(!progress[team][fNum]);

        if (!hasEntered[_destination]) {
            require(msg.sender.code.length != 0);
            hasEntered[msg.sender] = true;
        } else {
            require(_destination.code.length == 0);
            givePoints(fNum, team, 3000);
        }
    }
```

If you thought challenges were hard we're just getting started. This one doesn't have a `onlyContracts` modifier, but still requires you to write contracts. The challenge is a little more difficul. The `code` property of the `address` type is one that returns the bytecode of the contract that is located at the address. The length property of that, returns how long the bytecode is. A non-zero bytecode length means a contract exists. In the first branch of the if you are therefore asked to provide an address of a contract. Any contract in existence. However, you don't get the points until the second time the contract is called. After the first it sets `hasEntered` for the sender to be true. However, to get to the else branch, where the points are given you have to provide an address that has already been entered. You can provide it as input though, and that's because the require statement now checks that the length of the code IS zero. This is the challenge. How do you get rid of a contract's code? The only way to solve this challenge is to provide the address of a contract that has been self-destructed. This is a feature of the EVM that allows a contract to delete itself from the blockchain. Once a contract has been self-destructed, the code at the address is zero, and the contract is no longer in existence. So in order to solve the challenge you would need to deploy a contract that does two things. First is that it calls the function `f14` with its own address to set `hasEntered` to true. Then it self-destructs in the same transaction. Then you call the function again with the same address, but from a different sender (an EOA most likely) to get the points, because by this time the selfdestruct has finished, and the code length has been set to zero This is a little tricky, but it's meant to teach you about the self-destruct feature of the EVM.

It is expected that `selfdestruct` will be deprecated in 2024 in the EVM, so by the time you read this, it may not be possible to solve this challenge.

## Challenge 15

```solidity
    function f15(address team) external isLive {
        uint256 fNum = 15;
        require(!progress[team][fNum]);

        require(msg.sender.code.length == 0);
        require(msg.sender != tx.origin);

        if (entryCount[msg.sender] == 0) {
            entryCount[msg.sender]++;
            (bool sent,) = msg.sender.call("");
            require(sent);
        }

        givePoints(fNum, team, 3200);
    }
```

This is a pretty standard re-entry vulnerability challenge, with a twist. I'm not going to walk through re-entry in depth but you can find thaat information [here](https://blog.chain.link/reentrancy-attacks-and-the-dao-hack/)

The twist comes from `require(msg.sender.code.length == 0);`. In the next line we have a check that the caller is a contract `msg.sender != tx.origin`. One would think it's impossible for a contract to have a code-length of zero, but a very specific quirk of the EVM allows it. When deploying a contract, the code length property of a contract doesn't actually get set until the end of the tx where a contract was deployed. This means that if you execute an external contract call to the sprint contract from the CONSTRUCTOR of the contract, then `msg.sender.code.length == 0` will return true. The solution to the challenge is then to perform a re-entrancy attack during the constructor. The attack is carried out like normal, except the initial entry into the sprint contract needs to be done from the constructor of the attacking contract.

A further breakdown of what this looks like can be found [here](https://github.com/404-DAO/Solidity-Sprint/blob/main/contracts/Solutions.md#challenge-13)

## Challenge 16

```solidity
    function f16(address team) public isLive {
        uint256 fNum = 16;
        require(!progress[team][fNum]);

        require(token2.balanceOf(msg.sender) != 0, "You must construct additional pylons");

        givePoints(fNum, team, 3400);
    }
```

This challenge has a series of interesting parts to it. On face it looks pretty simple, simply acquire some amount of token2. Where to get it from is more interesting. If you look earlier in the contract, you see this function. It gives you token1, which was created for this challenge.

```solidity
    function dripFaucet() external isLive {
        token1.transfer(msg.sender, 100 ether);
    }
```

But we don't want token1, we want token2. Well if you search through the contract you may notice a strange parameter in the constructor

```solidity
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

        uniV2Pair = pair;//Strange right?
    }
```

Notice that 2nd address? A uniV2Pool? This is a swap-pool for Uniswap V2. I'm not going to go into detail how Uniswap V2 Pools work because it's far outside of the scope of this, you can find that information [here](https://docs.uniswap.org/contracts/v2/concepts/protocol-overview/how-uniswap-works)

If we went to a block explorer and looked at that pool, we would see very interestingly that it was recently created and has two tokens, token1 and token2 in it. So now we've identified that the sprint contract gives you token1, wants you to get token2, and tells you where to get it. You've probably used Uniswap on the front-end before. It's a great interface that makes it super easy to use, but this is the SOLIDITY sprint. We want you to learn about smart contracts. If you tried to go to the website, you'd find that there is no front-end for you to make this swap. You have to use the uniswap router contracts yourself.

The good news is that uniswap v2 is actually not that difficult to use straight from the contracts. If you can make a call to a contract of a specific interface, you can use their system.

I'm not going to break down exactly how to use it, since [this guide](https://docs.uniswap.org/contracts/v2/guides/smart-contract-integration/trading-from-a-smart-contract) already does a good job. But all you have to do is swap any amount of token1 for token2, then call the sprint contract from your holder. You don't even need to write a smart-contract to do it. You can do it entirely from an EOA interacting on Etherscan if you wish. But that's the challenge is figuring out how to do a swap without a front-end and figure out what's going on behind the scenes.

## Challenge 17

```solidity
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
```

Ok I'll admit, starting at this challenge I may have made it too hard. This challenge has a simple solution, but is difficult to navigate exactly what it wants you to do, which is why it's worth a lot of points. In 2023, Uniswap engineers created something called [Permit2](https://blog.uniswap.org/permit2-integration-guide). The idea behind it was to allow the addition of signature-based approvals for all tokens, even if they didn't support that feature natively. The idea was that you would grant an unlimited approval for a token to the Permit2 contract, and then when you wanted to transfer a token to a contract, you simply pass a signature. Instead of a separate approval for each Dapp, you would sign an off-chain message and let Permit2 do the work of verifying and transfering for you. However, to get it to work you would have to pass in a signature over a very specific set of data, strictly types. For this challenge, we wanted you to google what Permit2 was and identify its purpose, and then try to interact with it. This challenge asks you to sign a message of that data structure. In the challenge, the Sprint contract would call the function `permitTransferFrom()` on the Uniswap Permit2 contract with a bunch of data. However, only one piece of that data is supplied by the user, the signature. The rest of the data is strictly defined.

It is asking you to sign three fields together

1. `ISignatureTransfer.PermitTransferFrom` which itself contains a series of fields including the specification of a permitted token (WETH) and an amount (type(uint).max), a nonce of zero, and a deadline of the max possible timestamp.  
2. The details of the transfer, `1000 wei` to the sprint contract
3. The sender, yourself, denoted as `msg.sender`.

The idea behind this is that we are telling you exactly what that data needs to be signed, and asking you for the signature over it.

This challenge is also difficult because as you would find out in the research part of this, that the signature also includes a series of domain-separators, type-hashes, and other required data under [EIP-712](https://eips.ethereum.org/EIPS/eip-712). We wanted you to do some research on exactly what it takes to do secure signing and signature verification on-chain. The hard part is identifying what exactly it is that we want you to sign, and then signing it. You also need to acquire WETH and approve Permit2 to spend your WETH, but its assumed that if you've gotten that far, then that part of the contest is trivial. You can find the exact data structure for this in the solutions test-file.

## Challenge 18

```solidity
    //https://medium.com/@0xTraub/it-wont-byte-learning-not-to-fear-assembly-through-omni-chain-deployments-5ca82253c224
    function f18(address team) public isLive {
        uint256 fNum = 18;
        require(!progress[team][fNum]);

        address deployed = CREATE3.getDeployed(msg.sender, CREATE3.deploymentSalt);
        require(deployed.code.length != 0);

        givePoints(fNum, team, 3800);
    }
```

This challenge was also probably too difficult for the time alloted. However, it's the only challenge that actually came with an [article attached](    //https://medium.com/@0xTraub/it-wont-byte-learning-not-to-fear-assembly-through-omni-chain-deployments-5ca82253c224
). This challenge required additional reading to understand, which is why we provided it. I highly encourage you to read the article, as you may learn something about deterministic deployments in the EVM. I won't go into too much detail, but essentially, when you use a `CREATE3` library for a deterministic deployment, you are creating 2 contracts. One is a new proxy-contract at a deterministic address. This deterministic proxy then deploys the actual contract that you want to deploy. However, the proxy contract bytecode is hard-coded into the library, and the only thing that matters is the address that deployed it, and a user-provided salt. As long as those two are the same, then on any-chain you deploy it, the address of the proxy will be the same. In this challenge we wanted you to learn this deployment pattern.

`address deployed = CREATE3.getDeployed(msg.sender, CREATE3.deploymentSalt);`
On this line we're deterministically calculating what the address of the proxy WOULD BE if you the user calling `f18` deployed it, using the CONSTANT `deploymentSalt` hard-coded into the CREATE3 library which was shipped with the Sprint Contract.

If you looked at the library you would see this salt right at the top
`bytes32 constant deploymentSalt = keccak256("Set the gearshift for the high gear of your soul...");`

So the challenge is actually not as difficult as it seems. First we determine what that address is, and then we see if there's any code there, I.E we check to see if something was actually deployed to it. We even give you the function you need to execute.
`function deploy(bytes32 salt, bytes memory creationCode, uint256 value) internal returns (address deployed);`

This function is in the `CREATE3` library. All you need to do is deploy a contract which has this library, and then call `deploy()` with the salt we also gave you. You can deploy any contract in the world, we don't care what it does, as long as it deploys correctly. Once it has finished deploying, then wait til the end of the tx for the code-length to be set, and call the challenge function from your contract to receive your points.

To make the challenge even easier, in the solutions file we deployed another version of a contract we already used to solve other challenges in this competition, such as the reentrancy vulnerability.

## Challenge 19

```solidity
    function f19(address team, address contract1, address contract2) public isLive {
        uint256 fNum = 19;
        require(!progress[team][fNum]);

        assembly {
            if eq(xor(contract1, contract2), 0x00) { revert(0, 0) }

            if gt(xor(extcodehash(contract1), extcodehash(contract2)), 0x00) { revert(0, 0) }
        }

        givePoints(fNum, team, 4000);
    }
```

These challenges look scary because of the assembly, but I promise they have elegant solutions, and aren't that hard to follow. Let's go through it line-by-line.

`if eq(xor(contract1, contract2), 0x00) { revert(0, 0) }`

Starting from the inside-out, we already discussed the XOR operator earlier. So first we're going to take the two addresses passed in as parameters and XOR them together. An important thing to remember is that if two values are the same, then their XOR will be zero. So then we take that resulting value, and pass it to the `eq` function, where we compare the result of the xor to zero. So we're checking to see if the two addresses are the same. If they are, then we revert.

`if gt(xor(extcodehash(contract1), extcodehash(contract2)), 0x00) { revert(0, 0) }`

Let's work inside-out again. Every contract has a unique hash that is derived from the bytecode of the contract. This is the `extcodehash` function. We take the two addresses, and get their unique hashes. Then we XOR them together. If the result of that XOR is greater than zero, then we know that they are NOT equal. If they are not equal, then we revert.

So in simple terms, we're looking for two addresses that are not the same, and have the same bytecode. This is a little tricky, but it's meant to teach you about the `extcodehash` function and the `xor` function in assembly.

There are several solutions to this. You could deploy two copies of the same contract and pass those in. You could also go to etherscan and find two contracts with the same bytecode. Etherscan has this function. If you go to a contract page, and click on "more", and click similar, you can actually [search their entire database](https://etherscan.io/find-similar-contracts?a=0x6b175474e89094c44da98b954eedeac495271d0f) of contracts for ones that have the exact same bytecode.

However, there's two more tricks. Notice how even though we call the parameters `contract1` and `contract2`, we never actually check that they ARE contracts. You could pass in two different EOAs and the challenge would still pass, because the EOAs would have the same bytecode, no bytecode.

Finally there's one more trick. Notice how the `msg.sender` is never relevant to any of the assembly, and the contract addresses passed in are never stored anywhere. A completely legitimate strategy would be to wait for someone else to solve the challenge, and then copy their input to solve the challenge yourself. For one that's worth 4000 points, it's worth it to be a little sneaky. That's why we suggested to competitors that the best strategy would be to solve as many as possible off-chain, and then wait until the final minutes of the challenge to submit everything and take the lead. That way your answers can't be stolen by someone else and you can't be outdone.

## Challenge 20

```solidity
function f20(address team, address _contract) public isLive {
        uint256 fNum = 20;
        require(!progress[team][fNum]);

        bytes memory magicBytes = hex"a165767970657283000309000b";

        bytes memory bytecode = _contract.code.slice(_contract.code.length - 13, 13);

        require(keccak256(bytecode) == keccak256(magicBytes), "keep trying");

        givePoints(fNum, team, 4200);
    }
```

This challenge also requires some research. In the CS world, magic-bytes are typically associated with files. They are a brief segment of specific bytes which help your computer determine what the type of the file you want to open are. For example if you look at the raw-bytes of a PNG file, you would see `89 50 4E 47 0D 0A 1A 0A` as the first 8-bytes. We want to do something similar, but not exactly the same. Most people don't know this, but the Vyper compiler has a similar system. Vyper is another smart-contract language which compiles down to EVM bytecode. However, it's magic bytes are at the end of the bytecode, not the beginning. And more than that, it includes the version of the compiler you use. This challenge asks you to find a smart contract currently deployed which fits a specific compiler version. More on the vyper magic bytes can be found [here](https://twitter.com/pcaversaccio/status/1581308196387291136)

`bytes memory magicBytes = hex"a165767970657283000309000b";`

This is the magic bytes of the vyper-compiler for version 3.9 (as you can see by the 309).

The challenge is basically saying that it's going to take the last 13 bytes of the bytecode of whatever address you pass it, and compare it to make sure it matches those bytes. Now I bet you're probably wondering how you would even find something like this? Well Etherscan comes to the rescue again.

If you go to Etherscan, they actually have [a page that lets you filter verified contracts by ones written in Vyper](https://etherscan.io/contractsVerified?filter=vyper). Then all you need to do is go and scan the list quickly for one with the vyper-compiler you want. Then just double-check the magic bytes and you are off to the races.

The challenge in this comes from identifying the magic bytes for the vyper-compiler, because Vyper is not a language that most smart contract devs use, so we wanted you to learn about your alternative options.

It's also a completely valid solution once again to steal someone else's answer and use it for yourself since we don't check thhat the answer has already been used before.

## Challenge 21

```solidity
function f21(address team, address addr) public isLive {
        uint256 fNum = 21;
        require(!progress[team][fNum]);

        assembly {
            if eq(extcodesize(addr), 0x00) { revert(0, 0) }

            let size := 0x5

            let code := mload(0x40)
            let storageLocation := add(code, 0x20)

            mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))

            mstore(code, size)

            extcodecopy(addr, add(code, 0x20), 0, size)

            let firstPrefix := 0x6080604052000000000000000000000000000000000000000000000000000000
            let secondPrefix := 0x6060604052000000000000000000000000000000000000000000000000000000

            if or(eq(mload(storageLocation), firstPrefix), eq(mload(storageLocation), secondPrefix)) { revert(0, 0) }
        }

        givePoints(fNum, team, 4400);
    }
```

Now this one looks really scary but it's actually pretty simple. Let's start at the end.

`if or(eq(mload(storageLocation), firstPrefix), eq(mload(storageLocation), secondPrefix)) { revert(0, 0) }`

There's an or, and some equals inside of this. So first we can deduce that based on the revert, if the `or` is true, then revert. So we don't want either of the conditions on the inside to be true. We see two `eq` comparing some data loaded from  `storageLocation` against two constants, `firstPrefix` and `secondPrefix`. We know that `storageLocation` is somewhere in memory, since we used the `mload` opcode, and not `sload`.

So let's go back to the beginning.
`if eq(extcodesize(addr), 0x00) { revert(0, 0) }`
Pretty simple, if the code size of the address is zero, then revert. So a fancy way of saying "your provided address needs to be a contract.

```solidity
let size := 0x5

let code := mload(0x40)
let storageLocation := add(code, 0x20)
```

No we're going to declare three variables. First is size and it is created with value 5. Pretty easy. Then we're gonna load in the value in memory at `0x40`. For those of you familiar with [solidity memory layout](https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html), this is the location of our free-memory-pointer. I.E the next location in memory that can be written to. So we wanna know what the next available memory slot it. Then we're gonna add 0x20 (32-bytes, the size of one slot) to that value. So we're acquiring the next available free memory slot, and then storage location is one slot after that.

`mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))`
 So the trick of this line is that while it looks confusing, you don't actually need to know what it does. If you look at the first param, it's just writing some value to the free memory pointer. Which means that we can assume that it's just doing some manual memory cleanup for us, and since we're not going to mess with the free memory pointer, it doesn't matter to us, and we can ignore it.
`mstore(code, size)`
Now we already know what these two variables are, we're storing the value 5, in the slot designated as available by the free memory pointer.
`extcodecopy(addr, add(code, 0x20), 0, size)`
So the `extcodecopy` opcode allows us to write the bytecode from some external contract, into memory of our current one. It takes 4 parameters

1. The address to copy from.
2. The memory slot to begin writing to
3. The index of the bytecode to start reading from in the external contract
4. The number of bytes to read.

So the operation we are telling it to do is basically saying "copy from `addr`, `size` number of bytes, starting at `index 0`, and write it into memory-slot `code + 0x20`. Now we want to write to `code + 0x20`, because we already wrote the value `5` into slote `code`. Now if you've ever spent any time with assembly, you might recognize that we basically wrote the value 5 into memory before we then wrote 5-bytes of data into the memory slots immediately following it. That's how strings work in Solidity. You tell it how long the string is, and then the value itself.

```solidity
let firstPrefix := 0x6080604052000000000000000000000000000000000000000000000000000000
let secondPrefix := 0x6060604052000000000000000000000000000000000000000000000000000000
```

So now we've defined our two constants, padded out to 32-bytes to fit into a single memory slot neatly. So now when we return to our original `if-statement`
`mload(storageLocation)`, we know that `storageLocation` is just where we've written the first 5-bytes of the external addresses bytecode. So the branch is essentially saying "if the first 5 bytes of the bytecode of your provided contract is equal to either of those two constants, revert". Doesn't seem that hard right? Well that's the first half of the challenge. Now that we know what we're looking for, we have to identify where to find it. If you've made it this far, you probably can guess that I didn't just make up some random bytes to compare against. Those bytes are actually specifically chosen as part of the solidity compiler.

I won't go into too much detail about what those bytes do because it would be very long. But, it's suffice to say that almost all solidity and vyper code starts with one of those two sequences of bytes, which are written to organize the layout of memory in such a way that allows for high-level solidity to be compiled down to bytecode. It mostly has to do with the free memory pointer but that's not relevant. Now that we know what those bytes are for, the last logical step is to conclude that the challenge therefore wants us to find a contract that wasn't written with either of those compilers, or was written directly in bytecode.

There are several ways to accomplish this. One would be to look for a contract written in a language like [Huff](https://docs.huff.sh/), or to look for a minimal proxy contract like [ERC-1167](https://eips.ethereum.org/EIPS/eip-1167). But honestly you could probably find one by clicking around on Etherscan and looking at random verified contracts until you find one, like [this MEV bot](https://etherscan.io/address/0x6b75d8af000000e20b7a7ddf000ba900b4009a80#code).

And finally, it's also a valid solution to steal someone else's answer and use it for yourself. This challenge was meant to teach you not to be afraid of assembly, because when you break it down it's not actually that complicated, and to think outside the box and take advantage of the unique properties of a completely transparent blockchain.
