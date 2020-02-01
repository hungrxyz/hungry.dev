import Foundation
import Publish
import Plot

struct HungryDev: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
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
