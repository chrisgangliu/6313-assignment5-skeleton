//<editable>
//</editable>
contract S3__Seller is actorFSM {
    constructor() public {
owner = ownerAccounts['S3__Seller'];
addToTransitions("Gateway_0c2ssha", "Seller_Sign_Purchase_Document","","");
State memory Seller_Sign_Purchase_Document = State({
    STATEID: "Seller_Sign_Purchase_Document",
    TYPE: "solid",
    conditions: "",
    LEVEL: 3,
    OUTPUTDATA: "",
    INPUTDATA: ""
});
states.push(Seller_Sign_Purchase_Document);

        // ipfsAddr = ipfsActorAddresses['actor'];


    }
//<editable>
//</editable>
}