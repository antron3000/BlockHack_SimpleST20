
 pragma solidity ^0.5.7;


/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract IST20 {

    // off-chain hash
    bytes32 public tokenDetails;

    //transfer, transferFrom must respect the result of verifyTransfer
    function verifyTransfer(address _from, address _to, uint256 _amount) view public returns (bool success);

    //used to create tokens
    function mint(address _investor, uint256 _amount) public returns (bool success);

    event Minted(address indexed _to, uint256 _value);

}

contract ST20 is IERC20,IST20 {

    mapping (address => uint256) private balances;

    mapping (address => mapping (address => uint256)) private allowed;

    mapping(address => bool) private whitelist;

    uint256 public totalSupply;

    address public ContractOwner;

    string public name = "Blockhack Coin";
    string public symbol= "BHC";
    uint8 public decimals = 0;

    constructor() public {
        ContractOwner = msg.sender;
    }



    /**
     * @dev Gets the balance of the specified address.
     * @param owner The address to query the balance of.
     * @return A uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function isWhitelisted(address owner) public view returns (bool){
        return whitelist[owner];
    }



    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowed[owner][spender];
    }

    /**
     * @dev Transfer token to a specified address.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function transfer(address to, uint256 value) public returns (bool) {
        require(balances[msg.sender]>=value);
        balances[msg.sender] -= value;
        balances[to] += value;
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(allowed[from][to] >= value);
        require(balances[from] >= value);
        allowed[from][to] -= value;
        balances[to] = balances[to] += value;
        balances[from] -= value;
        return true;
    }


     function whitelistInvestor(address _investor) public {
        whitelist[_investor] = true;
    }

        //transfer, transferFrom must respect the result of verifyTransfer
    function verifyTransfer(address _from, address _to, uint256 _amount) view public returns (bool success){
        if(whitelist[_from]==true && whitelist[_to]==true){
            return true;
        } else {
            return false;
        }
    }

    //used to create tokens
    function mint(address _investor, uint256 _amount) public returns(bool){
        require(msg.sender==ContractOwner);
        balances[_investor] += _amount;
        emit Minted(_investor,_amount);
        return true;
    }





}
