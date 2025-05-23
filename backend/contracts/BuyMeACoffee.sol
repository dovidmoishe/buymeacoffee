// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IERC20 {
    function transferFrom(address, address, uint256) external returns (bool);
}

contract BuyMeACoffee {
    address public immutable admin;
    IERC20 public immutable usdc;

    uint256 public creatorsCount;

    struct Creator {
        address creatorAddr;
        string name;
        string bio;
        string pictureUrl;
    }

    event creatorJoined(uint256 indexed id, address indexed creatorAddr);
    event CoffeeBought(
        uint256 indexed id,
        address indexed buyer,
        uint256 amount
    );

    mapping(uint256 => Creator) public creators;

    constructor(address _usdcAddress) {
        address usdcAddress = _usdcAddress;
        usdc = IERC20(usdcAddress);
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

    function buyACoffee(uint256 _id, uint256 _amount) external {
        Creator storage selectedCreator = creators[_id];
        require(
            selectedCreator.creatorAddr != address(0),
            "Creator does not exist"
        );

        bool success = usdc.transferFrom(
            msg.sender,
            selectedCreator.creatorAddr,
            _amount
        );
        require(success, "Transfer failed");

        emit CoffeeBought(_id, msg.sender, _amount);
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
