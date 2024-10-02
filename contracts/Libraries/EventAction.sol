// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Error} from "./Errors.sol";

library EventAction {

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

    struct Data {
        mapping(uint256 => Event) events;
        mapping(address => mapping(uint256 => bool)) registeredUsers;
        mapping(uint256 => mapping(uint256 => address)) nftUsedForEvent; // Event ID => NFT ID => address (The address who use the token) Used or Not-Used.

    }

    function createEvent(
        Data storage self,
        uint256 totalEvent,
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

        Event storage ev = self.events[totalEvent];
        ev.id = totalEvent;
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
        Data storage self,
        uint eventId
    ) external view returns (address[] memory) {
        if (!isEventOwner(self, eventId)) {
            revert Error.NotTheEventManager();
        }

        if (self.events[eventId].id < 1) {
            revert Error.NotAValidEventId();
        }
        return self.events[eventId].attendees;
    }

    function registerForAnEvent(Data storage self, uint256 eventId, uint256 tokenId) external {
        
        if (self.events[eventId].maxNumberOfRegisteration == self.events[eventId].attendees.length) {
            revert Error.EventRegistrationClosed();
        }
        
        if (self.events[eventId].id < 1) {
            revert Error.NotAValidEventId();
        }

        if (self.registeredUsers[msg.sender][eventId]) {
            revert Error.AlreadyRegistered();
        }

        if (self.events[eventId].isClosed) {
            revert Error.EventIsClosed();
        }

        if (self.events[eventId].isCancelled) {
            revert Error.EventIsCancelled();
        }

        if (self.nftUsedForEvent[eventId][tokenId] != address(0)) {
            revert Error.NFTAlreadyUsed();
        }

        address NFTAddr = self.events[eventId].NFTTokenAddress;

        if (checkForNft(NFTAddr, msg.sender, tokenId)) {
            revert Error.YouDontHaveEventNFT();
        }


        self.events[eventId].attendees.push(msg.sender);
        self.registeredUsers[msg.sender][eventId] = true;
        self.nftUsedForEvent[eventId][tokenId] = msg.sender;
    }

    function checkInForEvent(
        Data storage self,
        uint eventId,
        address _member
    ) external returns (AttendantLog memory) {
        if (!isEventOwner(self, eventId)) {
            revert Error.NotTheEventManager();
        }
        if (self.events[eventId].id < 1) {
            revert Error.NotAValidEventId();
        }
        if (!self.registeredUsers[_member][eventId]) {
            revert Error.NotRegisteredForEvent();
        }
        AttendantLog memory newLog = AttendantLog({
            attendee: _member,
            checkInTime: block.timestamp
        });
        self.events[eventId].attendantLog.push(newLog);
        return newLog;
    }



    function checkForNft(
        address _NFTContractAddress,
        address user,
        uint256 tokenId
    ) public view returns (bool) {
        return IERC721(_NFTContractAddress).ownerOf(tokenId) == user;
    }


    function isEventOwner(Data storage self, uint256 _id) internal view returns (bool) {
        return self.events[_id].created_by != msg.sender;
    }

    function _isEmptyString(string memory str) internal pure returns (bool) {
        return bytes(str).length == 0;
    }
}