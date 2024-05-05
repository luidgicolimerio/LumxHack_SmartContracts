// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.6.0/access/AccessControl.sol";



contract HopToken is ERC20, AccessControl{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    address owner;

    constructor() ERC20("HopToken", "HOP") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function change_role(address to) public onlyRole(MINTER_ROLE){
        _grantRole(DEFAULT_ADMIN_ROLE, to);
        _grantRole(MINTER_ROLE, to);
        owner = to;
        _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _revokeRole(MINTER_ROLE, msg.sender);
    }
    function buy_beer(uint256 value) public{
        require(allowance(msg.sender, address(this)) >= value, "Insufficient allowance");
        
        _transfer(msg.sender, address(this), value);
    }
    function payment(address adr1, address adr2, address adr3, address adr4, address adr5, address adr6, uint256 value) public onlyRole(MINTER_ROLE){
        // Calcula o valor para cada carteira
        uint256 mainWalletAmount = (value * 95) / 100; // 95% do valor
        uint256 otherWalletsAmount = (value * 1) / 100; // 1% do valor

        // Transfere 95% do valor para a primeira carteira
        transferFrom(address(this), adr1, mainWalletAmount);

        // Transfere 1% do valor para cada uma das outras carteiras
        transferFrom(address(this), adr2, otherWalletsAmount);
        transferFrom(address(this), adr3, otherWalletsAmount);
        transferFrom(address(this), adr4, otherWalletsAmount);
        transferFrom(address(this), adr5, otherWalletsAmount);
        transferFrom(address(this), adr6, otherWalletsAmount);
    }


    function decimals() public pure override returns (uint8) {
        return 2;
    }
}