pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

contract Lottery{   

    struct user{
        address payable userAddress;
        uint tokensBought;
        lotteryNumbers[] userLotteries ;
    }
    
    struct lotteryNumbers{
        date lotteryDate;
        uint number1;
        uint number2;
        uint number3;
    }
    
    struct date{
        uint day;
        uint month;
        uint year;
    }
    
    user[]  mUsers;
    lotteryNumbers[] historicalWinners;
    
    lotteryNumbers winning;

    address payable public owner;

    constructor( ) public{
      owner = msg.sender;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    //functions related to user registration
    //////////////////////////////////////////////////////////////////////////////////////////
    /**
     * Register a user
     * address - address
     **/
    function registerUser() public returns(address){
      if(!amIRegistered())
      {
          uint length = mUsers.length++;
          mUsers[length].userAddress = msg.sender;
          mUsers[length].tokensBought = 0;
          return msg.sender;
      }
      revert("User address allready registered");
    }
    
    /**
     * Check if the user has registered
     **/
    function amIRegistered() private view returns(bool)
    {
        for(uint i=0;i<mUsers.length;i++)
        {
            if(mUsers[i].userAddress==msg.sender)
            {
                return true;
            }
        }
        return false;
    }

    /**function to add tokens to the user that calls the contract
     * the money held in contract is sent using a payable modifier function
     * money can be released using selfdestruct(address)
     **/
	function addTokens() public payable 
	{
        uint tokensToAdd = msg.value/(10**18);
    
        for(uint i = 0; i < mUsers.length; i++) 
        {
          if(mUsers[i].userAddress == msg.sender) 
          {
            mUsers[i].tokensBought += tokensToAdd;
            break;
          }
        }
	}

  // transfer money to owner if owner exists
	function getPrice(uint _day, uint _month, uint _year) public returns (uint){
    user[] memory winningUsers = getWinningUsers( _day,_month,_year);
    require(owner == msg.sender);
    for(uint i=0;i<winningUsers.length;i++)
    {
        if (winningUsers[i].userAddress == owner) 
        {
          owner.transfer(address(this).balance);
        } 
        else 
        {
          uint toTransfer = address(this).balance;
          winningUsers[i].userAddress.transfer(toTransfer);
        }
    }
    return address(this).balance;
	}
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    //functions related to entering and retrieving user lottery numbers
    //////////////////////////////////////////////////////////////////////////////////////////
    function registerLotteryNumbers(uint _day, uint _month, uint _year, uint _number1,uint _number2,uint _number3) public returns(bool)
    {
        if(isDateValid(_day,_month,_year))
            if(isNumberValid(_number1))
                if(isNumberValid(_number2))
                    if(isNumberValid(_number3))
                      {
                          date memory newDate = date(_day,_month,_year);
                          lotteryNumbers memory newLotteryNumber = lotteryNumbers(newDate,
                                      _number1,_number2,_number3);
                          for(uint i=0;i<mUsers.length;i++)
                          {
                              if(mUsers[i].userAddress == msg.sender)
                              {
                                  mUsers[i].userLotteries.push(newLotteryNumber);
                                  return true;
                              }
                          }
                      }
            revert("Numbers need to be greater than 0 and less than 100");
        revert("invalid date selected");    
    }
    
    /**
     * returns all lottery numbers of ANY user for ANY date
     **/
     function getAllLotteries() public returns(lotteryNumbers[] memory)
     {
        lotteryNumbers[] memory _lotteryNumbers;
        uint len = 0;
        for(uint i=0; i<mUsers.length;i++)
        {
            for( uint j =0; j<mUsers[i].userLotteries.length;j++)
            {
                _lotteryNumbers[len] = mUsers[i].userLotteries[j]; 
                len++;
            }
        }
        return _lotteryNumbers;
     }
    
    /**
     * returns all lottery numbers of A user for ANY date
     **/
     function getAllLotteriesOfUser() public returns(lotteryNumbers[] memory)
     {
         for(uint i=0; i<mUsers.length;i++)
         {
             if(mUsers[i].userAddress == msg.sender)
             {
                 return mUsers[i].userLotteries;
             }
         }
     }
     
     /**
     * returns all lottery numbers of A user for PARTICULAR date
     **/
     function getAllLotteriesOfUserForDate(uint _day, uint _month, uint _year) public returns(lotteryNumbers[] memory)
     {
         date memory _date = date(_day,_month,_year);
         for(uint i=0; i<mUsers.length;i++)
         {
             if(mUsers[i].userAddress == msg.sender)
             {
                 lotteryNumbers[] memory _lotteryNumbers;
                 uint len = 0;
                 for( uint j =0; j<mUsers[i].userLotteries.length;j++)
                 {
                    if(mUsers[i].userLotteries[j].lotteryDate.day == _day &&
                        mUsers[i].userLotteries[j].lotteryDate.month == _month &&
                        mUsers[i].userLotteries[j].lotteryDate.year == _year)
                    {
                       _lotteryNumbers[len] = mUsers[i].userLotteries[j]; 
                       len++;
                    }
                 }
                 return _lotteryNumbers;
             }
         }
     }
     
     
    /**
     * check if the lotto number is Valid
     **/
    function isNumberValid(uint _number) private returns(bool)
    {
        return(_number>=0 && _number<100);
    }
    
     /**
     * check if the lotto date is a valid date
     **/
    function isDateValid(uint _day, uint _month, uint _year) private returns(bool)
    {
        uint[12] memory daysInMonth= [uint(31),28,31,30,31,30,31,31,30,31,30,31]; 
        uint[12] memory daysInMonthLeapYear = [uint(31),29,31,30,31,30,31,31,30,31,30,31];
        if(_month>0 && _month<=12)
        {
            if(_year>0)
            {
                //leap year
                if(_year%4 ==0)
                {
                    if(_day>0 && _day < daysInMonthLeapYear[_month])
                    {
                        return true;
                    }
                    return false;
                }
                else
                {
                    if(_day>0 && _day<daysInMonth[_month])
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }
        return false;
    }
     
    ///////////////////////////////////////////////////////////////////////////////////////////
    //functions related to generating lottery numbers
    //////////////////////////////////////////////////////////////////////////////////////////
     /**
      * Get a random winning lottery number
      **/
      function getWinningLotteryNumbers() public returns(lotteryNumbers memory)
      {
          lotteryNumbers memory winning;
          winning.number1 = random(0);
          winning.number2 = random(winning.number1);
          winning.number3 = random(winning.number2);
          historicalWinners.push(winning);
          return winning;
      }
      
    /**
    * Get all past winning lottery Numbers.
    **/
    function getHistoricalWinners() public returns(lotteryNumbers[] memory)
    {
        return historicalWinners;
    }
    
    /**
     * Get any winning users if any
     * need to input the date for which the lottery is drawn
     **/
     function getWinningUsers(uint _day, uint _month, uint _year) public returns(user[] memory )
     {
         user[] memory winningUsers;
         uint len =0;
         for(uint i=0;i<mUsers.length;i++)
         {
             for(uint j=0;j<mUsers[i].userLotteries.length;j++)
             {
                 if(mUsers[i].userLotteries[j].lotteryDate.day == _day &&
                    mUsers[i].userLotteries[j].lotteryDate.month == _month &&
                    mUsers[i].userLotteries[j].lotteryDate.year == _year)
                    {
                        if(mUsers[i].userLotteries[j].number1 == winning.number1 &&
                        mUsers[i].userLotteries[j].number2 == winning.number2 &&
                        mUsers[i].userLotteries[j].number3 == winning.number3 )
                        {
                            winningUsers[len] = mUsers[i];
                            len++;
                        }
                    }
             }
         }
         return winningUsers;
     }
     /**
      * returns a 2 digit random number
      **/
     function random(uint generated) private returns (uint) 
     {
        uint randomHash = uint(keccak256(abi.encodePacked(block.difficulty, now+generated)));
        return randomHash % 100;
    } 
}