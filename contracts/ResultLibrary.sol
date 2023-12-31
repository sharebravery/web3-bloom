// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ResultLibrary
 * @author sharebravery
 * @notice 统一处理
 */
library ResultLibrary {
    struct Result {
        uint256 value;
        string message;
    }

    function createResult(
        uint256 _value,
        string memory _message
    ) internal pure returns (Result memory) {
        return Result(_value, _message);
    }
}
