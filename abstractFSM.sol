// pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;
//</editable>
contract actorFSM {
    string ipfsAddr;
    // amount of actors;
    // int actorsAmount;
    // actor defined states
    State[] states;
    // actor defined transitions
    Transition[] transitions;
    // actors array
    string[] actors;
    // owners array
    string[] owners;
    // external data array
    string[] externalData;
    // signatures array
    signaturee[] signatures;
    //address of the owner (who deployed the contract)
    address public owner;
    // transaction id => State: current active state
    mapping(string => string) currentStates;
    // actor IPFS address with the public keys;
    mapping(string => string) ipfsPublicKeys;
    // record actor mapping to the IPFS address
    mapping(string => string) ipfsActorAddresses;
    // record actor mapping to the actor accounts address on mainchain
    mapping(string => address) actorAccounts;
    // record actor mapping to the smart contract owner accounts address on different blockchains
    mapping(string => address) ownerAccounts;
    // record the smart contract owner to actor
    mapping(string => string) ownerToActor;
    // record the smart contract owner to actor
    // mapping(string => string) externalDataToSignature;
//<editable>




//</editable>
    constructor() public {
ownerAccounts['S1__Buyer'] = address(0x60684acf45B99ED7eFf2AC0FA2Db829feA0883C2);
owners.push("S1__Buyer");
ownerToActor['S1__Buyer'] = "Buyer";
actorAccounts['Buyer'] = address(0xEE69ed07b62Ef7Fce9aE72048d3bb6dD64Ab35E7);
actors.push("Buyer");
ownerAccounts['S3__Buyer'] = address(0xB040933b0955da47b9729aee15d4a046F516a917);
owners.push("S3__Buyer");
ownerToActor['S3__Buyer'] = "Buyer";
ownerAccounts['S3__Seller'] = address(0x61Bf5528CAcd434D26d4173CcE3B22617fE67ACF);
owners.push("S3__Seller");
ownerToActor['S3__Seller'] = "Seller";
actorAccounts['Seller'] = address(0x0388CeE553325BCbc64512E2c460C5f539522d1E);
actors.push("Seller");
ownerAccounts['partial_on_chain'] = address(0xE64AfDAd2A3966ecBB9B9bffBaB9cdd2154F6d69);
owners.push("partial_on_chain");
actors.push("partial_on_chain");
ownerToActor['partial_on_chain'] = "partial_on_chain";
ownerAccounts['total_on_chain'] = address(0x1786B293A1Ee374C3fF2CA24d563f5270aE500e7);
owners.push("total_on_chain");
actors.push("total_on_chain");
ownerToActor['total_on_chain'] = "total_on_chain";


        //<editable>

//</editable>
    }

    struct State {
        // If you can limit the length to a certain number of bytes,
        // always use one of bytes1 to bytes32 because they are much cheaper
        //bytes32 name;   // short name (up to 32 bytes)
        string STATEID; // identification of state
        // string LABEL;
        // string ipfsStateAddress;
        string TYPE; // normal, exclustive, inclusive, parallel
        // contract becomes too big to be deployed on blocchain, link input, output and actors info to ipfsStateAddress
        // string INPUT; // multiple FROMEDGES seperated by ;
        // string OUTPUT; // multiple TOEDGES seperated by ;
        string INPUTDATA; // multiple FROMEDGES seperated by ;
        string OUTPUTDATA; // multiple TOEDGES seperated by ;
        // string actors;
        string conditions; // formats: LARGER number:output1;EQUAL number/string:output2;LESS number:output3
        // string[4] FROMEDGES;
        // string[4] TOEDGES;
        int256 LEVEL;
    }

    struct Transition {
        string FROM;
        string TO;
        string INPUT;
        string TYPE;
    }

    struct signaturee {
        string workflowid;
        string document;
        string sig;
    }

    function stringToBytes32(string memory source)
        public
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function compareStringsbyBytes(string memory s1, string memory s2)
        public
        pure
        returns (bool)
    {
        return
            keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }

    function findStateById(string memory id)
        internal
        view
        returns (State memory result)
    {
        for (uint256 i = 0; i < states.length; i++) {
            if (compareStringsbyBytes(states[i].STATEID, id)) {
                result = states[i];
            }
        }
    }

    function findTransitionByFromAndTo(string memory fro, string memory to)
        internal
        view
        returns (bool, uint256)
    {
        for (uint256 i = 0; i < transitions.length; i++) {
            if (compareStringsbyBytes(transitions[i].FROM, fro)) {
                if (compareStringsbyBytes(transitions[i].TO, to)) {
                    return (true, i);
                }
            }
        }
        return (false, 0);
    }

    function findNextStates(string memory id)
        internal
        view
        returns (string memory)
    {
        uint256 found = 0;
        string memory tempResults = "";
        for (uint256 i = 0; i < transitions.length; i++) {
            if (compareStringsbyBytes(transitions[i].FROM, id)) {
                found++;
                tempResults = string(
                    abi.encodePacked(tempResults, ",", transitions[i].TO)
                );
            }
        }
        return tempResults;
    }

    event FSMStateTransition(string t);

    /**
     * @dev attest encryted data
     * @param referenceAddress the reference address used to be compared with..
     * @param _message h = web3.utils.soliditySha3(document);signature = await web3.eth.sign(h, defaultAcc);
     * @param _v "0x" + signature.slice(130, 132); web3.utils.toDecimal(v); v + 27;
     * @param _r signature.slice(0, 66);
     * @param _s "0x" + signature.slice(66, 130);
     */
    function attestSignature(
        address referenceAddress,
        string memory _message,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public pure {
        address signer = recoverSignature(_message, _v, _r, _s);
        require(
            signer == referenceAddress,
            "Invalid signature."
        );
    }

// externalDataToSignature

// function 1: push one signature to externalDataToSignature
// struct signature {
//         string workflowid;
//         string document;
//         string sig;
//     }
    function addToSignatures(
        string memory _id,
        string memory _doc,
        string memory _sig
    ) public {
        signatures.push(
            signaturee({workflowid: _id, document: _doc, sig: _sig})
        );
    }

// function 2: return a list Signatures by externalData
    function getSignatures(
        string memory _id,
        string memory _doc
        ) public view
        returns (string[] memory)
    {
        uint256 found = 0;
        string[] memory tempResults;
        for (uint256 i = 0; i < signatures.length; i++) {
            signaturee memory oneSig = signatures[i];
            string memory ___id = oneSig.workflowid;
            string memory ___doc = oneSig.document;
            string memory ___sig = oneSig.sig;
            if (compareStringsbyBytes(_id, ___id) && compareStringsbyBytes(_doc, ___doc)) {
                tempResults[found]=___sig;
                found++;
            }
        }
        return tempResults;
    }

// externalDataToSignature
    /**
     * @dev recover encryted data
     * @param message h = web3.utils.soliditySha3(document);signature = await web3.eth.sign(h, defaultAcc);
     * @param v "0x" + signature.slice(130, 132); web3.utils.toDecimal(v); v + 27;
     * @param r signature.slice(0, 66);
     * @param s "0x" + signature.slice(66, 130);
     */
    function recoverSignature(string memory message, uint8 v, bytes32 r,
                 bytes32 s) public pure returns (address signer) {

        // The message header; we will fill in the length next
        string memory header = "\x19Ethereum Signed Message:\n000000";

        uint256 lengthOffset;
        uint256 length;
        assembly {
            // The first word of a string is its length
            length := mload(message)
            // The beginning of the base-10 message length in the prefix
            lengthOffset := add(header, 57)
        }

        // Maximum length we support
        require(length <= 999999);

        // The length of the message's length in base-10
        uint256 lengthLength = 0;

        // The divisor to get the next left-most message length digit
        uint256 divisor = 100000;

        // Move one digit of the message length to the right at a time
        while (divisor != 0) {

            // The place value at the divisor
            uint256 digit = length / divisor;
            if (digit == 0) {
                // Skip leading zeros
                if (lengthLength == 0) {
                    divisor /= 10;
                    continue;
                }
            }

            // Found a non-zero digit or non-leading zero digit
            lengthLength++;

            // Remove this digit from the message length's current value
            length -= digit * divisor;

            // Shift our base-10 divisor over
            divisor /= 10;

            // Convert the digit to its ASCII representation (man ascii)
            digit += 0x30;
            // Move to the next character and write the digit
            lengthOffset++;

            assembly {
                mstore8(lengthOffset, digit)
            }
        }

        // The null string requires exactly 1 zero (unskip 1 leading 0)
        if (lengthLength == 0) {
            lengthLength = 1 + 0x19 + 1;
        } else {
            lengthLength += 1 + 0x19;
        }

        // Truncate the tailing zeros from the header
        assembly {
            mstore(header, lengthLength)
        }

        // Perform the elliptic curve recover operation
        bytes32 check = keccak256(abi.encodePacked(header, message));

        return ecrecover(check, v, r, s);
    }

    //the major function to recieve the state changes
    function resvStateChanges(
        string memory transactionId,
        string memory stateid,
        string memory newStateid,
        string memory input,
        string memory encyptedMsg
    )
        public
        validateTransactionAndActiveState(
            transactionId,
            stateid,
            newStateid,
            input,
            encyptedMsg
        )
    {
        // actor privte key sign their own IPFS address, then smart contract use their public key to verify those signed address.
        currentStates[transactionId] = newStateid;
        string memory tString =
            string(
                abi.encodePacked(
                    ipfsAddr,
                    ",",
                    transactionId,
                    ",",
                    stateid,
                    ",",
                    newStateid,
                    ",",
                    encyptedMsg
                )
            );

        emit FSMStateTransition(tString);
        // return tString;
    }

    // verification and validation
    //     (1)  Private Signature and public verification:
    // Smart contract stores the public keys of all actors for verification purpose;
    // The submission is signed by all required actors’ signatures with their private keys;

    // (2)  Current transaction verification:
    // Because our actor FSM model provides asynchronous mechanism, there probably more than one transaction executed in paraelle. Therefore, smart contract should be able to distinguish current transaction submission from other ongoing transactions.
    // fail earlier and fail loudly

    modifier validateTransactionAndActiveState(
        string memory transactionId,
        string memory stateid,
        string memory newStateid,
        string memory input,
        string memory encyptedMsg
    ) {
        // bytes memory tempinput= bytes(input); // Uses memory
        (bool result, uint256 index) = findTransitionByFromAndTo(stateid, newStateid);
        //<failearlier>
        require(
            compareStringsbyBytes(currentStates[transactionId], stateid) ||
                compareStringsbyBytes("testing", stateid),
            "the transaction is not on the same status."
        );
        require(
            compareStringsbyBytes("testing", input) || (result && compareStringsbyBytes(transitions[index].INPUT,input)),
            "the tranision input does not match."
        );
        //</failearlier>
        _;
    }

    function addToStates(
        string memory id,
        // string memory label,
        // string memory ipfsStateAddress,
        string memory typ,
        string memory input,
        string memory output,
        // string memory acts,
        string memory conditions, // formats: LARGER number:output1;EQUAL number/string:output2;LESS number:output3
        // string[4] memory incomes,
        // string[4] memory outgoings,
        int256 lvl
    ) public onlyOwner {
        states.push(
            State({
                STATEID: id,
                // LABEL: label,
                // ipfsStateAddress: ipfsStateAddress,
                TYPE: typ,
                INPUTDATA: input, // multiple FROMEDGES seperated by ;
                OUTPUTDATA: output, // multiple TOEDGES seperated by ;
                conditions: conditions,

                LEVEL: // FROMEDGES: incomes,
                // TOEDGES: outgoings,

                lvl
            })
        );
    }

    function addToTransitions(
        string memory fro,
        string memory to,
        string memory input,
        string memory typ
    ) public onlyOwner {
        transitions.push(
            Transition({FROM: fro, TO: to, INPUT: input, TYPE: typ})
        );
    }

   /**
     * @dev getXactionFromXactionAccount
     * @param xactionAccount account of subgraph
     */
    function getXactionFromXactionAccount(
        address  xactionAccount
    ) public view returns (string memory) {
        string memory xactionName = "";
        for (uint i=0; i<owners.length; i++) {
            if (xactionAccount == ownerAccounts[owners[i]]) {
                xactionName=owners[i];
                break;
            }
        }
        return xactionName;
    }

    /**
     * @dev getActorFromXactionAccount
     * @param xactionAccount account of subgraph
     */
    function getActorFromXactionAccount(
        address  xactionAccount
    ) public view returns (string memory) {
        string memory xactionName = "";
        for (uint i=0; i<owners.length; i++) {
            if (xactionAccount == ownerAccounts[owners[i]]) {
                xactionName=owners[i];
                break;
            }
        }
        return ownerToActor[xactionName];
    }

    /**
     * @dev getActorAccountFromActor
     * @param actorname actorname
     */
    function getActorAccountFromActor(
        string memory actorname
    ) public view returns (address) {
        return actorAccounts[actorname];
    }

    /**
     * @dev getXactionAccountFromXaction
     * @param xactionName collaborative transaction name
     */
    function getXactionAccountFromXaction(
        string memory xactionName
    ) public view returns (address) {
        return ownerAccounts[xactionName];
    }

    /**
     * @dev getActorFromXaction
     * @param xactionName collaborative transaction name
     */
    function getActorFromXaction(
        string memory xactionName
    ) public view returns (string memory) {
        return ownerToActor[xactionName];
    }

    // This contract only defines a modifier but does not use
    // it: it will be used in derived contracts.
    // The function body is inserted where the special symbol
    // `_;` in the definition of a modifier appears.
    // This means that if the owner calls this function, the
    // function is executed and otherwise, an exception is
    // thrown.
    modifier onlyOwner {
        // require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    //<editable>




//</editable>
}
