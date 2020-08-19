//
//  StoryListView.swift
//  Hacker News
//
//  Created by Arthur Nsereko Kahwa on 7/1/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import SwiftUI

struct StoryListView: View {

    @ObservedObject private var storyListViewModel = StoryListViewModel()

    var body: some View {
        NavigationView {
            List(self.storyListViewModel.stories, id: \.id) { storyViewModel in
                NavigationLink(destination: StoryDetailView(storyId: storyViewModel.id)) {

                        Text(storyViewModel.title)
                }
            }

        .navigationBarTitle("Hacker News")
        }
    }
}

struct StoryListView_Previews: PreviewProvider {
    static var previews: some View {
        StoryListView()
    }
}
