//
//  Request.swift
//  RouterKit
//
//  Created by Kang Chen on 1/2/16.
//
//

import Foundation

/**
 *  Base protocol of a request. Isolating this enables
 *  support for potentially multiple URL standards.
 */
public protocol RequestType {
    var parameters: [String: AnyObject] { get set }
    var path: String { get }
    var scheme: String? { get }

    init(url: NSURL)
}

/**
 *  A Request represents an inbound or outbound URL request
 *  with structured metadata, namely conformance to AppLink v1.0 spec.
 */
public struct Request: AppLinkType, RequestType {
    /// The original URL representing this request.
    public let rawURL: NSURL

    /// Protocol conformance is done within this class due to performance
    /// penalty of only having computed properties for extensions.

    // MARK: AppLink Protocol
    static let AppLinkDataParameterKey = "al_applink_data"
    static let AppLinkTargetURLKey = "target_url"
    static let AppLinkUserAgentKey = "user_agent"
    static let AppLinkExtrasKey = "extras"
    static let AppLinkVersionKey = "version"
    static let AppLinkRefererAppLinkKey = "referer_app_link"
    static let AppLinkRefererURLKey = "url"
    static let AppLinkRefererAppNameKey = "app_name"

    public var extras: [String: AnyObject]
    public let targetURL: String
    public let refererAppLink: RefererAppLinkType?
    public let version: String
    public let userAgent: String?

    // MARK: Convenience Properties
    public var parameters: [String: AnyObject] {
        get {
            return self.extras
        }
        set {
            self.extras = newValue
        }
    }
    public var path: String {
        get {
            return self.targetURL
        }
    }
    public let scheme: String?

    public init(url: NSURL) {
        self.rawURL = url
        self.scheme = url.scheme.isEmpty ? nil : Optional(url.scheme)
        self.targetURL = Request.targetURLFromNSURL(url)
        self.extras = url.query.map(Request.dictionaryFromAppLinkData) ?? [String: AnyObject]()
        self.userAgent = self.extras[Request.AppLinkUserAgentKey] as? String
        self.version = self.extras[Request.AppLinkVersionKey] as? String ?? "1.0"

        let refererDict = self.extras[Request.AppLinkRefererAppLinkKey]
        let refererURL = refererDict?[Request.AppLinkRefererURLKey] as? String
        let refererAppName = refererDict?[Request.AppLinkRefererAppNameKey] as? String
        switch (refererAppName, refererURL) {
        case let (appName?, url?): self.refererAppLink = RefererAppLink(appName: appName, url: url)
        default: self.refererAppLink = nil
        }
    }

    // url.absoluteString does not behave as you would expect for custom schemes so we need to normalize it
    private static func targetURLFromNSURL(url: NSURL) -> String {
        let schemePrefix = url.scheme.isEmpty ? "/" : "\(url.scheme)://"
        // URL parsing in NSURL doesn't handle all combinations of scheme and with or without path.
        // For our purposes, everything after scheme:// and / for schemeless is considered the path
        let combinedPath = [url.host ?? "", url.path ?? ""].filter { !$0.isEmpty }.joinWithSeparator("/")
        return "\(schemePrefix)/\(combinedPath)"
    }

    // App Link uses url encoded JSON vs. query parameters
    private static func dictionaryFromAppLinkData(encodedParams: String) -> [String: AnyObject] {
        let decodedParams = encodedParams.stringByRemovingPercentEncoding
        let decodedData = decodedParams.flatMap { $0.dataUsingEncoding(NSUTF8StringEncoding) }
        do {
            let deserializedParams = try NSJSONSerialization.JSONObjectWithData(decodedData!, options: .AllowFragments) as! [String: AnyObject]
            return deserializedParams
        } catch {
            return [String: AnyObject]()
        }
    }
}
