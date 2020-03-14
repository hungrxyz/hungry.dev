//
//  main.swift
//  
//
//  Created by marko on 26.01.20.
//

import Foundation
import Publish
import Ink
import ShellOut

//let binPath: String = {
//    #if os(Linux)
//        return "/usr/bin/"
//    #elseif os(macOS)
        return "/usr/local/bin/"
//    #else
//        return "/"
//    #endif
}()

public extension Plugin {
    static func pygmentize() -> Self {
        Plugin(name: "Pygments") { context in
            context.markdownParser.addModifier(
                .pygmentizeCodeBlocks()
            )
        }
    }
}

public extension Modifier {
    static func pygmentizeCodeBlocks() -> Self {
        return Modifier(target: .codeBlocks) { html, markdown in

            let begin = markdown.components(separatedBy: .newlines).first ?? "```"
            let language = begin.dropFirst("```".count)

            var markdown = markdown.dropFirst(begin.count)

            guard language != "no-highlight" else {
                return html
            }

            markdown = markdown
                .drop(while: { !$0.isNewline })
                .dropFirst()
                .dropLast("\n```".count)

            let markdownString = String(markdown).replacingOccurrences(of: "\"", with: "\\\"")
            let cmd = #"echo "\#(markdownString)" | \#(binPath)pygmentize -s -l \#(String(language)) -f html -O nowrap"#

            if let highlighted = try? shellOut(to: cmd) {
                return "<pre><code>" + highlighted + "\n</code></pre>"
            }
            return "<pre><code>" + String(markdown) + "\n</code></pre>"
        }
    }
}


public extension Plugin {
    /// Fixing date formatter locale to `en_US` since all dates for posts are in `yyyy-MM-dd HH:mm`.
    static func usLocaleDateFormatter() -> Self {
        Plugin(name: "US Locale Date Formatter") { context in
            context.dateFormatter.locale = Locale(identifier: "en_US")
        }
    }
}

try HungryDev().publish(using: [
    .installPlugin(.usLocaleDateFormatter()),
    .installPlugin(.pygmentize()),
    .addMarkdownFiles(),
    .sortItems(by: \.date, order: .ascending),
    .generateHTML(withTheme: .hungry),
    .generateSiteMap(),
    .copyFile(at: "Resources/CNAME")
])
