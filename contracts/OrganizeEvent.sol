// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Error} from "./Libraries/Errors.sol";
import {EventAction} from "./Libraries/EventAction.sol";

contract OrganizeEvent {
    using EventAction for EventAction.Data;

    address NftAddress;
    uint256 public totalEvent;

    EventAction.Data private eventActions;

    constructor() {
        totalEvent = 0;
    }

    // For Manager
    function createEvent(
        address _NFTTokenAddress,
        string memory _name,
        string memory _venue,
        string memory _description,
        uint256 _startDate,
        uint256 _eventEndDate,
        uint256 _maxNumberOfRegistration
    ) external returns (EventAction.Event memory) {
        totalEvent++;
        EventAction.Event memory newEvent = eventActions.createEvent(
            totalEvent,
            _NFTTokenAddress,
            _name,
            _venue,
            _description,
            _startDate,
            _eventEndDate,
            _maxNumberOfRegistration
        );
        return newEvent;
    }

    function totalRegisteredEventMembers(
        uint eventId
    ) external view returns (address[] memory) {
        return eventActions.totalRegisteredEventMembers(eventId);
    }

    function registerForAnEvent(uint256 eventId, uint256 tokenId) external {
        eventActions.registerForAnEvent(eventId, tokenId);
    }

    function checkInForEvent(uint eventId, address _member) external {
        eventActions.checkInForEvent(eventId, _member);
    }
}
