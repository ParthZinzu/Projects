// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Auction{
    event Sold(address indexed buyer, uint productId , uint price);
struct Product{
    bool auctioned;
    uint _minprice;
    // uint productId;
}
struct Bidders{
    address _bidders;
    uint amountbid;
}
mapping(uint => Product ) ProductFetch;
mapping(address => Bidders) bidders;
address owner = msg.sender;
address HighestBidder;
bool startAuction;
uint highestbid;
Bidders [] biddings;
uint timestart;
uint public timestop;
uint productcount;
uint i = 1;
modifier onlyOwner(){
    require(msg.sender==owner,"Only Owner can acces the function");
    _;
} 
function RegAsProduct( uint _minprice) external onlyOwner
{   
    productcount += 1;
    ProductFetch[productcount] = Product(false,_minprice);
}
function startauction(uint ProductId) external onlyOwner{
require(ProductId<=productcount && ProductId>=1,"invalid ID");
timestop = block.timestamp+2*60;
startAuction=true;
highestbid = ProductFetch[ProductId]._minprice;
}
function RegAsBuyer () external{
    require(msg.sender!=owner,"Admin cannot register for auction");
    require(bidders[msg.sender]._bidders != msg.sender,"Already Registered");
    bidders[msg.sender] = Bidders(msg.sender,0);
}
function Bid() external payable{
   require(block.timestamp<timestop,"Auction ended");
   require(startAuction,"Auction not started");
   require(msg.sender!=owner,"Admin cannot partcipate auction");
   require(bidders[msg.sender]._bidders==msg.sender,"Not Registered for auction");
   //require(msg.value>ProductFetch[i++]._minprice,"Bid requirements not met");
   require(msg.value > highestbid,"you are not the highest bidder");
   HighestBidder = bidders[msg.sender]._bidders;
   biddings.push(Bidders(msg.sender,msg.value));
   highestbid = msg.value;

   if(timestop>=block.timestamp+1  && timestop<= block.timestamp + 60 )
   {
       timestop += 20;
   }
}
function highestbidder() external view returns (address , uint)
{
    return (HighestBidder,highestbid);
}
function ReclaimMoney() external payable{
    for(uint j =0 ; j<biddings.length;j++)
    {   
        payable (biddings[j]._bidders).transfer(biddings[j].amountbid);
        biddings[j].amountbid=0;
    }
}

}
