//
//  StoryDetailView.swift
//  Hacker News
//
//  Created by Arthur Nsereko Kahwa on 7/2/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import SwiftUI

struct StoryDetailView: View {

    @ObservedObject private var storyDetailViewModel: StoryDetailViewModel
    var storyId: Int

    init(storyId: Int) {
        self.storyId = storyId
        self.storyDetailViewModel = StoryDetailViewModel()
    }

    var body: some View {
        VStack {
            Text(self.storyDetailViewModel.title)
            Text(self.storyDetailViewModel.url)
            Webview(url: self.storyDetailViewModel.url)
        }.onAppear {
            self.storyDetailViewModel.fetchStoryDetails(storyId: self.storyId)
        }
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(storyId: 8863)
    }
}
