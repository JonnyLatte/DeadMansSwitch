contract dms {
        address public owner;
        address public nextOfKin;
        uint public lockDate;
        uint public lockTime;

        function dms(address otherPerson,uint interval) {
            owner = msg.sender;
            nextOfKin = otherPerson;
            lockTime = interval;
            lockDate = now + lockTime;
        }

        function () {
                if (msg.sender==owner) {
                lockDate = now + lockTime;
            }
        }
       
        function getTimeRemaining() constant returns (uint)
        {
            if (now < lockDate) return lockDate-now;
            return  0;
        }
       
        function send(address receiver, uint amount){
            if (msg.sender==owner && this.balance >= amount) {
                lockDate = now + lockTime;
                        receiver.send(amount);
            }
        }
       
        function setNextOfKin(address otherPerson) {
            if (msg.sender==owner) {
                nextOfKin = otherPerson;
                lockDate = now + lockTime;
            }
        }
       
    function setLockTime(uint interval) {
            if (msg.sender==owner) {
                lockTime = interval;
                lockDate = now + lockTime;
            }
        }
       
        function inheritContract(address otherPerson) {
            if (msg.sender==nextOfKin && now > lockDate) {
                owner = nextOfKin;
                nextOfKin = otherPerson;
                lockDate = now + lockTime;
            }
        }
       
    function inheritFunds() {
            if (msg.sender==nextOfKin && now > lockDate) {
                 suicide(nextOfKin);
            }
        }
}
