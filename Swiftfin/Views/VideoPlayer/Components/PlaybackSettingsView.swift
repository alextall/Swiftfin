//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2024 Jellyfin & Jellyfin Contributors
//

import Defaults
import JellyfinAPI
import Stinsen
import SwiftUI
import VLCUI

// TODO: organize

struct PlaybackSettingsView: View {

    @EnvironmentObject
    private var router: PlaybackSettingsCoordinator.Router
    @EnvironmentObject
    private var splitContentViewProxy: SplitContentViewProxy
    @EnvironmentObject
    private var viewModel: VideoPlayerViewModel

    @Environment(\.audioOffset)
    @Binding
    private var audioOffset
    @Environment(\.subtitleOffset)
    @Binding
    private var subtitleOffset

    var body: some View {
        Form {
            Section {

                ChevronButton(title: L10n.videoPlayer)
                    .onSelect {
                        router.route(to: \.videoPlayerSettings)
                    }

                // TODO: playback information
            } header: {
                EmptyView()
            }

            BasicStepper(
                title: L10n.audioOffset,
                value: _audioOffset.wrappedValue,
                range: -30000 ... 30000,
                step: 100
            )
            .valueFormatter {
                $0.millisecondFormat
            }

            BasicStepper(
                title: L10n.subtitleOffset,
                value: _subtitleOffset.wrappedValue,
                range: -30000 ... 30000,
                step: 100
            )
            .valueFormatter {
                $0.millisecondFormat
            }

            if !viewModel.videoStreams.isEmpty {
                Section(L10n.video) {
                    ForEach(viewModel.videoStreams, id: \.displayTitle) { mediaStream in
                        ChevronButton(title: mediaStream.displayTitle ?? .emptyDash)
                            .onSelect {
                                router.route(to: \.mediaStreamInfo, mediaStream)
                            }
                    }
                }
            }

            if !viewModel.audioStreams.isEmpty {
                Section(L10n.audio) {
                    ForEach(viewModel.audioStreams, id: \.displayTitle) { mediaStream in
                        ChevronButton(title: mediaStream.displayTitle ?? .emptyDash)
                            .onSelect {
                                router.route(to: \.mediaStreamInfo, mediaStream)
                            }
                    }
                }
            }

            if !viewModel.subtitleStreams.isEmpty {
                Section(L10n.subtitle) {
                    ForEach(viewModel.subtitleStreams, id: \.displayTitle) { mediaStream in
                        ChevronButton(title: mediaStream.displayTitle ?? .emptyDash)
                            .onSelect {
                                router.route(to: \.mediaStreamInfo, mediaStream)
                            }
                    }
                }
            }
        }
        .navigationTitle(L10n.playback)
        .navigationBarTitleDisplayMode(.inline)
        .navigationCloseButton {
            splitContentViewProxy.hide()
        }
    }
}
