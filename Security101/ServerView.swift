//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI
import Cocoa

struct ServerView: View {
    let server: ServerInstance
    @State var request: String = ""
    @State var granted: Bool = false
    @State var timestamp: Date = .distantPast
    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Authorized User").bold()
            Text("Username: \(username)")
            HStack {
                Text("Password: \(password)")
                if !password.isEmpty, !password.hasPrefix("----") {
                    Button(action:  {
                        NSPasteboard.general.prepareForNewContents()
                        NSPasteboard.general.setString(password, forType: .string)
                    }, label: { Image(systemName: "doc.on.doc") })
                }
            }

            if !request.isEmpty {
                Divider()
                Text("Last request:").bold()
                Text(request)
            }

            if timestamp != .distantPast {
                Divider()
                Text("\(timestamp)").font(.footnote).monospacedDigit()
                    .padding(.bottom, 20)
                if granted {
                    Text("Access Granted!").bold().foregroundColor(.green)
                } else {
                    Text("Access Denied").bold().foregroundColor(.red)
                }
            }
        }
        .onReceive(server.authInfo) { authInfo in
            username = authInfo.username
            password = authInfo.password
        }
        .onReceive(server.lastAuthRequest) { lastRequest in
            request = lastRequest.request
            granted = lastRequest.accessGranted
            timestamp = lastRequest.timestamp
        }
    }
}

#Preview {
    ServerView(server: Level0Server())
}
