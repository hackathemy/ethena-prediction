// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155Burnable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import {ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BettingToken is ERC1155, ERC1155Burnable, Ownable, ERC1155Supply {
    mapping(uint256 => string) private _tokenURIs;

    constructor(address initialOwner,string memory upTokenURI,string memory downTokenURI) ERC1155("") Ownable(initialOwner) {
        setTokenURI(1, upTokenURI);
        setTokenURI(2, downTokenURI);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
    public
    onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
    public
    onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
    internal
    override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

    // 특정 ID에 대한 URI를 설정하는 함수
    function setTokenURI(uint256 id, string memory tokenURI) internal {
        _tokenURIs[id] = tokenURI;
    }

    // uri(uint256 id) 함수 오버라이드
    function uri(uint256 id) public view override returns (string memory) {
        return _tokenURIs[id];
    }
}
