//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import Foundation
import CryptoKit

func hash(_ value: String) -> String {
    let data = value.data(using: .utf8)!
    let hashed = Data(SHA512.hash(data: data))
    return hashed.base64EncodedString()
}
