//
//  TreeRoutingTable.swift
//  RouterKit
//
//  Created by Kang Chen on 2/21/16.
//
//

import Foundation

/**
 *  An efficient router that looks up registered routes by matching the
 *  individual path components using tree traversal.
 */
public struct TreeRoutingTable: RoutingTableType {
    private static let DefaultScheme = ""
    private var routes = [ComponentNode]()

    public func getRoute(scheme: String?, path: String) -> RequestHandler? {
        let scheme = scheme ?? TreeRoutingTable.DefaultScheme
        let schemeNode = getSchemeNode(scheme)
        if let root = schemeNode, let handler = self.findHandler(root, path: path) {
            return handler
        }
        return nil
    }

    /**
     Adds the handler to the given scheme and path. Overrides the existing handler if found.

     - parameter scheme:  The scheme or namespace to add under.
     - parameter path:    The path of the route.
     - parameter handler: Handler to invoke when an incoming request matches the scheme and route.
     */
    public mutating func addRoute(scheme: String?, path: String, handler: RequestHandler) {
        let schemeToSetUp = scheme ?? TreeRoutingTable.DefaultScheme
        setUpRoutesTableIfNecessary(scheme: schemeToSetUp)
        guard let schemeNode = getSchemeNode(schemeToSetUp) else {
            print("Routing table for scheme was not set up properly.")
            return
        }

        let pathComponents = path.pathComponents()
        self.addRoute(schemeNode, path: pathComponents, handler: handler)
    }
}

// MARK: Internal - Route Management
extension TreeRoutingTable {
    private mutating func setUpRoutesTableIfNecessary(scheme scheme: String) {
        let schemeIsNotInitialized = getSchemeNode(scheme) == nil
        if schemeIsNotInitialized {
            let schemeComponent = SchemeRouteComponent(rawComponent: scheme)
            let schemeNode = ComponentNode(component: schemeComponent, handler: .None, children: [])
            self.routes.append(schemeNode)
        }
    }

    private func getSchemeNode(scheme: String) -> ComponentNode? {
        let matchingSchemeNodes = self.routes.filter { (node) -> Bool in
            let routeComponent = node.component
            return routeComponent.match(scheme)
        }
        return matchingSchemeNodes.first
    }

    /**
     Adds the path and handler to the tree of `PathNode`s representing all registered paths.

     - parameter node:    Node to add path to. This could either be the root (scheme) node or other intermediate path nodes.
     - parameter path:    Tokenized path component matchers.
     - parameter handler: Handler to invoke when a request matches the route being added.
     */
    private mutating func addRoute(var pathNode: ComponentNode, path: [RouteComponentType], handler: RequestHandler) {
        if path.count > 0 {
            let nextPathComponent = path.first!
            let matchingChildNode = matchingPathComponent(pathComponent: nextPathComponent, inChildNodes: pathNode.children)
            if pathNode.isLeaf || matchingChildNode == nil {
                let nextPathNode = ComponentNode(component: nextPathComponent, handler: handler, children: [])
                let restOfPath = Array(path.dropFirst())
                addRoute(nextPathNode, path: restOfPath, handler: handler)
                pathNode.children.append(nextPathNode)
            } else {
                let restOfPath = Array(path.dropFirst())
                addRoute(matchingChildNode!, path: restOfPath, handler: handler)
            }
        }
    }

    private func matchingPathComponent(pathComponent pathComponent: RouteComponentType, inChildNodes: [ComponentNode]) -> ComponentNode? {
        return inChildNodes.filter { (node: ComponentNode) -> Bool in
            return node.component.dynamicType == pathComponent.dynamicType && node.component.rawComponent == pathComponent.rawComponent
            }.first
    }

    private func findHandler(schemeNode: ComponentNode, path: String) -> RequestHandler? {
        // does node match first token?
        // yes -> any other tokens? -> no -> return node.handler
        //                          -> yes -> check if any of the children matches rest of tokens
        // no -> just return nil
        var pathTokens = path.tokenizePath()
        var nodesToCheck = [schemeNode]
        var extractedParams = [String: String]()
        var possiblyMatchingHandler: RequestHandler? = nil

        while let node = nodesToCheck.popLast(), let token = pathTokens.first {
            if node.component.match(token) {
                // check its children to make sure this route matches the path
                nodesToCheck.appendContentsOf(node.children)
                pathTokens = Array(pathTokens.dropFirst())

                // save the extracted parameters so we can return all of them at the end
                let params = node.component.extractParameters(token)
                params.forEach({ (key, value) in
                    extractedParams[key] = value
                })

                // we might've looked at all the nodes and path tokens so save this
                // handler in case it's the one we want to return
                possiblyMatchingHandler = node.handler
            }
        }

        // it was only a match if all the path tokens were matched
        if nodesToCheck.isEmpty && pathTokens.isEmpty {
            let handlerWithParams = { (var request: Request) -> Response in
                request.parameters = extractedParams
                return possiblyMatchingHandler!(request)
            }
            return handlerWithParams
        } else {
            return nil
        }
    }
}
