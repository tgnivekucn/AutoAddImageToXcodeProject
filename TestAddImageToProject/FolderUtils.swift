//
//  FolderUtils.swift
//  TestAddImageToProject
//
//  Created by 粘光裕 on 2018/6/24.
//  Copyright © 2018年 Kevingt. All rights reserved.
//

import Foundation
class FolderUtils {
    
    static func createFolder(path: String) -> (Bool,String){
//        let path: String = "/Users/nenhikarihiroshi/Desktop/Kevingt"
        let fileManager = FileManager.default
        do
        {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Error while creating a folder. error is: \(error)")
            return (false,"\(error)")
        }
        return (true,"success")
    }
}
