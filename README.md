# NFT Gated Event Smart Contract

This repository contains a smart contract called `OrganizeEvent`, which facilitates the creation and management of NFT-gated events on the Ethereum blockchain. The contract leverages OpenZeppelin’s ERC721 standard to restrict access to event registration and participation based on NFT ownership.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Functions](#functions)
    - [`createEvent`](#createevent)
    - [`totalRegisteredEventMembers`](#totalregisteredeventmembers)
    - [`registerForAnEvent`](#registerforanevent)
    - [`checkInForEvent`](#checkinforevent)
- [Libraries](#libraries)
- [Contributing](#contributing)
- [License](#license)

## Overview

The `OrganizeEvent` smart contract allows for the creation and registration of events that are accessible only to users who own a specific NFT. The contract supports multiple events and offers functionality for event registration, event check-ins, and tracking attendees based on NFT ownership.

## Features

- **NFT-Gated Access**: Users can only register for events if they own an NFT from the specified contract address.
- **Event Creation**: Authorized users (event managers) can create events with details like name, venue, description, and dates.
- **Event Registration**: Users can register for events using their NFTs.
- **Event Check-In**: Track user participation and attendance during the event.
- **Library-Based Logic**: Core event actions and error handling are managed using external libraries.

## Prerequisites

Before running or interacting with this smart contract, you must have the following:

- Node.js and npm (or yarn)
- Hardhat development environment
- Metamask (or any Ethereum-compatible wallet)
- An ERC721-compliant NFT smart contract deployed on the Ethereum blockchain
- Solidity version `^0.8.24`
- OpenZeppelin contracts installed via npm

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/nft-gated-event
   cd nft-gated-event
   ```
2. Install the required dependencies:
    ```
    npm install
    ```
3. Compile the contracts:
    ```
     npx hardhat compile
    ```
4. Deploy the smart contract to a local or test network:
    ```
    npx hardhat run scripts/deploy.js --network <network-name>
    ```
