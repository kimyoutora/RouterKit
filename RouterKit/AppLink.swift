//
//  AppLink.swift
//  RouterKit
//
//  Created by Kang Chen on 1/2/16.
//
//

import Foundation

/**
 *  App Link v1.0 protocol. See http://applinks.org/documentation.
 */
public protocol AppLinkType {
    /// An object containing information from the navigating app.
    var extras: [String: AnyObject] { get }

    /// String containing the URL being navigated to.
    var targetURL: String { get }

    /// An object containing the app link metadata to identify the referer of this navigation.
    var refererAppLink: RefererAppLinkType? { get }

    /// A string containing the version of the protocol – currently "1.0"; defaults to "1.0".
    var version: String { get }

    /// A string containing an identifier for the library that the navigating code is using to navigate.
    var userAgent: String? { get }
}

/**
 *  Protocol for a referer App Link.
 */
public protocol RefererAppLinkType {
    /// Name of the referer App.
    var appName: String { get }

    /// String of URL to navigate back to the referer.
    var url: String { get }
}

public struct RefererAppLink: RefererAppLinkType {
    public let appName: String
    public let url: String
}
