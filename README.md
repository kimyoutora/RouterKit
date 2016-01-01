# RouterKit

[![Build Status](https://travis-ci.org/kimyoutora/RouterKit.svg?branch=master)](https://travis-ci.org/kimyoutora/RouterKit)
[![Twitter](https://img.shields.io/badge/twitter-@kang-blue.svg?style=flat)](http://twitter.com/kang)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](LICENSE)

Simple but powerful router in Swift to help manage deep linking and navigation of your app's content.

## Usage

```swift
var router: Router!

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  self.router = Router(userAgent: self.appName)
  router.addRoute("/users/:me/profile") { (request) -> Response
    print(request.extras)
    return Response(url: request.rawURL, status: .OK)
  }

  // RequestHandlingClass : RequestHandling
  router.registerClass(RequestHandlingClass.self, forRoute: "/tweets/:tweetID")
}

func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
  return self.router.handleURL(url)
}
```

## Roadmap

0.1.0
- [x] Basic deep-linking support
- [x] Route named parameters
- [x] Handlers
- [x] AppLinks 1.0 support
- [x] Routable controllers
- [ ] Tests

0.2.0
- [ ] Better debugging support
- [ ] Filters

0.3.0
- [ ] Wildcard/regex parameters

0.4.0
- [ ] Route specific filters

0.5.0
- [ ] Interface builder support

1.0.0
- [ ] Complete documentation
- [ ] More debug information
- [ ] Pretty print routing table
- [ ] Code coverage
- [ ] Benchmarks
