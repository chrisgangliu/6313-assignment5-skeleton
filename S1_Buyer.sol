//<editable>
//</editable>
contract S1__Buyer is actorFSM {
    constructor() public {
owner = ownerAccounts['S1__Buyer'];
addToTransitions("INIT", "Prepare_Purchase_Document","","");
addToTransitions("Prepare_Purchase_Document", "Gateway_0c2ssha","","");
State memory Prepare_Purchase_Document = State({
    STATEID: "Prepare_Purchase_Document",
    TYPE: "solid",
    conditions: "",
    LEVEL: 1,
    OUTPUTDATA: "",
    INPUTDATA: ""
});
states.push(Prepare_Purchase_Document);

        // ipfsAddr = ipfsActorAddresses['actor'];


    }
//<editable>
//</editable>
}