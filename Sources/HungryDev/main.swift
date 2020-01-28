//
//  main.swift
//  
//
//  Created by marko on 26.01.20.
//

import Foundation
import Publish
import SplashPublishPlugin
import Ink

try HungryDev().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
//    .optional(.copyResources()),
    .addMarkdownFiles(),
    .sortItems(by: \.date, order: .descending),
    .generateHTML(withTheme: .hungry),
    .generateSiteMap()
])
