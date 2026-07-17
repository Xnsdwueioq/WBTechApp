//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum APIClientFactory {

  static func make(token: String) -> Client {
    let serverURL = (try? Servers.Server1.url()) ?? URL(string: "https://eat-and-pay.t02.ru")!

    return Client(
      serverURL: serverURL,
      transport: URLSessionTransport(),
      middlewares: [BearerTokenMiddleware(token: token)]
    )
  }
  
}
