//
//  ViewController.swift
//  TestAddImageToProject
//
//  Created by 粘光裕 on 2018/6/20.
//  Copyright © 2018年 Kevingt. All rights reserved.
//

import Cocoa
/*
//1. A user choose 1x 2x 3x source directories
//2. A user choose a destination directory (project中的Assets.xcassets)
//3. Create folders which names are filenames in 1x folder & copy files with same name in 1x 2x 3x source directories to the folders we create
//4. Create a content.json file to each folder we create at step 4
*/
extension String {
    
    var data: Data {
        return self.data(using:  String.Encoding.utf8)!
    }
}
class ViewController: NSViewController {

    @IBOutlet weak var mStatusLabel: NSTextField!
    
    
    var srcDirPath: String = ""
    var dstDirPath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath)"
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //1. user choose 1x 2x 3x source directories
    @IBAction func selectSourceDir(_ sender: Any) {
    srcDirPath = chooseFileFromDefaultPanel()
        print("srcDirPath is: \(srcDirPath)")
        mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath)"
    }
    
    //2. user choose a destination directory (Assets.xcassets of xcode project)
    @IBAction func SelectDstDir(_ sender: Any) {
        dstDirPath = chooseFileFromDefaultPanel()
        print("dstDirPath is: \(dstDirPath)")
        mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath)"
    }
    
    /*
     * 3. create folders which names are filenames in 1x folder & copy files with same name in 1x 2x 3x source directories to the folders we create
     * 4. create a content.json file to each folder we create at step 4
     */
    @IBAction func pressButtonAction(_ sender: NSButton) {
        print("test77 pressButtonAction ")

        if !checkSrcDirContainDifferentResolutionFolders(sourceDir: srcDirPath) {
            mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath) \n Please select src Dir again, 1x 2x 3x folders must be in src Dir"
            return
        }
        if dstDirPath == "" {
            mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath) \n Please select dst Dir again!!!"
            return
        }
        srcDirPath = srcDirPath + "/"
        dstDirPath = dstDirPath + "/"
        automaticFlow(sourceDir: srcDirPath, dstDir: dstDirPath)
    }
    
    func automaticFlow(sourceDir: String,dstDir: String) {

        //3.
        let (_,_,filenameList1) = getAllFilenamesFromFolder(folderPath: sourceDir + "1x")
        let (_,_,filenameList2) = getAllFilenamesFromFolder(folderPath: sourceDir + "2x")
        let (_,_,filenameList3) = getAllFilenamesFromFolder(folderPath: sourceDir + "3x")
        for filename in filenameList1 {
            let tmp = filename.split(separator: "@")
            if tmp != [] && tmp[0] != "" {
                let folderBeCreated = "\(tmp[0]).imageset"
                let (result,msg) = FolderUtils.createFolder(path: dstDir + folderBeCreated)
                let (result2,msg2) = copyFile(srcDirPath: sourceDir + "1x", srcFilename: filename, dstDirPath: dstDir + folderBeCreated, dstFilename: filename)
                if !result {
                    mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath) \n createFolder error: \(msg)"
                    return
                }
                if !result2 {
                    mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath) \n createFolder error: \(msg2)"
                    return
                }
            }
        }
        for filename in filenameList2 {
            let tmp = filename.split(separator: "@")
            if tmp != [] && tmp[0] != "" {
                let folder = "\(tmp[0]).imageset"
                let (result,msg) = copyFile(srcDirPath: sourceDir + "2x", srcFilename: filename, dstDirPath: dstDir + folder, dstFilename: filename)
                if !result {
                    mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath) \n copyFile error: \(msg)"
                    return
                }
            }
        }
        for filename in filenameList3 {
            let tmp = filename.split(separator: "@")
            if tmp != [] && tmp[0] != "" {
                let folder = "\(tmp[0]).imageset"
                let (result,msg) = copyFile(srcDirPath: sourceDir + "3x", srcFilename: filename, dstDirPath: dstDir + folder, dstFilename: filename)
                if !result {
                    mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath) \n copyFile error: \(msg)"
                    return
                }
            }
        }
        //4.
        for filename in filenameList1 {
            let tmp = filename.split(separator: "@")
            if tmp != [] && tmp[0] != "" {
                let folder = "\(tmp[0]).imageset"
                let oneXFilename = "\(tmp[0])@1x.png"
                let twoXFilename = "\(tmp[0])@2x.png"
                let threeXFilename = "\(tmp[0])@3x.png"
                let content = Contants.generateContentJsonContent(oneXFilename: oneXFilename, twoXFilename: twoXFilename, threeXFilename: threeXFilename)
                let (result,msg) = createFile(dstPath: dstDir + folder + "/Contents.json", fileContent: content)
                if !result {
                    mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath) \n createFile \"Content.json\" error: \(msg)"
                    return
                }
            }
        }
        
        mStatusLabel.stringValue = "srcDirPath is: \(srcDirPath) \n dstDirPath is: \(dstDirPath) \n Complete!!!"
    }
    
    
    func checkSrcDirContainDifferentResolutionFolders(sourceDir: String) -> Bool {
        let (_,_,filenameList1) = getAllFilenamesFromFolder(folderPath: sourceDir)
        var hasOneXDir = false
        var hasTwoXDir = false
        var hasThreeXDir = false

        for filename in filenameList1 {
            if filename == "1x" {
                hasOneXDir = true
            } else if filename == "2x" {
                hasTwoXDir = true
            } else if filename == "3x" {
                hasThreeXDir = true
            }
        }
        if hasOneXDir && hasTwoXDir && hasThreeXDir {
            return true
        } else {
            return false

        }
    }
    
    func createFile(dstPath: String, fileContent: String) -> (Bool,String) {
        let fileManager = FileManager.default
        let result = fileManager.createFile(atPath: dstPath, contents: fileContent.data, attributes: nil)
        if result {
            return (true,"success")
        } else {
            return (false,"Error in createFile")
        }
    }


    
    func getAllFilenamesFromFolder(folderPath: String) -> (Bool,String,[String]){
        let fileManager = FileManager.default
        var filenameList: [String] = []
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: folderPath)
            for fileName in fileNames {
                if !fileName.hasPrefix(".") {
                    filenameList.append(fileName)
                    print(fileName)
                }
            }
        } catch {
            return (false,"Error in iterateFileAtFolder: \(error)",filenameList)
        }
        return (true,"success",filenameList)
    }
    
    
    func chooseFileFromDefaultPanel() -> String{
        let dialog = NSOpenPanel()
        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                print("the path you choose is: \(path)")
                return path
            }
        } else {
            // User clicked on "Cancel"
            return ""
        }
        return ""

    }
    
    
    func copyFile(srcDirPath: String, srcFilename: String, dstDirPath: String, dstFilename: String) -> (Bool,String){
        let fileManager = FileManager.default
        var srcURL = URL(fileURLWithPath: srcDirPath)
        srcURL = srcURL.appendingPathComponent(srcFilename)
        var dstURL = URL(fileURLWithPath: dstDirPath)
        dstURL = dstURL.appendingPathComponent(dstFilename)
        do {
            try fileManager.copyItem(at: srcURL, to: dstURL)
        } catch {
            return (false,"Error in copying data: \(error)")
        }
        return (true,"success")
    }
    
}

