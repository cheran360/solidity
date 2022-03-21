// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{
    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToAmountFunded;

    address[] public funders;

    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    //Specifically payable with ETH/Ethereum
    //outsider is sending some amount to us through this function(funding)
    //anyone can fund us (outsiders)
    function fund() public payable {
        //$50
        uint256 minimumUSD = 50 * 10 ** 18;
        //1gwei < $50
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value; 
        funders.push(msg.sender);
        // what the ETH -> USD conversion rate 
    }

    function getVersion() public view returns (uint256){
        // should use Injected Web3 to use the below address.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        return priceFeed.version();   
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        //Type casting in solidity.
        return uint256(answer);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount)/1000000000000000000;
        return ethAmountInUsd;
    }
    
    //before u run this function do this require statement first
    modifier onlyOwner {
        require(msg.sender == owner);
        _; //( underscore here denotes the rest of the function(withdraw function) )
    }

    //only owner can withdraw amount sent by the outsiders from this contract
    function withdraw() payable onlyOwner public {
        // this -> means the contract we currently in. 
        msg.sender.transfer(address(this).balance);
        
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];  
            addressToAmountFunded[funder] = 0; 
        }
        
        funders = new address[](0);
    }
}