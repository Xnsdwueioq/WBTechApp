//

import Foundation
import OSLog

enum TokenBootstrap {
  
  static let account = "bearerToken"
  private static let envKey = "BEARER_TOKEN"
  
  static func run() {
    guard KeychainStore.read(account: account) == nil else { return }
    
    guard let token = ProcessInfo.processInfo.environment[envKey], !token.isEmpty else {
      Logger.auth.warning("BEARER_TOKEN token not specified")
      return
    }
    
    do {
      try KeychainStore.save(token, account: account)
    } catch {
      Logger.auth.error("Unable to save the token to the keychain: \(error.localizedDescription)")
    }
  }
  
}
