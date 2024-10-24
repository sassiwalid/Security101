//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import Foundation
import Combine

struct AuthRequestLog: Equatable, Sendable {
    let request: String
    let accessGranted: Bool
    let timestamp: Date

    init(request: String, accessGranted: Bool, timestamp: Date = Date()) {
        self.request = request
        self.accessGranted = accessGranted
        self.timestamp = timestamp
    }

    static var noRequestYet = AuthRequestLog(request: "", accessGranted: false, timestamp: .distantPast)
}

struct AuthInfo: Sendable, Equatable {
    let username: String
    let password: String
}

protocol ServerInstance {
    var authInfo: AnyPublisher<AuthInfo, Never> { get }
    var lastAuthRequest: AnyPublisher<AuthRequestLog, Never> { get }
    var spyHook: AnyPublisher<Data, Never> { get }

    func authorize(_ request: Data) -> Bool
}
