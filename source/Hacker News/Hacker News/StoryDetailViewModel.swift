//
//  StoryDetailViewModel.swift
//  Hacker News
//
//  Created by Arthur Nsereko Kahwa on 7/2/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation
import Combine

class StoryDetailViewModel: ObservableObject {

    private var cancellable: AnyCancellable?
    @Published private var story = Story.placeholder()

    func fetchStoryDetails(storyId: Int) {
        print("about to make a network request")
        self.cancellable = Webservice().getStoryBy(storyId: storyId)
            .catch { _ in Just(Story.placeholder()) }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { story in
                    self.story = story
                })
    }

    var title: String {
        return self.story.title
    }

    var url: String {
        return self.story.url
    }
}
