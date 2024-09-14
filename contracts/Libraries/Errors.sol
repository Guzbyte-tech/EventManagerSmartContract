// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library Error {
    error ZeroAddressDetected();
    error ZeroValueNotAllowed();
    error NotOwnerOfEvent();
    error DuplicateEventId();
    error InvalidEventName();
    error InvalidVenueName();
    error InvalidDescriptionName();
    error InvalidCreatedBy();
    // error InvalidStartDate();
    // error InvalidEventDate();
    error InvalidDateTime();
    error InvalidMaxNumber();
    error InvalidStartDate();
    error ZeroMaxRegistration();
    error InValidNFTAddress();
    error NotAValidEventId();
    error AlreadyRegistered();
    error YouDontHaveEventNFT();
    error EventIsClosed();
    error EventIsCancelled();
    error NotRegisteredForEvent();
    error NotTheEventManager();
    error EventRegistrationClosed();
    error NFTAlreadyUsed();
}
