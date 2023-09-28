//
//  HungryDev.swift
//
//
//  Created by marko on 26.01.20.
//

import Foundation
import Publish
import Plot

struct HungryDev: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case apps
    }

    struct ItemMetadata: WebsiteItemMetadata {
        let date: Date
    }

    var url = URL(string: "https://hungry.dev")!
    var name = "hungry.dev"
    var description = "Personal blog."
    var language: Language { .english }
    var imagePath: Path? { nil }
}
