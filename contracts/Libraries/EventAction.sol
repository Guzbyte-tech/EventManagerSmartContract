// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;
import { Error } from "./Errors.sol";

library EventAction {

    address NftAddress;
    uint256 public totalEvent;

     struct AttendantLog {
        address attendee;
        uint256 checkInTime;
    }

    struct Event {
        uint256 id;
        string name;
        string venue;
        string description;
        address created_by;
        uint256 eventStartDate;
        uint256 eventEndDate;
        uint256 created_at;
        uint256 maxNumberOfRegisteration;
        bool isClosed;
        bool isCancelled;
        address NFTTokenAddress;
        address[] attendees;
        AttendantLog[] attendantLog;
    }

    mapping(uint256 => Event) events;
    mapping(address => mapping(uint256 => bool)) registeredUsers;

    
    function createEvent(
        address _NFTTokenAddress,
        string memory _name,
        string memory _venue,
        string memory _description,
        uint256 _startDate,
        uint256 _eventEndDate,
        uint256 _maxNumberOfRegistration
    ) external returns (Event memory) {
        if (msg.sender == address(0)) {
            revert Error.ZeroAddressDetected();
        }
        if (_NFTTokenAddress == address(0)) {
            revert Error.InValidNFTAddress();
        }
        if (_isEmptyString(_name)) {
            revert Error.InvalidEventName();
        }
        if (_isEmptyString(_venue)) {
            revert Error.InvalidVenueName();
        }
        if (_isEmptyString(_description)) {
            revert Error.InvalidDescriptionName();
        }

        if (_startDate >= _eventEndDate) {
            revert Error.InvalidStartDate();
        }

        if (_maxNumberOfRegistration == 0) {
            revert Error.ZeroMaxRegistration();
        }
        uint eventId = totalEvent + 1;
        Event storage ev = events[eventId];
        ev.id = eventId;
        ev.name = _name;
        ev.venue = _venue;
        ev.description = _description;
        ev.created_by = msg.sender;
        ev.eventStartDate = _startDate;
        ev.eventEndDate = _eventEndDate;
        ev.created_at = block.timestamp;
        ev.NFTTokenAddress = _NFTTokenAddress;
        ev.maxNumberOfRegisteration = _maxNumberOfRegistration;
        totalEvent = eventId + 1;
        return ev;
    }

    function _isEmptyString(string memory str) internal pure returns (bool) {
        return bytes(str).length == 0;
    }


}