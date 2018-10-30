//
//  NetworkReachability.swift
//  Placer
//
//  Created by Group10 on 12/10/17.
//  Copyright © 2017 Group10. All rights reserved.
//

import Foundation
import Foundation
import SystemConfiguration

public class NetworkReachability {
    
    
    
    static  func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //    class func isConnectedToNetwork() -> Bool {
    //
    //        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    //        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    //        zeroAddress.sin_family = sa_family_t(AF_INET)
    //
    //        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
    //            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
    //        }
    //
    //        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    //        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
    //            return false
    //        }
    //
    //        let isReachable = flags == .reachable
    //        let needsConnection = flags == .connectionRequired
    //
    //        return isReachable && !needsConnection
    //        
    //    }
}
