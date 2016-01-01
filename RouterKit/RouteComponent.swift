//
//  RouteComponent.swift
//  Pods
//
//  Created by Kang Chen on 2/22/16.
//
//

import Foundation

public typealias RouteParameters = [String: String]

// MARK: RouteComponentType

/**
 *  A component of a route. For example, a path of "/users/123" has two components: ["users", "123"].
 */
public protocol RouteComponentType {
    /// The original component.
    var rawComponent: String { get }

    /**
     Checks to see if the given component

     - parameter component: The component to try matching.

     - returns: True if matches the given component
     */
    func match(component: String) -> Bool

    /**
     Extracts parameters from the component as described in the component type.
     */
    func extractParameters(component: String) -> RouteParameters
}

// MARK: StaticRouteComponent

/**
 *  A plain static string component.
 */
struct StaticRouteComponent: RouteComponentType {
    let rawComponent: String

    func match(component: String) -> Bool {
        return self.rawComponent == component
    }

    func extractParameters(component: String) -> RouteParameters {
        return [String: String]()
    }
}

// MARK: SchemeRouteComponent

typealias SchemeRouteComponent = StaticRouteComponent


// MARK: ParameterRouteComponent

/**
 *  A component representing a parameter placeholder e.g. /users/:username
 *  would match /users/foo with ["username": "foo"]
 */
struct ParameterRouteComponent: RouteComponentType {
    let rawComponent: String

    func match(component: String) -> Bool {
        return component.characters.count == 0 ? false : true
    }

    func extractParameters(component: String) -> RouteParameters {
        if component.isEmpty {
            return [String: String]()
        } else {
            return [self.rawComponent: component]
        }
    }
}
