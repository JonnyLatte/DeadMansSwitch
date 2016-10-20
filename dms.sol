pragma solidity ^0.4.0;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

//https://github.com/nexusdev/erc20/blob/master/contracts/erc20.sol

contract ERC20Constant {
    function totalSupply() constant returns (uint supply);
    function balanceOf( address who ) constant returns (uint value);
    function allowance(address owner, address spender) constant returns (uint _allowance);
}
contract ERC20Stateful {
    function transfer( address to, uint value) returns (bool ok);
    function transferFrom( address from, address to, uint value) returns (bool ok);
    function approve(address spender, uint value) returns (bool ok);
}
contract ERC20Events {
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval( address indexed owner, address indexed spender, uint value);
}
contract ERC20 is ERC20Constant, ERC20Stateful, ERC20Events {}


contract dms is owned {
    address public owner;
    address public nextOfKin;
    uint public lockDate;
    uint public lockTime;
    
    modifier onlyAfter {
        if (now < lockDate) throw;
        _;
    }
    
    modifier updateInterval {
        _;
        lockDate = now + lockTime;
    }
    
    modifier onlyKin {
        if(msg.sender != nextOfKin) throw;
        _;
    }
    
    function dms(address otherPerson,uint interval) updateInterval {
        nextOfKin = otherPerson;
        lockTime = interval;
    }

    function () payable updateInterval {
    }
   
    function getTimeRemaining() constant returns (uint)
    {
        if (now < lockDate) return lockDate-now;
        return  0;
    }
   
    function transfer(address receiver, uint amount) onlyOwner updateInterval {
        if(!receiver.send(amount)) throw;
    }
   
    function setNextOfKin(address otherPerson) onlyOwner updateInterval {
        nextOfKin = otherPerson;
    }
   
    function setLockTime(uint interval) onlyOwner updateInterval {
        lockTime = interval;
    }
   
    function inheritContract(address otherPerson) onlyKin onlyAfter updateInterval {
        owner = nextOfKin;
        nextOfKin = otherPerson;
    }
   
   	function transferToken(address _token, address _to, uint256 _value) onlyOwner updateInterval returns (bool ok)
	{
		return ERC20(_token).transfer(_to,_value);
	}
}
