//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level0SpyView: View {
    let server: ServerInstance
    @State var request: String = ""
    @State var capturedRequest: Data = Data()
    @State var signedIn = false
    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Captured Request").bold()
            Text(request)
                .frame(maxWidth: .infinity)


            Divider()
            if signedIn {
                Text("Signed in!").bold()
                Button("Sign out") {
                    signedIn = false
                    request = ""
                    capturedRequest = Data()
                }
            } else {
                Text("Unauthorized")

                GroupBox("Replay Attack") {
                    Button("Attempt replay attack") { replayAttack() }.disabled(request.isEmpty)
                }

                GroupBox("Authenticate") {
                    TextField("Username", text: $username)
                    TextField("Password", text: $password)
                    Button("Sign in") { try? signIn() }
                }
            }
        }
        .onReceive(server.spyHook) { newRequest in
            capturedRequest = newRequest
            request = String(data: newRequest, encoding: .utf8) ?? ""
        }
    }

    func replayAttack() {
        signedIn = server.authorize(capturedRequest)
    }

    private func signIn() throws {
        let auth = Level0Server.AuthRequest(username: username, password: password)
        let request = try JSONEncoder().encode(auth)
        signedIn = server.authorize(request)
    }

}

#Preview {
    Level0SpyView(server: Level0Server())
        .frame(width: 300)
}
