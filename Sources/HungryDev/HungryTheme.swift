//
//  HungryTheme.swift
//
//
//  Created by marko on 26.01.20.
//

import Foundation
import Publish
import Plot

public extension Theme {
    static var hungry: Self {
        Theme(
            htmlFactory: HungryHTMLFactory(), resourcePaths: [
                "Resources/HungryTheme/primer.css",
                "Resources/Pygments/github.css"
            ]
        )
    }
}

private struct HungryHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site, stylesheetPaths: ["/primer.css"]),
            .body(
                .header(for: context, selectedSection: nil),
                .container(
                    .h3(.text("Hi, this is my personal blog. I write about development on Apple Platforms.")),
                    .h2(.text("Posts")),
                    .itemList(
                        for: context.items(taggedWith: Tag("post"), sortedBy: \.date, order: .descending),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site, stylesheetPaths: ["/primer.css"]),
            .body(
                .footer(for: context.site)
            )
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"

        let postURLString = "https://hungry.dev/posts/\(item.path)"
        let twitterShareURLString = "https://twitter.com/intent/tweet?url=\(postURLString)&via=hngrydev&text=\(item.title)"

        return HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site, stylesheetPaths: ["/primer.css", "/github.css"]),
            .body(
                .header(for: context, selectedSection: nil),
                .container(
                    .p(
                        .class("text-small text-gray"),
                        .text(dateFormatter.string(from: item.date))
                    ),
                    .contentBody(item.body),
                    .p(
                        .class("py-2"),
                        .a(
                            .text("Share this article on Twitter"),
                            .href(twitterShareURLString)
                        ),
                        .text(". "),
                        .text("For any questions, comments or feedback reach out to me "),
                        .a(
                            .text("@hungrxyz"),
                            .href("https://twitter.com/hungrxyz")
                        ),
                        .text(".")
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site, stylesheetPaths: ["/primer.css", "/github.css"]),
            .body(
                .header(for: context, selectedSection: nil),
                .container(.contentBody(page.body)),
                .footer(for: context.site)
            )
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        return nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        return nil
    }
}

private extension Node where Context == HTML.BodyContext {
    static func container(_ nodes: Node..., marginY: Int = 5) -> Node {
        .div(.class("container-md px-3 my-\(marginY) markdown-body"), .group(nodes))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        .header(
            .div(
                .class("border-bottom border-gray-light"),
                .container(
                    .div(
                        .class("d-flex flex-items-baseline"),
                        .a(
                            .class("h3 py-3 pr-6 color-fg-default no-underline"),
                            .text("hungry.dev"),
                            .href("/")
                        ),
                        .a(
                            .class("h5 p-3 color-fg-default no-underline"),
                            .text("Posts"),
                            .href("/")
                        ),
                        .a(
                            .class("h5 p-3 color-fg-default no-underline"),
                            .text("Apps"),
                            .href("/apps")
                        )
                    ),
                    marginY: 0
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"

        let itemsPerYear: [Int: [Item<T>]] = items.reduce(into: [:]) { result, item in
            result[item.date.year, default: []].append(item)
        }

        return .forEach(itemsPerYear.sorted { $0.key > $1.key }) {
            .div(
                .h3("\($0.key)"),
                .forEach($0.value.sorted { $0.date > $1.date }) { item in
                        .div(
                            .class("py-2 d-flex flex-justify-between flex-items-center"),
                            .div(.a(
                                .text(item.title),
                                .href(item.path)
                            )
                            ),
                            .div(
                                .class("text-small text-gray"),
                                .text(dateFormatter.string(from: item.date))
                            )
                        )
                }
            )
        }
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .container(
                .div(
                    .class("d-flex flex-justify-center"),
                    .p(
                        .class("text-small text-gray v-align-middle"),
                        .text("Styled with "),
                        .a(
                            .text("Primer"),
                            .href("https://primer.style")
                        ),
                        .text(" | Generated using "),
                        .a(
                            .text("Publish"),
                            .href("https://github.com/johnsundell/publish")
                        ),
                        .text(" | Hosted on "),
                        .a(
                            .text("GitHub Pages"),
                            .href("https://pages.github.com")
                        )
                    )
                )
            )
        )
    }
}

private extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}
