//
//  RequestSpec.swift
//  RouterKit
//
//  Created by Kang Chen on 2/24/16.
//  Copyright © 2016 RouterKit. All rights reserved.
//

import Nimble
import Quick
import RouterKit
import XCTest

class RequestTests: QuickSpec {
    override func spec() {
        let appLinkWithEncodedData = "example://applinks?al_applink_data=%7B%22user_agent%22%3A%22Bolts%20iOS%201.0.0%22%2C%22target_url%22%3A%22example%3A%5C%2F%5C%2Fapplinks%22%2C%22extras%22%3A%7B%22myapp_token%22%3A%22t0kEn%22%7D%2C%22referer_app_link%22%3A%7B%22target_url%22%3A%20%22http%3A%5C%2F%5C%2Fexample.com%5C%2Fdocs%22%2C%22url%22%3A%20%22example%3A%5C%2F%5C%2Fdocs%22%2C%22app_name%22%3A%20%22Example%20App%22%7D%7D"
        let appLinkURL = NSURL(string: appLinkWithEncodedData)!
        let appLinkRequest = Request(url: appLinkURL)

        context("when given app link URL") {
            describe("init") {
                it("stores the original URL") {
                    expect(appLinkRequest.rawURL).to(equal(appLinkURL))
                }

                it("returns correct scheme") {
                    expect(appLinkRequest.scheme).to(equal("example"))
                }

                it("returns correct targetURL") {
                    expect(appLinkRequest.targetURL).to(equal("example://applinks"))
                }

                it("returns correct path") {
                    expect(appLinkRequest.path).to(equal("/applinks"))
                }

                it("returns default version if not set") {
                    expect(appLinkRequest.version).to(equal("1.0"))
                }

                it("returns version if set") {
                    let appLinkWithVersion = "example://applinks?al_applink_data=%7B%22user_agent%22%3A%22Bolts%20iOS%201.0.0%22%2C%22target_url%22%3A%22example%3A%5C%2F%5C%2Fapplinks%22%2C%22extras%22%3A%7B%22myapp_token%22%3A%22t0kEn%22%7D%2C%22referer_app_link%22%3A%7B%22target_url%22%3A%20%22http%3A%5C%2F%5C%2Fexample.com%5C%2Fdocs%22%2C%22url%22%3A%20%22example%3A%5C%2F%5C%2Fdocs%22%2C%22app_name%22%3A%20%22Example%20App%22%7D%2C%20%22version%22%3A%20%221.1%22%7D"
                    let appLinkRequestWithVersion = Request(url: NSURL(string: appLinkWithVersion)!)
                    expect(appLinkRequestWithVersion.version).to(equal("1.1"))
                }

                it("returns user agent if set") {
                    expect(appLinkRequest.userAgent).to(equal(Optional.Some("Bolts iOS 1.0.0")))
                }

                fit("returns correct referrer app link") {
                    let refererAppLink = appLinkRequest.refererAppLink
                    expect(refererAppLink?.appName).to(equal("Example App"))
                    expect(refererAppLink?.url).to(equal("example://docs"))
                }
            }
        }
    }
}
