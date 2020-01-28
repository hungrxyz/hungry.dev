//
//  File.swift
//  
//
//  Created by marko on 26.01.20.
//

import Publish
import Plot

public extension Theme {
    static var hungry: Self {
        Theme(
            htmlFactory: HungryHTMLFactory(), resourcePaths: [
                "Resources/HungryTheme/primer.css",
                "Resources/Splash/highlight.css"
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
                        for: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                )
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
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site, stylesheetPaths: ["/primer.css", "/highlight.css"]),
            .body(
                .header(for: context, selectedSection: nil),
                .container(.contentBody(item.body)),
                .footer(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
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
        .div(.class("container-lg px-3 my-\(marginY) markdown-body"), .group(nodes))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        return .header(
            .div(
                .class("border-bottom border-gray-light"),
                .container(
                    .h3(.a(
                        .class("text-gray-dark no-underline"),
                        .text("hungry.dev"),
                        .href("/")
                        )
                    ),
                    marginY: 3
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .forEach(items) { item in
            .p(.a(
                .text(item.title),
                .href(item.path)
            ))
        }
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .container(
                .p(
                    .text("Generated using "),
                    .a(
                        .text("Publish"),
                        .href("https://github.com/johnsundell/publish")
                    )
                )
            )
        )
    }
}
