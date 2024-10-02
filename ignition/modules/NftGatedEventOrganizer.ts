import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const NftGatedEventOrganizerModule = buildModule("NftGatedEventOrganizerModule", (m) => {

   // Deploy the EventAction library first
   const EventAction = m.library("EventAction");

   

  const NftGatedEventOrganizer = m.contract("NftGatedEventOrganizer", [], {
    libraries: {
      EventAction: EventAction
    }
  });

  return { NftGatedEventOrganizer };

});

export default NftGatedEventOrganizerModule;
