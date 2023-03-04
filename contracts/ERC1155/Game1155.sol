pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract GameBook is ERC721 {

    using Address for address;

    address public immutable factory;
    uint256 public immutable originAmount;
    uint256 public immutable originMintPrice;

    constructor(uint256 _originAmount, uint256 _price) ERC721("GameBook","GB") payable {
        factory = msg.sender;
        originAmount = _originAmount;
        originMintPrice = _price;
    }

    function mint() public payable{
        require(!_msgSender().isContract(), "gamebook: call to non-contract");
        
    }

}

abstract contract BookUtil {
    
}

contract GameBookFactory is Context {

    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private _allGameBookAddrs;
    mapping(address => address) public GameBookCreatorInfos;

    event eCreateGameBook(address creator, address gameBookAddr);

    function createGameBook(uint originAmount, uint price) external returns (address gameBookAddr) {
        require(!_msgSender().isContract(), "gamebook: call to non-contract");
        GameBook gameBook = new GameBook(originAmount,price);
        gameBookAddr = address(gameBook);
        if (!_allGameBookAddrs.contains(gameBookAddr)) {
            _allGameBookAddrs.add(gameBookAddr);
            emit eCreateGameBook(msg.sender, gameBookAddr);
        } else {
            revert("gamebook: create gamebook fail");
        }
        GameBookCreatorInfos[gameBookAddr] = _msgSender();
    }

    function getAllGameBooks() public view returns (address[] memory){
        return _allGameBookAddrs.values();
    }

}
