//
//  StoryListViewModel.swift
//  Hacker News
//
//  Created by Arthur Nsereko Kahwa on 7/1/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation
import Combine

class StoryListViewModel: ObservableObject {

    @Published var stories = [StoryViewModel]()
    private var cancellable: AnyCancellable?

    init() {
        fetchTopStories()
    }

    private func fetchTopStories() {
        self.cancellable = Webservice().getAllTopStories().map { stories in
            stories.map { StoryViewModel(story: $0) }
        }.sink(receiveCompletion: { _ in }, receiveValue: { storyViewModels in
            self.stories = storyViewModels
        })
    }
}
