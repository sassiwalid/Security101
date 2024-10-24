//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct Level5GlobalView: View {
    let server = Level4Server()

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ScrollView {
                    Text("Using the public/private key pair mechanism, we now focus on improving local data validation and handlign on the client.\n\nBy using a custom data type for the Username, we can implement validation rules allowing us to provide a better user experience, and enforce server side rules such as allowed characters, minimum and maximum lengths.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .background(Color(hue: 0, saturation: 1.0, brightness: 0.0, opacity: 0.1))
                .frame(width: 300)

                VStack {
                    Text("Client").font(.title)
                    Level5ClientView(server: server)
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
