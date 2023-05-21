//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BladeDAOToken is ERC20, Ownable {
    mapping(address => bool) public blackList;
    bool public pause;

    constructor(string memory _name, string memory _symbol, uint256 amount)
        ERC20(_name, _symbol)
    {
        _mint(msg.sender, amount);
    }

    function burn(uint amount) public {
        _burn(msg.sender, amount);
    }

    function freeze(address account) external onlyOwner {
        blackList[account] = true;
    }

    function unfreeze(address account) external onlyOwner {
        delete blackList[account];
    }

    function setPause(bool _pause) external onlyOwner {
        pause = _pause;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256
    ) internal view override {
        require(!pause, "paused!");
        require(!blackList[from], "from is banned!");
        require(!blackList[to], "to is banned!");
    }
}
