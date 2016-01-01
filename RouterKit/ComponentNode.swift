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
struct ComponentNode {
    var component: RouteComponentType
    var handler: RequestHandler?
    var children: [ComponentNode]

    var isLeaf: Bool {
        return self.children.isEmpty
    }
}
