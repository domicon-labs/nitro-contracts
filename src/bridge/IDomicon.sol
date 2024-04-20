// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IDomicon {
    function submits(
        address user,
        uint256 index
    )external view returns (uint256, uint256, address, address, bytes memory, bytes memory);
}
