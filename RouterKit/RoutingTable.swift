//
//  RoutingTable.swift
//  RouterKit
//
//  Created by Kang Chen on 1/2/16.
//
//

import Foundation

/**
 *  Protocol for the underlying route lookup table. Implement this to provide custom
 *  management of registered routes.
 */
public protocol RoutingTableType {
    mutating func addRoute(scheme: String?, path: String, handler: RequestHandler)
    func getRoute(scheme: String?, path: String) -> RequestHandler?
}
