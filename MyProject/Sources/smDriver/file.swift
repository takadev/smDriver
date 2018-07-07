//
//  file.swift
//  smDriver
//
//  Created by Takahiro Kaneko on 2018/07/02.
//

import Foundation

class File {
    
    func createDir(path:String) {
        
        if FileManager.default.fileExists(atPath: path) == false {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error can't create directory : " + path)
                exit(1)
            }
        }
    }
}
