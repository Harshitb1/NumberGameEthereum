pragma solidity ^0.5.11;
contract Token {

    /// @return total amount of tokens
    function totalSupply()  external returns (uint256 supply) {}

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) external returns (uint256 balance) {}

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) external returns (bool success) {}

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {}

    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of wei to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) external returns (bool success) {}

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) external returns (uint256 remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract ERC_20 is Token{

    uint256 public totalSupplyTokens;

    mapping(address => uint256) balance;
    mapping(address => mapping(address => uint256)) allowed;

    function balanceOf(address _owner)  public returns (uint256) {
        return balance[_owner];
    }
    function transfer(address _to, uint256 _value) public returns (bool success) {
        if(balance[tx.origin]>=_value&&_value>0){
            balance[tx.origin] -= _value;
            balance[_to] += _value;
            emit Transfer(tx.origin,_to,_value);
            return true;
        }
        return false;
    }
    
    function totalSupply() public returns (uint256){
        return totalSupplyTokens;
    }
    function transferFrom(address _owner, address _to, uint256 _value) public returns (bool success){
        if((allowed[_owner][tx.origin]>=_value) ||_owner==tx.origin || _owner==address(this) &&_value>0){
            balance[_owner] -= _value;
            balance[_to] += _value;
            if(_owner!=tx.origin){
                allowed[_owner][tx.origin] -= _value;
            }

            emit Transfer(_owner,_to,_value);

            return true;
        }
        return false;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        if(balance[tx.origin]>=_value && _value>=0){
            allowed[tx.origin][_spender] = _value;
            emit Approval(tx.origin,_spender,_value);
            return true;
        }
        return false;
    }
    


    function allowance(address _owner, address _spender) public  returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}

contract DPToken is ERC_20 {

    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'R1.0';
    address owner;
    constructor() public{
        name = "DP_TOKEN";
        owner = tx.origin;
        decimals = 0;
        totalSupplyTokens = 1000000;
        balance[tx.origin] = 1000000;
        symbol = "DPT";
    }

    function getTokenFromOwner(uint256 value) public{
        balance[tx.origin] += value;
        balance[owner] -=value;
    }
    
}