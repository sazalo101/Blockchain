// SPDX-License-Identifier: MIT
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract Insurance {
    address public owner;
    IERC20 public cUSDToken;
    uint256 public monthlyPremium;
    uint256 public penaltyPercentage = 20;
    uint256 public claimPercentage = 75;

    struct Policy {
        bool active;
        uint256 lastPayment;
        uint256 totalPaid;
    }

    mapping(address => Policy) public policies;

    event PolicyPurchased(address indexed policyHolder);
    event PolicyTerminated(address indexed policyHolder, uint256 penalty);
    event ClaimPaid(address indexed policyHolder, uint256 amount);

    constructor(address _cUSDToken, uint256 _monthlyPremium) {
        owner = msg.sender;
        cUSDToken = IERC20(_cUSDToken);
        monthlyPremium = _monthlyPremium;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function purchasePolicy() external {
        require(!policies[msg.sender].active, "Policy already exists");
        require(cUSDToken.transferFrom(msg.sender, address(this), monthlyPremium), "Payment failed");
        policies[msg.sender] = Policy(true, block.timestamp, monthlyPremium);
        emit PolicyPurchased(msg.sender);
    }

    function payMonthlyPremium() external {
        require(policies[msg.sender].active, "No active policy found");
        require(cUSDToken.transferFrom(msg.sender, address(this), monthlyPremium), "Payment failed");
        policies[msg.sender].lastPayment = block.timestamp;
        policies[msg.sender].totalPaid += monthlyPremium;
    }

    function terminatePolicy() external {
        require(policies[msg.sender].active, "No active policy found");
        uint256 penalty = (policies[msg.sender].totalPaid * penaltyPercentage) / 100;
        uint256 refund = policies[msg.sender].totalPaid - penalty;
        require(cUSDToken.balanceOf(address(this)) >= refund, "Insufficient funds in contract");
        require(cUSDToken.transfer(msg.sender, refund), "Refund failed");
        policies[msg.sender].active = false;
        emit PolicyTerminated(msg.sender, penalty);
    }

    function claimInsurance() external {
        require(policies[msg.sender].active, "No active policy found");
        uint256 claimAmount = (policies[msg.sender].totalPaid * claimPercentage) / 100;
        require(cUSDToken.balanceOf(address(this)) >= claimAmount, "Insufficient funds in contract");
        require(cUSDToken.transfer(msg.sender, claimAmount), "Claim payment failed");
        policies[msg.sender].active = false;
        emit ClaimPaid(msg.sender, claimAmount);
    }

    function withdrawFunds(uint256 amount) external onlyOwner {
        require(cUSDToken.balanceOf(address(this)) >= amount, "Insufficient funds in contract");
        require(cUSDToken.transfer(owner, amount), "Withdrawal failed");
    }
}