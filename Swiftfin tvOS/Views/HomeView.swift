//
/*
 * SwiftFin is subject to the terms of the Mozilla Public
 * License, v2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * Copyright 2021 Aiden Vigue & Jellyfin Contributors
 */

import Defaults
import Foundation
import SwiftUI
import JellyfinAPI

struct HomeView: View {
    
    @EnvironmentObject var homeRouter: HomeCoordinator.Router
    @ObservedObject var viewModel = HomeViewModel()
    @Default(.showPosterLabels) var showPosterLabels

    @State var showingSettings = false

    var body: some View {
        if viewModel.isLoading {
            ProgressView()
                .scaleEffect(2)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    
                    if viewModel.resumeItems.isEmpty {
                        HomeCinematicView(items: viewModel.latestAddedItems.map({ .init(item: $0, type: .plain) }),
                                          forcedItemSubtitle: "Recently Added")
                        
                        if !viewModel.nextUpItems.isEmpty {
                            NextUpView(items: viewModel.nextUpItems)
                                .focusSection()
                        }
                    } else {
                        HomeCinematicView(items: viewModel.resumeItems.map({ .init(item: $0, type: .resume) }))
                        
                        if !viewModel.nextUpItems.isEmpty {
                            NextUpView(items: viewModel.nextUpItems)
                                .focusSection()
                        }
                        
                        PortraitItemsRowView(rowTitle: "Recently Added",
                                             items: viewModel.latestAddedItems,
                                             showItemTitles: showPosterLabels) { item in
                            homeRouter.route(to: \.modalItem, item)
                        }
                    }

                    ForEach(viewModel.libraries, id: \.self) { library in
                        LatestMediaView(viewModel: LatestMediaViewModel(library: library))
                            .focusSection()
                    }
                    
                    Spacer(minLength: 100)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.refresh()
                        } label: {
                            Text("Refresh")
                        }
                        
                        Spacer()
                    }
                    .focusSection()
                }
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.horizontal)
        }
    }
}
