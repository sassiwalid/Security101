//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level4SpyView: View {
    let server: ServerInstance
    @State var request: String = ""
    @State var capturedRequest: Data = Data()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Captured Request").bold()
            Text(request)
                .frame(maxWidth: .infinity)

            if !request.isEmpty {
                Button("Attempt replay attack") {
                    _ = server.authorize(capturedRequest)
                }
            }
        }
        .onReceive(server.spyHook) { newRequest in
            capturedRequest = newRequest
            request = String(data: newRequest, encoding: .utf8) ?? ""
        }
    }
}
