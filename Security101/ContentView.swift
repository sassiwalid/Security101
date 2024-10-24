//
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import SwiftUI

struct ContentView: View {

    enum Tab {
        case level0, level1, level2, level3, level4, level5
    }

    @State var tab: Tab = .level0

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TabView(label: "Level 0", tab: $tab, tabId: .level0)
                TabView(label: "Level 1", tab: $tab, tabId: .level1)
                TabView(label: "Level 2", tab: $tab, tabId: .level2)
                TabView(label: "Level 3", tab: $tab, tabId: .level3)
                TabView(label: "Level 4", tab: $tab, tabId: .level4)
                TabView(label: "Level 5", tab: $tab, tabId: .level5)
            }
            .frame(height: 30)
            Divider()

            switch tab {
            case .level0:
                Level0GlobalView()
            case .level1:
                Level1GlobalView()
            case .level2:
                Level2GlobalView()
            case .level3:
                Level3GlobalView()
            case .level4:
                Level4GlobalView()
            case .level5:
                Level5GlobalView()
            }
        }
    }
}

#Preview {
    ContentView()
}
