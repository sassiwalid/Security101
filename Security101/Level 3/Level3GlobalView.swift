//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level3GlobalView: View {
    let server = Level3Server()

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ScrollView {
                    Text("Server stores the **password hashes**.  Prior to requesting authentication, the client must first request a **challenge**.  The authentication hash sent to the server requires a valid challenge and the ability to compute the authentication hash.\n\nAn attacker capturing a sign-in request **can no longer replay** the request to sign in.\n\nHowever a data breach would still expose the underlying password hashes and an attacker could request a challenge and be able to recompute the expected authentication hash.\n\nUsername -> Challenge -> HASH(**challenge** + password) -> Request -> Token")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .background(Color(hue: 0, saturation: 1.0, brightness: 0.0, opacity: 0.1))
                .frame(width: 300)

                VStack {
                    Text("Client").font(.title)
                    Level3ClientView(server: server)
                        .frame(height: 400, alignment: .center)
                }
                .padding()
                .frame(width: 300)

                VStack {
                    Text("Man-in-the-middle").font(.title)
                    Level3SpyView(server: server)
                        .frame(maxHeight: .infinity)
                }
                .padding()
                .overlay(Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [20, 8]))
                    .foregroundColor(.red)
                )
                .frame(width: 300)

                VStack {
                    Text("Server").font(.title)
                    ServerView(server: server)
                        .frame(maxHeight: .infinity)
                }
                .padding()
                .frame(width: 300)
            }

            Text("Hashed passwords in server database, hashed/salted requests")
                .padding()
        }
    }
}
