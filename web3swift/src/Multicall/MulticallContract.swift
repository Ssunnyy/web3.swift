//
//  web3.swift
//  Copyright © 2022 Argent Labs Limited. All rights reserved.
//

import BigInt
import Foundation

public let multicallContainer = AppEnv.shared

public protocol MulticallAppEnvDelegate: AnyObject {
    func getEnvironmentIsDebug() -> Bool
}

open class AppEnv: NSObject {
    static var shared = AppEnv()
    public weak var multiCallDelegate: MulticallAppEnvDelegate?
}

extension Multicall {
    public enum Contract {
        case common
        static let goerliAddress: EthereumAddress = "0x77dCa2C955b15e9dE4dbBCf1246B4B85b651e50e"
        static let mainnetAddress: EthereumAddress = "0xF34D2Cb31175a51B23fb6e08cA06d7208FaD379F"
        var multicall2Address: EthereumAddress  {
            return  self.getEnvironmentDebug() ? EthereumAddress("0xaF20cB65A32e3ac0890A81191b9b211965f6A5cC") : EthereumAddress("0xfABB392F116420b817B639D59bDbfCBbC505487E")
        }
        
        public func getEnvironmentDebug() -> Bool {
            guard let debug = multicallContainer.multiCallDelegate?.getEnvironmentIsDebug() else {
                return true
            }
            return debug
        }

        public func registryAddress(for network: EthereumNetwork) -> EthereumAddress? {
            return  self.multicall2Address
//            switch network {
//            case .mainnet:
//                return Self.mainnetAddress
//            case .goerli:
//                return Self.goerliAddress
//            default:
//                return nil
//            }
        }

        public enum Functions {
            public struct aggregate: ABIMultiFunction {
                public var funcName: String = "aggregate"
                public static let name = "aggregate"
                public let gasPrice: BigUInt?
                public let gasLimit: BigUInt?
                public var contract: EthereumAddress
                public let from: EthereumAddress?
                public let calls: [Call]

                public init(
                    contract: EthereumAddress,
                    from: EthereumAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    calls: [Call]
                ) {
                    self.contract = contract
                    self.from = from
                    self.gasPrice = gasPrice
                    self.gasLimit = gasLimit
                    self.calls = calls
                }

                public func encode(to encoder: ABIFunctionEncoder) throws {
                    try encoder.encode(calls)
                }
            }

            public struct tryAggregate: ABIMultiFunction {
                public var funcName: String = "tryAggregate"
                public static let name = "tryAggregate"
                public let gasPrice: BigUInt?
                public let gasLimit: BigUInt?
                public var contract: EthereumAddress
                public let from: EthereumAddress?
                public let requireSuccess: Bool
                public let calls: [Call]

                public init(
                    contract: EthereumAddress,
                    from: EthereumAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    requireSuccess: Bool,
                    calls: [Call]
                ) {
                    self.contract = contract
                    self.gasPrice = gasPrice
                    self.gasLimit = gasLimit
                    self.from = from
                    self.requireSuccess = requireSuccess
                    self.calls = calls
                }

                public func encode(to encoder: ABIFunctionEncoder) throws {
                    try encoder.encode(requireSuccess)
                    try encoder.encode(calls)
                }
            }
        }
        
        
    }
    
   
}

