//
//  TreeRoutingTableSpec.swift
//  RouterKit
//
//  Created by Kang Chen on 2/27/16.
//  Copyright © 2016 RouterKit. All rights reserved.
//

import Nimble
import Quick
@testable import RouterKit

class TreeRoutingTableSpec: QuickSpec {
    override func spec() {
        var routingTable: TreeRoutingTable!
        let handler = { (req: Request) -> Response in
            return Response(url: req.rawURL, status: .OK)
        }

        beforeEach {
            routingTable = TreeRoutingTable()
        }

        describe("addRoute") {
            it("handle nil scheme") {
                routingTable.addRoute(nil, path: "/path", handler: handler)
                expect(routingTable.getRoute(nil, path: "/path")).toNot(beNil())
            }

            it("handle routes with scheme") {
                routingTable.addRoute("app", path: "/path", handler: handler)
                expect(routingTable.getRoute(nil, path: "/path")).to(beNil())
                expect(routingTable.getRoute("app", path: "/path")).toNot(beNil())
            }
        }

        describe("getRoute") {
            it("handles multi-level paths") {
                routingTable.addRoute("app", path: "/path/to/controller", handler: handler)
                expect(routingTable.getRoute("app", path: "/path/to/controller")).toNot(beNil())
            }

            it("handles multi-level non-static paths") {
                routingTable.addRoute("app", path: "/users/:userID/images/:imageID/viewer", handler: handler)
                expect(routingTable.getRoute("app", path: "/users/:userID/images/:imageID/viewer")).toNot(beNil())
            }
        }
    }
}
