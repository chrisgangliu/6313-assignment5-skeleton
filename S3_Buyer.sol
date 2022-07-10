//<editable>
//</editable>
contract S3__Buyer is actorFSM {
    constructor() public {
owner = ownerAccounts['S3__Buyer'];
addToTransitions("Gateway_0c2ssha", "Buyer_Sign_Purchase_Document","","");
addToTransitions("Buyer_Sign_Purchase_Document", "SUCCESS","","");
addToTransitions("Seller_Sign_Purchase_Document", "SUCCESS","","");
State memory Buyer_Sign_Purchase_Document = State({
    STATEID: "Buyer_Sign_Purchase_Document",
    TYPE: "solid",
    conditions: "",
    LEVEL: 3,
    OUTPUTDATA: "",
    INPUTDATA: ""
});
states.push(Buyer_Sign_Purchase_Document);

        // ipfsAddr = ipfsActorAddresses['actor'];


    }
//<editable>
//</editable>
}