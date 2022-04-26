// https://eips.ethereum.org/EIPS/eip-721, http://erc721.org/ 
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../interfaces/IERC721.sol";
import "../interfaces/IERC721Receiver.sol";
import "./ERC165.sol";
import "../libraries/Address.sol";
import "../libraries/SafeMath.sol";

contract ERC721 is ERC165, IERC721 {

    using Address for address;
    using SafeMath for uint;

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;

    constructor()
    {
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_InterfaceId_ERC721);
    }


    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => uint256) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;



    function balanceOf(address _owner) public view virtual returns (uint256){
        require(_owner != address(0));
        return _ownedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view virtual returns (address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0));
        return owner;
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public virtual payable{
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public virtual payable{
        transferFrom(_from, _to, _tokenId);
        // solium-disable-next-line arg-overflow
        require(_checkOnERC721Received(_from, _to, _tokenId, data));
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public virtual payable{
        require(isApprovedOrOwner(msg.sender, _tokenId));
        require(_to != address(0));

        clearApproval(_from, _tokenId);
        removeTokenFrom(_from, _tokenId);
        addTokenTo(_to, _tokenId);

        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) public virtual payable{
        address owner = ownerOf(_tokenId);
        require(_approved != owner);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

        _tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) public virtual{
        require(_operator != msg.sender);
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view virtual returns (address){
        require(_exists(_tokenId));
        return _tokenApprovals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view virtual returns (bool){
        return _operatorApprovals[_owner][_operator];
    }
    
    function removeTokenFrom(address from, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from);
        _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
        _tokenOwner[tokenId] = address(0);
    }
    function addTokenTo(address to, uint256 tokenId) internal {
        require(_tokenOwner[tokenId] == address(0));
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
    }
    function clearApproval(address owner, uint256 tokenId) private {
        require(ownerOf(tokenId) == owner);
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }
    function isApprovedOrOwner(
        address spender,
        uint256 tokenId
    )
        internal
        view
        returns (bool)
    {
        address owner = ownerOf(tokenId);
        // Disable solium check because of
        // https://github.com/duaraghav8/Solium/issues/175
        // solium-disable-next-line operator-whitespace
        return (
        spender == owner ||
        getApproved(tokenId) == spender ||
        isApprovedForAll(owner, spender)
        );
  }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    )
        internal
        returns (bool)
    {
        if (!to.isContract()) {
        return true;
        }
        bytes4 retval = IERC721Receiver(to).onERC721Received(
        msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }
}