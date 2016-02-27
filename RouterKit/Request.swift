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
    var parameters: [String: String] { get set }
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

    /// Underlying
    private var requestProperties: [String: AnyObject]

    /// Extras as passed along in the App link request.
    public var extras: [String: String] {
        get {
            return self.requestProperties[Request.AppLinkExtrasKey] as! [String: String]
        } set {
            self.requestProperties[Request.AppLinkExtrasKey] = newValue
        }
    }

    /// App link request's targetURL
    public let targetURL: String

    /// Referrer of the App link request
    public var refererAppLink: RefererAppLinkType? {
        get {
            if let refererDict = self.requestProperties[Request.AppLinkRefererAppLinkKey] as? [String: String] {
                let appName = refererDict[Request.AppLinkRefererAppNameKey] ?? ""
                let url = refererDict[Request.AppLinkRefererURLKey] ?? ""
                return RefererAppLink(appName: appName, url: url)
            } else {
                return nil
            }
        }
    }

    /// App link request spec version. Defaults to 1.0.
    public var version: String {
        get {
            return self.requestProperties[Request.AppLinkVersionKey] as? String ?? "1.0"
        }
    }

    /// App link request's user agent.
    public var userAgent: String? {
        get {
            return self.requestProperties[Request.AppLinkUserAgentKey] as? String
        }
    }

    // MARK: Convenience Properties

    /// Alias for `extras`.
    public var parameters: [String: String] {
        get {
            return self.extras
        } set {
            self.requestProperties[Request.AppLinkExtrasKey] = newValue
        }
    }

    /// Path of the request e.g. example://foo/bar -> /foo/bar, /foo/bar -> /foo/bar
    public var path: String {
        get {
            return Request.normalizedPath(self.rawURL)
        }
    }

    /// The scheme of the request. Nil when this is an internal requests within the app i.e. /foo/bar
    public let scheme: String?

    public init(url: NSURL) {
        self.rawURL = url
        self.scheme = url.scheme.isEmpty ? nil : Optional(url.scheme)
        self.targetURL = Request.targetURLFromNSURL(url)
        self.requestProperties = url.query.map(Request.normalizedURLParams) ?? [String: AnyObject]()
    }

    // url.absoluteString does not behave as you would expect for custom schemes so we need to normalize it
    private static func targetURLFromNSURL(url: NSURL) -> String {
        let schemeSuffix = url.scheme.isEmpty ? "" : ":/"
        let combinedPath = self.normalizedPath(url) // always returns with / prefix
        return "\(url.scheme)\(schemeSuffix)\(combinedPath)"
    }

    /**
     Normalized path from the specified URL. This mainly handles different semantics that `NSURL` depending on whether url.scheme is present.
     
     Examples:
     scheme://foo/bar   -> /foo/bar
     /foo               -> /foo
     /foo/bar           -> /foo/bar

     - parameter url: URL to normalize.

     - returns: Normalized path regardless of whether `url.scheme` is set.
     */
    private static func normalizedPath(url: NSURL) -> String {
        // URL parsing in NSURL doesn't handle all combinations of scheme and with or without path.
        // For our purposes, everything after scheme:// and / for schemeless is considered the path
        switch (url.host, url.path) {
        case (nil, nil): return "/"
        case (.Some(let host), nil): return "/\(host)"
        case (nil, .Some(let path)): return path
        case let (.Some(host), .Some(path)): return "/\(host)\(path)"
        }
    }

    private static func normalizedURLParams(encodedQuery: String) -> [String: AnyObject] {
        typealias GenericKVParamsType = [String: AnyObject]
        var params = dictionaryFromURLParams(encodedQuery) ?? GenericKVParamsType()
        var appLinkParams = params.removeValueForKey(AppLinkDataParameterKey) as? GenericKVParamsType ?? GenericKVParamsType()
        for (k, v) in params {
            appLinkParams[k] = v
        }
        return appLinkParams
    }

    /// App Link uses url encoded JSON vs. query parameters
    /// encodedParams: foo=bar&baz=qux
    private static func dictionaryFromURLParams(encodedQuery: String) -> [String: AnyObject] {
        let encodedParams = encodedQuery.componentsSeparatedByString("&")
        var resultParamsDictionary = [String: AnyObject]()
        encodedParams.forEach { kv in
            let kvPair = kv.componentsSeparatedByString("=")
            let key = kvPair[0]
            guard let decodedValue = kvPair[1].stringByRemovingPercentEncoding else {
                print("Invalid request parameters.")
                return
            }
            let valueIsJSON = decodedValue.hasPrefix("{") && decodedValue.hasSuffix("}")
            if valueIsJSON {
                let valueData = decodedValue.dataUsingEncoding(NSUTF8StringEncoding)
                do {
                    let deserializedParams = try NSJSONSerialization.JSONObjectWithData(valueData!, options: .AllowFragments) as! [String: AnyObject]
                    resultParamsDictionary[key] = deserializedParams
                } catch {
                    return resultParamsDictionary[key] = [String: AnyObject]()
                }
            } else {
                resultParamsDictionary[key] = decodedValue
            }
        }

        return resultParamsDictionary
    }
}
