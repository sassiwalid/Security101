//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level2SpyView: View {
    let server: ServerInstance
    @State var request: String = ""
    @State var capturedRequest: Data = Data()
    @State var signedIn = false
    @State var username: String = ""
    @State var passwordHash: String = ""
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
                    username = ""
                    passwordHash = ""
                }
            } else {
                Text("Unauthorized")
                Text("Hacker's tools").bold().padding(.top)
                GroupBox("Replay Attack") {
                    Button("Attempt replay attack") { replayAttack() }
                }.disabled(request.isEmpty)

                GroupBox("Compute Hash") {
                    TextField("Plaintext password", text: $password)
                    Button("Compute hash") { passwordHash = hash(password) }.disabled(password.isEmpty)
                }

                GroupBox("Authenticate") {
                    TextField("Username", text: $username)
                    TextField("Hash", text: $passwordHash)
                    Button("Sign in") { try? signIn() }.disabled(username.isEmpty || passwordHash.isEmpty)
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

    func signIn() throws {
        let authRequest = Level2Server.AuthRequest(username: username, passwordHash: passwordHash)
        let request = try JSONEncoder().encode(authRequest)
        signedIn = server.authorize(request)
    }
}

#Preview {
    Level2SpyView(server: Level2Server())
        .frame(width: 300)
}
