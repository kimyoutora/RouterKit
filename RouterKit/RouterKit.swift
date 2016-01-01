//
//  RouterKit.swift
//  RouterKit
//
//  Copyright © 2015 RouterKit. All rights reserved.
//

import Foundation

/**
 *  Entry point for registering routes and handling of incoming URL requests.
 */
public struct Router {
    private var routingTable: RoutingTableType

    // MARK: Init
    public init() {
        self.init(routingTable: TreeRoutingTable())
    }

    public init(routingTable: RoutingTableType) {
        self.routingTable = routingTable
    }

    // MARK: Add Routes

    /**
    Registers a class for use in handling URL requests for path.

    - parameter handlerClass: The handler you want to instantiate to handle the URL request.
    - parameter route:        The route to register.
    */
    public mutating func registerClass<T where T: RequestHandling>(handlerClass: T.Type, forRoute route: Route) {
        let handler = { (request: Request) -> Response in
            handlerClass.init().process(request)
        }
        addRoute(route, handler: handler)
    }

    /**
     Assigns the given handler to any incoming requests matching the
     route.

     - parameter route:   The route to register.
     - parameter handler: Block to invoke when there's a routing request to the mapped path.
     - returns: Boolean indicating whether the route was successfully registered.
     */
    public mutating func addRoute(route: Route, handler: RequestHandler) -> Bool {
        switch route.extractSchemeAndPath() {
        case let (scheme, path) where path.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0:
            self.routingTable.addRoute(scheme, path: path, handler: handler)
            return true
        default: return false
        }
    }

    // MARK: URL Handling

    /**
    Handle the incoming app request.

    - parameter url: The incoming app request likely from `application(_:url:options:)` but can also originate from other in-app endpoints.

    - returns: True if the router can handle the requested URL.
    */
    public func handleURL(url: NSURL) -> Bool {
        let request = Request(url: url)
        switch self.routingTable.getRoute(request.scheme, path: request.path) {
        case .Some(let handler):
            let response = handler(request)
            return response.status == Response.Status.OK // just return true iff it was processed
        default: return false
        }
    }

    var description: String {
        return "\(self.routingTable)"
    }
}

