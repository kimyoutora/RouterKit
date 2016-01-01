//
//  Filter.swift
//  RouterKit
//
//  Created by Kang Chen on 2/21/16.
//
//

import Foundation

/**
 *  Middleware that can be registered to transform handlers.
 */
public protocol Filter {
    func apply(handler: RequestHandler) -> RequestHandler
}
