// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title PaymentRequest
 * @notice A simple on-chain payment request system for ERC20 tokens (e.g., USDC)
 *
 * Flow:
 * 1. A payer (msg.sender) creates a request to pay someone a given amount.
 * 2. Later, the payer approves the request, transferring tokens automatically.
 * 3. Requests can also be cancelled before approval.
 *
 * Note:
 * - The payer must first approve this contract to spend their tokens via
 *   ERC20.approve(contractAddress, amount).
 */

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract PaymentRequest is ReentrancyGuard {
    using SafeERC20 for IERC20;

    enum Status {
        Pending,
        Approved,
        Cancelled
    }

    struct Request {
        uint256 id;
        address payer;
        address payee;
        uint256 amount;
        string description;
        Status status;
        uint256 createdAt;
        uint256 approvedAt;
        uint256 cancelledAt;
    }

    IERC20 public immutable token;
    uint256 public nextRequestId;
    mapping(uint256 => Request) public requests;
    mapping(address => uint256[]) public requestsByPayer;
    mapping(address => uint256[]) public requestsForPayee;

    event RequestCreated(uint256 indexed id, address indexed payer, address indexed payee, uint256 amount, string description);
    event RequestApproved(uint256 indexed id, address indexed payer, address indexed payee, uint256 amount);
    event RequestCancelled(uint256 indexed id, address indexed payer);

    constructor(address _token) {
        require(_token != address(0), "token address required");
        token = IERC20(_token);
    }

    function createRequest(address _to, uint256 _amount, string calldata _description)
        external
        returns (uint256 id)
    {
        require(_to != address(0), "invalid payee");
        require(_amount > 0, "amount must be > 0");

        id = ++nextRequestId;
        Request storage r = requests[id];
        r.id = id;
        r.payer = msg.sender;
        r.payee = _to;
        r.amount = _amount;
        r.description = _description;
        r.status = Status.Pending;
        r.createdAt = block.timestamp;

        requestsByPayer[msg.sender].push(id);
        requestsForPayee[_to].push(id);

        emit RequestCreated(id, msg.sender, _to, _amount, _description);
    }

    function approveRequest(uint256 _id) external nonReentrant {
        Request storage r = requests[_id];
        require(r.id == _id, "request not found");
        require(r.status == Status.Pending, "not pending");
        require(r.payer == msg.sender, "only payer can approve");

        r.status = Status.Approved;
        r.approvedAt = block.timestamp;

        token.safeTransferFrom(r.payer, r.payee, r.amount);

        emit RequestApproved(_id, r.payer, r.payee, r.amount);
    }

    function cancelRequest(uint256 _id) external {
        Request storage r = requests[_id];
        require(r.id == _id, "request not found");
        require(r.status == Status.Pending, "not pending");
        require(r.payer == msg.sender, "only payer can cancel");

        r.status = Status.Cancelled;
        r.cancelledAt = block.timestamp;

        emit RequestCancelled(_id, r.payer);
    }

    function getRequestsByPayer(address _payer) external view returns (uint256[] memory) {
        return requestsByPayer[_payer];
    }

    function getRequestsForPayee(address _payee) external view returns (uint256[] memory) {
        return requestsForPayee[_payee];
    }

    function getRequest(uint256 _id) external view returns (Request memory) {
        return requests[_id];
    }
}