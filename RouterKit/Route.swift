//
//  Route.swift
//  RouterKit
//
//  Created by Kang Chen on 2/21/16.
//
//

import Foundation

/// A definable route in the format of scheme://path/to e.g.
/// "app://users/A/profile".
/// @see `router.addRoute` for more supported formats.
public typealias Route = String

extension Route {
    func extractSchemeAndPath() -> (scheme: String?, path: String) {
        let components = self.componentsSeparatedByString("://")
        let scheme = components.count > 1 ? components.first : nil
        let path = components.last!
        return (scheme, path)
    }
}

public typealias Path = String

extension Path {
    func pathComponents() -> [RouteComponentType] {
        let components = self.tokenizePath()
        let pathComponents = components.map { (component) -> RouteComponentType in
            // TODO: handle regex components
            if component.hasPrefix(":") {
                return ParameterRouteComponent(rawComponent: component.substringWithRange(component.startIndex.advancedBy(1)..<component.endIndex))
            } else {
                return StaticRouteComponent(rawComponent: component)
            }
        }
        return pathComponents
    }

    func tokenizePath() -> [String] {
        let withoutWhitespace = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let withoutBeginningTrailingDelimiters = withoutWhitespace.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "/"))
        let components = withoutBeginningTrailingDelimiters.componentsSeparatedByString("/")
        switch components.first {
        case .Some(""): // empty path case, just return an empty array
            return []
        default:
            return components
        }
    }
}
