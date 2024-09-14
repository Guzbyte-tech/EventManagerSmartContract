import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect } from "chai";
  import hre, { ethers } from "hardhat";

  describe('NFT Gated Event Contract', () => { 

        async function deployEvent () {
            const [contractOwner] = await hre.ethers.getSigners();
            const event = await hre.ethers.getContractFactory("OrganizeEvent");
            const eventManager = event.deploy();
            
            
            return {eventManager, contractOwner}
        }

        describe('Create an Event', () => { 
            it("Should check if address zero was detected", async function(){
                const { eventManager } = await loadFixture(deployEvent);
                const NftAddress = "0x251d6791163431C8A089620869c4cAFdDA50A4d4";

                // const event = eventManager.createEvent(1, NftAddress, "Web3 Lagos Conference", "Zone Avenue", "For Web3 Builders", toUnixTimestamp("2024-09-13 9:00:00"), toUnixTimestamp("2024-09-15 18:00:00"), 10).to.not.be.revertedWithCustomError("ZeroAddressDetected");
            });
        });

   });

function toUnixTimestamp(datetime: string): number {
    // Create a Date object from the input string
    const date = new Date(datetime);

    // Convert to Unix timestamp (seconds since 1970-01-01)
    const unixTimestamp = Math.floor(date.getTime() / 1000);

    return unixTimestamp;
}