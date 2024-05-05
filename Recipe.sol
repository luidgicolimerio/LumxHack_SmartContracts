// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Recipe is ERC1155 {

     mapping(uint256 => address[]) private owners;
    
    uint256 royalties;
    uint256 recipe;

    constructor(address _company, uint256 _recipe, uint256 _royalties) ERC1155("https://froesmhs.com/olx-gui/{id}.json") {
        royalties = _royalties;
        recipe = _recipe;

        _mint(_company, recipe, 1, "");
        _mint(msg.sender, royalties, 5, "");

        owners[0].push(msg.sender);
    }

    function sell_royalties(address from, uint256 value) public {
        safeTransferFrom(msg.sender, from, royalties, value, "0x0");
        
        if (balanceOf(msg.sender, royalties) == 0){
            uint256 length = owners[0].length;
            for (uint256 i = 0; i < length; i++) {
                if (owners[0][i] == msg.sender) {
                // Substitua o elemento a ser removido com o último elemento da matriz
                    owners[0][i] = owners[0][length - 1];
                // Reduza o tamanho da matriz
                    owners[0].pop();
                    break;
                }         
            }
        }
        addOwner(0, from);
    }

    function addOwner(uint256 tokenId, address owner) private  {
        owners[tokenId].push(owner);
    }

    function getOwners() public view returns (address[] memory) {
        return owners[0];
    }

    function qtd_royatiels(address account) public view virtual returns (uint256){
        return balanceOf(account, royalties);
    }
}
