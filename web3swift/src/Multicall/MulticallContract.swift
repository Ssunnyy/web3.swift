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
        var matchMulticallAddress: EthereumAddress  { // 9001
            return  self.getEnvironmentDebug() ? EthereumAddress("0xaF20cB65A32e3ac0890A81191b9b211965f6A5cC") : EthereumAddress("0xfABB392F116420b817B639D59bDbfCBbC505487E")
        }
        
        var tomoMulticallAddress: EthereumAddress  { // 88
            return   EthereumAddress("0xE498F5Eb9403Fe5dbd1Fc2aCDa4799A175C2dcF2")
        }
        
        var openBNBMulticallAddress: EthereumAddress { // 204
            return  self.getEnvironmentDebug() ?  EthereumAddress("0x6443cB3682364722d10D7930302ADCC5daF84F79") :  EthereumAddress("0xE76d04A96Eb67f75d2Fc5d2b17f22f79b11ce902")
        }
        var polygonMulticallAddress: EthereumAddress { // 137
            return "0xcA11bde05977b3631167028862bE2a173976CA11"
        }
        
        
        public func getEnvironmentDebug() -> Bool {
            guard let debug = multicallContainer.multiCallDelegate?.getEnvironmentIsDebug() else {
                return true
            }
            return debug
        }

        public func registryAddress(for network: EthereumNetwork) -> EthereumAddress? {
            switch network {
            case .custom(let str):
                if str == "9001" {
                    return matchMulticallAddress
                } else if str == "88" {
                    return tomoMulticallAddress
                } else if str == "204" {
                    return openBNBMulticallAddress
                } else if str == "137" {
                    return polygonMulticallAddress
                }
            default:
                return nil
            }
            return nil
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



