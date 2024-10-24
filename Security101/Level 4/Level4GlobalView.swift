//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level4GlobalView: View {
    let server = Level4Server()

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ScrollView {
                    Text("Using the SecureEnclave on the device, we generate a P256 private/public key pair. During registration with the server, the client public key is sent and saved to database.\n\nDuring sign-in, an authentication challenge is requested.  The client uses their private key to generate a P256 cryptographic signature of the challenge which is then sent to the server to authenticate.\n\nDue to the properties of public/private cryptography, a digest signed with a private key can be validated using the matching public key.\n\nThe server knows which public key is assigned to the user and is able to validate the the user must therefore have a valid private key if they were able to produce a valid challenge signature.\n\nGenerate Private/Public Key -> Register Public Key -> Request Challenge -> Sign Challenge with private key -> Authenticate with challenge signature -> Token")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .background(Color(hue: 0, saturation: 1.0, brightness: 0.0, opacity: 0.1))
                .frame(width: 300)

                VStack {
                    Text("Client").font(.title)
                    Level4ClientView(server: server)
                        .frame(height: 400, alignment: .center)
                }
                .padding()
                .frame(width: 300)

                VStack {
                    Text("Man-in-the-middle").font(.title)
                    Level4SpyView(server: server)
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

            Text("Public/Private P256 signing, AKA: Passwordless")
                .padding()
        }
    }
}
