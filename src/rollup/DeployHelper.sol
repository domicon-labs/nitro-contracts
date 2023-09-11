// Copyright 2021-2022, Offchain Labs, Inc.
// For license information, see https://github.com/OffchainLabs/nitro-contracts/blob/main/LICENSE
// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;

import {IInbox} from "../bridge/IInbox.sol";
import {IInboxBase} from "../bridge/IInboxBase.sol";
import {IERC20Bridge} from "../bridge/IERC20Bridge.sol";
import {IERC20Inbox} from "../bridge/ERC20Inbox.sol";

/// @notice Helper contract for deploying some keyless deployment to Arbitrum using delayed inbox
contract DeployHelper {
    // All payload are padded with 0x04 (ArbOS L2MessageKind_SignedTx Type)

    // Nick's CREATE2 Deterministic Deployment Proxy
    // https://github.com/Arachnid/deterministic-deployment-proxy
    address public constant NICK_CREATE2_DEPLOYER = 0x3fAB184622Dc19b6109349B94811493BF2a45362;
    uint256 public constant NICK_CREATE2_VALUE = 0.01 ether;
    bytes public constant NICK_CREATE2_PAYLOAD =
        hex"04f8a58085174876e800830186a08080b853604580600e600039806000f350fe7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe03601600081602082378035828234f58015156039578182fd5b8082525050506014600cf31ba02222222222222222222222222222222222222222222222222222222222222222a02222222222222222222222222222222222222222222222222222222222222222";

    // ERC-2470 Singleton Factory
    // https://eips.ethereum.org/EIPS/eip-2470
    address public constant ERC2470_DEPLOYER = 0xBb6e024b9cFFACB947A71991E386681B1Cd1477D;
    uint256 public constant ERC2470_VALUE = 0.0247 ether;
    bytes public constant ERC2470_PAYLOAD =
        hex"04f9016c8085174876e8008303c4d88080b90154608060405234801561001057600080fd5b50610134806100206000396000f3fe6080604052348015600f57600080fd5b506004361060285760003560e01c80634af63f0214602d575b600080fd5b60cf60048036036040811015604157600080fd5b810190602081018135640100000000811115605b57600080fd5b820183602082011115606c57600080fd5b80359060200191846001830284011164010000000083111715608d57600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550509135925060eb915050565b604080516001600160a01b039092168252519081900360200190f35b6000818351602085016000f5939250505056fea26469706673582212206b44f8a82cb6b156bfcc3dc6aadd6df4eefd204bc928a4397fd15dacf6d5320564736f6c634300060200331b83247000822470";

    // Zoltu's CREATE2 Deterministic Deployment Proxy
    // https://github.com/Zoltu/deterministic-deployment-proxy
    address public constant ZOLTU_CREATE2_DEPLOYER = 0x4c8D290a1B368ac4728d83a9e8321fC3af2b39b1;
    uint256 public constant ZOLTU_VALUE = 0.01 ether;
    bytes public constant ZOLTU_CREATE2_PAYLOAD =
        hex"04f87e8085174876e800830186a08080ad601f80600e600039806000f350fe60003681823780368234f58015156014578182fd5b80825250506014600cf31ba02222222222222222222222222222222222222222222222222222222222222222a02222222222222222222222222222222222222222222222222222222222222222";

    // ERC-1820: Pseudo-introspection Registry Contract
    // https://eips.ethereum.org/EIPS/eip-1820
    address public constant ERC1820_DEPLOYER = 0xa990077c3205cbDf861e17Fa532eeB069cE9fF96;
    uint256 public constant ERC1820_VALUE = 0.08 ether;
    bytes public constant ERC1820_PAYLOAD =
        hex"04f90a388085174876e800830c35008080b909e5608060405234801561001057600080fd5b506109c5806100206000396000f3fe608060405234801561001057600080fd5b50600436106100a5576000357c010000000000000000000000000000000000000000000000000000000090048063a41e7d5111610078578063a41e7d51146101d4578063aabbb8ca1461020a578063b705676514610236578063f712f3e814610280576100a5565b806329965a1d146100aa5780633d584063146100e25780635df8122f1461012457806365ba36c114610152575b600080fd5b6100e0600480360360608110156100c057600080fd5b50600160a060020a038135811691602081013591604090910135166102b6565b005b610108600480360360208110156100f857600080fd5b5035600160a060020a0316610570565b60408051600160a060020a039092168252519081900360200190f35b6100e06004803603604081101561013a57600080fd5b50600160a060020a03813581169160200135166105bc565b6101c26004803603602081101561016857600080fd5b81019060208101813564010000000081111561018357600080fd5b82018360208201111561019557600080fd5b803590602001918460018302840111640100000000831117156101b757600080fd5b5090925090506106b3565b60408051918252519081900360200190f35b6100e0600480360360408110156101ea57600080fd5b508035600160a060020a03169060200135600160e060020a0319166106ee565b6101086004803603604081101561022057600080fd5b50600160a060020a038135169060200135610778565b61026c6004803603604081101561024c57600080fd5b508035600160a060020a03169060200135600160e060020a0319166107ef565b604080519115158252519081900360200190f35b61026c6004803603604081101561029657600080fd5b508035600160a060020a03169060200135600160e060020a0319166108aa565b6000600160a060020a038416156102cd57836102cf565b335b9050336102db82610570565b600160a060020a031614610339576040805160e560020a62461bcd02815260206004820152600f60248201527f4e6f7420746865206d616e616765720000000000000000000000000000000000604482015290519081900360640190fd5b6103428361092a565b15610397576040805160e560020a62461bcd02815260206004820152601a60248201527f4d757374206e6f7420626520616e204552433136352068617368000000000000604482015290519081900360640190fd5b600160a060020a038216158015906103b85750600160a060020a0382163314155b156104ff5760405160200180807f455243313832305f4143434550545f4d4147494300000000000000000000000081525060140190506040516020818303038152906040528051906020012082600160a060020a031663249cb3fa85846040518363ffffffff167c01000000000000000000000000000000000000000000000000000000000281526004018083815260200182600160a060020a0316600160a060020a031681526020019250505060206040518083038186803b15801561047e57600080fd5b505afa158015610492573d6000803e3d6000fd5b505050506040513d60208110156104a857600080fd5b5051146104ff576040805160e560020a62461bcd02815260206004820181905260248201527f446f6573206e6f7420696d706c656d656e742074686520696e74657266616365604482015290519081900360640190fd5b600160a060020a03818116600081815260208181526040808320888452909152808220805473ffffffffffffffffffffffffffffffffffffffff19169487169485179055518692917f93baa6efbd2244243bfee6ce4cfdd1d04fc4c0e9a786abd3a41313bd352db15391a450505050565b600160a060020a03818116600090815260016020526040812054909116151561059a5750806105b7565b50600160a060020a03808216600090815260016020526040902054165b919050565b336105c683610570565b600160a060020a031614610624576040805160e560020a62461bcd02815260206004820152600f60248201527f4e6f7420746865206d616e616765720000000000000000000000000000000000604482015290519081900360640190fd5b81600160a060020a031681600160a060020a0316146106435780610646565b60005b600160a060020a03838116600081815260016020526040808220805473ffffffffffffffffffffffffffffffffffffffff19169585169590951790945592519184169290917f605c2dbf762e5f7d60a546d42e7205dcb1b011ebc62a61736a57c9089d3a43509190a35050565b600082826040516020018083838082843780830192505050925050506040516020818303038152906040528051906020012090505b92915050565b6106f882826107ef565b610703576000610705565b815b600160a060020a03928316600081815260208181526040808320600160e060020a031996909616808452958252808320805473ffffffffffffffffffffffffffffffffffffffff19169590971694909417909555908152600284528181209281529190925220805460ff19166001179055565b600080600160a060020a038416156107905783610792565b335b905061079d8361092a565b156107c357826107ad82826108aa565b6107b85760006107ba565b815b925050506106e8565b600160a060020a0390811660009081526020818152604080832086845290915290205416905092915050565b6000808061081d857f01ffc9a70000000000000000000000000000000000000000000000000000000061094c565b909250905081158061082d575080155b1561083d576000925050506106e8565b61084f85600160e060020a031961094c565b909250905081158061086057508015155b15610870576000925050506106e8565b61087a858561094c565b909250905060018214801561088f5750806001145b1561089f576001925050506106e8565b506000949350505050565b600160a060020a0382166000908152600260209081526040808320600160e060020a03198516845290915281205460ff1615156108f2576108eb83836107ef565b90506106e8565b50600160a060020a03808316600081815260208181526040808320600160e060020a0319871684529091529020549091161492915050565b7bffffffffffffffffffffffffffffffffffffffffffffffffffffffff161590565b6040517f01ffc9a7000000000000000000000000000000000000000000000000000000008082526004820183905260009182919060208160248189617530fa90519096909550935050505056fea165627a7a72305820377f4a2d4301ede9949f163f319021a6e9c687c292a5e2b2c4734c126b524e6c00291ba01820182018201820182018201820182018201820182018201820182018201820a01820182018201820182018201820182018201820182018201820182018201820";

    uint256 internal constant GASLIMIT = 100_000;

    function _fundAndDeploy(
        address inbox,
        uint256 _value,
        address _l2Address,
        bytes memory payload,
        bool _isUsingFeeToken,
        uint256 maxFeePerGas
    ) internal {
        uint256 submissionCost = IInboxBase(inbox).calculateRetryableSubmissionFee(
            0,
            block.basefee
        );
        uint256 feeAmount = _value + submissionCost + GASLIMIT * maxFeePerGas;

        // fund the target L2 address
        if (_isUsingFeeToken) {
            IERC20Inbox(inbox).createRetryableTicket({
                to: _l2Address,
                l2CallValue: _value,
                maxSubmissionCost: submissionCost,
                excessFeeRefundAddress: msg.sender,
                callValueRefundAddress: msg.sender,
                gasLimit: GASLIMIT,
                maxFeePerGas: maxFeePerGas,
                tokenTotalFeeAmount: feeAmount,
                data: ""
            });
        } else {
            IInbox(inbox).createRetryableTicket{value: feeAmount}({
                to: _l2Address,
                l2CallValue: _value,
                maxSubmissionCost: submissionCost,
                excessFeeRefundAddress: msg.sender,
                callValueRefundAddress: msg.sender,
                gasLimit: GASLIMIT,
                maxFeePerGas: maxFeePerGas,
                data: ""
            });
        }
        // send L2 msg to execute deployment transaction
        IInboxBase(inbox).sendL2Message(payload);
    }

    function perform(
        address _inbox,
        address _nativeToken,
        uint256 _maxFeePerGas
    ) external payable {
        bool isUsingFeeToken = _nativeToken != address(0);

        _fundAndDeploy(
            _inbox,
            NICK_CREATE2_VALUE,
            NICK_CREATE2_DEPLOYER,
            NICK_CREATE2_PAYLOAD,
            isUsingFeeToken,
            _maxFeePerGas
        );
        _fundAndDeploy(
            _inbox,
            ERC2470_VALUE,
            ERC2470_DEPLOYER,
            ERC2470_PAYLOAD,
            isUsingFeeToken,
            _maxFeePerGas
        );
        _fundAndDeploy(
            _inbox,
            ZOLTU_VALUE,
            ZOLTU_CREATE2_DEPLOYER,
            ZOLTU_CREATE2_PAYLOAD,
            isUsingFeeToken,
            _maxFeePerGas
        );
        _fundAndDeploy(
            _inbox,
            ERC1820_VALUE,
            ERC1820_DEPLOYER,
            ERC1820_PAYLOAD,
            isUsingFeeToken,
            _maxFeePerGas
        );

        // if paying with ETH refund the caller
        if (!isUsingFeeToken) {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function getDeploymentTotalCost(IInboxBase inbox, uint256 maxFeePerGas)
        public
        view
        returns (uint256)
    {
        uint256 submissionCost = inbox.calculateRetryableSubmissionFee(0, block.basefee);
        return
            NICK_CREATE2_VALUE +
            ERC2470_VALUE +
            ZOLTU_VALUE +
            ERC1820_VALUE +
            4 *
            (submissionCost + GASLIMIT * maxFeePerGas);
    }
}
