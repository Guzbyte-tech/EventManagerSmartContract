// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Error} from "./Libraries/Errors.sol";

contract EventManager {
    address NftAddress;
    uint256 public totalEvent;

    constructor() {}

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

    // For Manager

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
        return ev;
    }

    function totalRegisteredEventMembers(
        uint eventId
    ) external view returns (address[] memory) {
        if (!isEventOwner(eventId)) {
            revert Error.NotTheEventManager();
        }

        if (events[eventId].id < 1) {
            revert Error.NotAValidEventId();
        }
        return events[eventId].attendees;
    }

    function registerForAnEvent(uint256 eventId) external {
        if (events[eventId].id < 1) {
            revert Error.NotAValidEventId();
        }

        if (registeredUsers[msg.sender][eventId]) {
            revert Error.AlreadyRegistered();
        }

        if (events[eventId].isClosed) {
            revert Error.EventIsClosed();
        }

        if (events[eventId].isCancelled) {
            revert Error.EventIsCancelled();
        }

        address NFTAddr = events[eventId].NFTTokenAddress;
        if (checkForNft(NFTAddr, msg.sender) < 1) {
            revert Error.YouDontHaveEventNFT();
        }
        events[eventId].attendees.push(msg.sender);
    }

    function checkInForEvent(
        uint eventId,
        address _member
    ) external returns (AttendantLog memory) {
        if (!isEventOwner(eventId)) {
            revert Error.NotTheEventManager();
        }
        if (events[eventId].id < 1) {
            revert Error.NotAValidEventId();
        }
        if (!registeredUsers[_member][eventId]) {
            revert Error.NotRegisteredForEvent();
        }
        AttendantLog memory newLog = AttendantLog({
            attendee: _member,
            checkInTime: block.timestamp
        });
        events[eventId].attendantLog.push(newLog);
        return newLog;
    }

    function _isEmptyString(string memory str) internal pure returns (bool) {
        return bytes(str).length == 0;
    }

    function checkForNft(
        address _NFTContractAddress,
        address user
    ) public view returns (uint) {
        return IERC721(_NFTContractAddress).balanceOf(user);
    }

    function isEventOwner(uint256 _id) internal view returns (bool) {
        return events[_id].created_by == msg.sender;
    }
}
