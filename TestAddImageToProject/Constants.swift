//
//  Constants.swift
//  TestAddImageToProject
//
//  Created by 粘光裕 on 2018/6/24.
//  Copyright © 2018年 Kevingt. All rights reserved.
//

import Foundation
class Contants { 
    static func generateContentJsonContent(oneXFilename: String,twoXFilename: String,threeXFilename: String) -> String {
        return "{\n" +
            "  \"images\" : [\n" +
            "    {\n" +
            "      \"idiom\" : \"universal\",\n" +
            "      \"filename\" : \"" + oneXFilename  +  "\",\n" +
            "      \"scale\" : \"1x\"\n" +
            "    },\n" +
            "    {\n" +
            "      \"idiom\" : \"universal\",\n" +
            "      \"filename\" : \"" + twoXFilename  +  "\",\n" +
            "      \"scale\" : \"2x\"\n" +
            "    },\n" +
            "    {\n" +
            "      \"idiom\" : \"universal\",\n" +
            "      \"filename\" : \"" + threeXFilename  +  "\",\n" +
            "      \"scale\" : \"3x\"\n" +
            "    }\n" +
            "  ],\n" +
            "   \"info\" : {\n" +
            "    \"version\" : 1,\n" +
            "    \"author\" : \"xcode\"\n" +
            "  }\n" +
           "}"

    }
}
