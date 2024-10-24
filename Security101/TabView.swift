//
//  TabView.swift
//  Security101
//
//  Created by Dave Poirier on 2024-09-15.
//

import SwiftUI

struct TabView: View {
    @State var label: String
    @Binding var tab: ContentView.Tab
    let tabId: ContentView.Tab

    var body: some View {
        Button(action: {
            tab = tabId
        }, label: {
            Text(label).bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(tab == tabId ? Color.orange : Color.clear)
                .contentShape(Rectangle())
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    TabView(label: "Level0", tab: .constant(.level0), tabId: .level0)
}
