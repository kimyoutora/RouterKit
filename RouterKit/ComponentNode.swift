//
//  ComponentNode.swift
//  RouterKit
//
//  Created by Kang Chen on 2/22/16.
//
//

import Foundation

/**
 *  Used internally by the `TreeRouter` to store the registered route component
 *  and their associated request handlers.
 */
class ComponentNode {
    var component: RouteComponentType
    var handler: RequestHandler?
    var children = [ComponentNode]()

    init(component: RouteComponentType, handler: RequestHandler? = nil) {
        self.component = component
        self.handler = handler
    }

    var isLeaf: Bool {
        return self.children.isEmpty
    }

    func addChild(node: ComponentNode) {
        self.children.append(node)
    }

    var debugDescription: String {
        return "\(self.dynamicType): component: \(self.component), handler: \(self.handler)\nchildren: \(self.children)"
    }
}
