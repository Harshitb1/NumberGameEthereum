pragma solidity >=0.5.0 <0.6.0;
contract NumberGuessGame {
    address public manager;
    
    uint public value;

    constructor() public payable {
        
        require(msg.value > 1 ether);
        manager = msg.sender;
    }


    function random() private view returns (uint) {
      
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
    }

    function play(uint selected) public  payable{
        
        value = 2*msg.value;
        require(address(this).balance > value);
        uint num = random() % 2;
        if(selected==num){
            msg.sender.transfer(2*msg.value); 
        }
      
    }

    modifier restricted() {
        require(msg.sender == manager);
        _; 
    }

    function getBalance() public view restricted returns (uint) {
        return address(this).balance;
    }
}

