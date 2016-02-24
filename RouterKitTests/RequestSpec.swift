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
        let appLinkWithEncodedData = "example://applinks?al_applink_data=%7B%22user_agent%22%3A%22Bolts%20iOS%201.0.0%22%2C%22target_url%22%3A%22http%3A%5C%2F%5C%2Fexample.com%5C%2Fapplinks%22%2C%22extras%22%3A%7B%22myapp_token%22%3A%22t0kEn%22%7D%7D"
        let appLinkURL = NSURL(string: appLinkWithEncodedData)!
        let appLinkRequest = Request(url: appLinkURL)

        context("when given app link URL") {
            describe("init") {
                it("stores the original URL") {
                    expect(appLinkRequest.rawURL).to(equal(appLinkURL))
                }
            }
        }
    }
}
