//
//  Response.swift
//  RouterKit
//
//  Created by Kang Chen on 1/2/16.
//
//

import Foundation

/**
 *  Result of processing the incoming request.
 */
public struct Response {
    /**
     Status code indicating the status of handling the `RoutingRequest`.
     */
    public enum Status {
        /**
         *  Successfully handled the request.
         */
        case OK

        /**
         *  The request was malformed. See `Request`.
         */
        case BadRequest

        /**
         *  Missing valid authentication.
         */
        case Forbidden

        /**
         *  Requested route is not found.
         */
        case NotFound

        /**
         *  Missing required authorization.
         */
        case Unauthorized
        
        /**
         *  General error.
         */
        case Error
    }

    /// The original URL requested.
    public let url: NSURL

    /// Parameters that can be set during processing of the incoming request.
    public var parameters: [String: AnyObject]

    /// Result of processing the incoming request.
    public let status: Status

    public init(url: NSURL, status: Status, parameters: [String: AnyObject] = [String: AnyObject]()) {
        self.url = url
        self.status = status
        self.parameters = parameters
    }
}
