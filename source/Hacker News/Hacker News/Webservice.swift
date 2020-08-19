//
//  Webservice.swift
//  Hacker News
//
//  Created by Arthur Nsereko Kahwa on 7/1/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation
import Combine

class Webservice {

    func getStoryBy(storyId id: Int) -> AnyPublisher<Story, Error> {
        let uri = "https://hacker-news.firebaseio.com/v0/item/\(id).json?print=pretty"
        guard let url = URL(string: uri)  else { fatalError("Bad URL") }

        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: Story.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func mergeStories(storyIds ids: [Int]) -> AnyPublisher<Story, Error> {
        let storyIds = Array(ids.prefix(50))

        let initialPublisher = getStoryBy(storyId: storyIds[0])
        let remainder = Array(ids.dropFirst())
        return remainder.reduce(initialPublisher) { combined, id in
            return combined.merge(with: getStoryBy(storyId: id))
            .eraseToAnyPublisher()
        }
    }

    func getAllTopStories() -> AnyPublisher<[Story], Error> {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
            else {
                fatalError("Bad URL")
        }

        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: [Int].self, decoder: JSONDecoder())
            .flatMap { storyIds in
                return self.mergeStories(storyIds: storyIds)
            }
            .scan([]) { stories, story -> [Story] in
                return stories + [story]
            }
            .eraseToAnyPublisher()

            return publisher
    }
}
