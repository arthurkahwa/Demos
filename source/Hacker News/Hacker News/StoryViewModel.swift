//
//  StoryViewModel.swift
//  Hacker News
//
//  Created by Arthur Nsereko Kahwa on 7/1/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation
import Combine

struct StoryViewModel {
    let story: Story

    var id: Int {
        return self.story.id
    }

    var title: String {
        return self.story.title
    }

    var url: String {
        return self.story.url
    }
}
