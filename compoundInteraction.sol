pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ComptrollerInterface.sol";
import "./CTokenInterface.sol";

contract Compound {
    IERC20 dai;
    CTokenInterface cDai;
    IERC20 usdc;
    CTokenInterface cUsdc;
    ComptrollerInterface comptroller;
    address _dai = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa;
    address _cDai = 0x6D7F0754FFeb405d23C51CE938289d4835bE3b14;
    address _usdc = 0x4DBCdF9B62e891a7cec5A2568C3F4FAF9E8Abe2b;
    address _cUsdc = 0x5B281A6DdA0B271e91ae35DE655Ad301C976edb1;
    address _comptroller = 0x2EAa9D77AE4D8f9cdD9FAAcd44016E746485bddb;

    constructor() {
        dai = IERC20(_dai);
        cDai = CTokenInterface(_cDai);
        usdc = IERC20(_usdc);
        cUsdc = CTokenInterface(_cUsdc);
        comptroller = ComptrollerInterface(_comptroller);
    }

    function approveContract(uint amount) public {
      dai.approve(address(this), amount);
    }

    function deposit(uint _amount) public {
           
    dai.transferFrom(msg.sender, address(this), _amount);
     dai.approve(address(cDai), _amount);
      require(cDai.mint(_amount) == 0, "mint failed");
    }
    function withdraw(uint _amount) public {
        require(cDai.redeem(_amount) == 0, "failed");
    }
    function getDaiBalance() public view returns(uint) {
        return dai.balanceOf(msg.sender);
    }
    function getDaiContractBalance() public view returns(uint) {
        return dai.balanceOf(address(this));
    }
    function borrow(uint _amount) public {
        address[] memory markets = new address[](1);
        markets[0] = address(cDai);
        comptroller.enterMarkets(markets);
        cUsdc.borrow(_amount);
    }
    function payBorrow(uint _amount) public {
        usdc.approve(address(cUsdc), _amount);
        cUsdc.repayBorrow(_amount);
    }
    function getCDaiBalance() public view returns(uint) {
        return cDai.balanceOf(msg.sender);
    }
    function getCDaiContractBalance() public view returns(uint) {
        return cDai.balanceOf(address(this));
    }
      function getInfo() external returns (uint exchangeRate, uint supplyRate) {
    // Amount of current exchange rate from cToken to underlying
    exchangeRate = cDai.exchangeRateCurrent();
    // Amount added to you supply balance this block
    supplyRate = cDai.supplyRatePerBlock();
  }


}
