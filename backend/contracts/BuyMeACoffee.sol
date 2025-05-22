// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract BuyMeACoffee {
    address public admin;

    uint256 public creatorsCount;

    struct Creator {
        address creatorAddr;
        string name;
        string bio;
        string pictureUrl;
    }

    event creatorJoined(uint256 indexed id, address indexed creatorAddr);
    event buyACoffee(address indexed creator, uint256 amount);

    mapping(uint256 => Creator) public creators;

    constructor() {
        admin = msg.sender;
    }

    function addCreator(
        string memory _name,
        string memory _bio,
        string memory _pictureUrl
    ) public {
        creatorsCount += 1;
        creators[creatorsCount] = Creator({
            creatorAddr: msg.sender,
            name: _name,
            bio: _bio,
            pictureUrl: _pictureUrl
        });

        emit creatorJoined(creatorsCount, msg.sender);
    }

    function getCreator(uint _id) public view returns (Creator memory) {
        Creator memory creator = creators[_id];
        return creator;
    }

    function getCreators() public view returns (Creator[] memory) {
        Creator[] memory _creators = new Creator[](creatorsCount);

        for (uint256 i = 1; i <= creatorsCount; i++) {
            _creators[i - 1] = creators[i];
        }

        return _creators;
    }
}
