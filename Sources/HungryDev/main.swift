//
//  main.swift
//  
//
//  Created by marko on 26.01.20.
//

import Foundation
import Publish
import SplashPublishPlugin

try HungryDev().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
    .addMarkdownFiles(),
    .sortItems(by: \.date, order: .descending),
    .generateHTML(withTheme: .hungry),
    .generateSiteMap()
])
