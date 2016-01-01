//
//  Handler.swift
//  RouterKit
//
//  Created by Kang Chen on 1/2/16.
//
//

import Foundation

/// Closure to invoke on a valid incoming request.
public typealias RequestHandler = (Request) -> Response

/**
 *  Protocol for handlers that can be registered and initialized to handle a `Request`.
 */
public protocol RequestHandling {
    /**
     Default initializer for instantiating a handler that can process
     requests.

     - returns: Fully initialized handler.
     */
    init()

    /**
     Processes the incoming request and returns a response.

     - parameter request: The incoming request.

     - returns: Response as a result of processing the incoming request.
     */
    func process(request: Request) -> Response
}
