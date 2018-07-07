//
//  downloader.swift
//  smDriver
//
//  Created by Takahiro Kaneko on 2018/07/02.
//

import Foundation

class Donwloader {
    
    let client = HttpRequest()

    func get(url:String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let remoteUrl = URL(string: url)
        self.client.get(url: remoteUrl!, completionHandler:{ (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Error HTTP Request URL : " + url)
                    exit(1)
                }
                completionHandler(data, response, error)
            }
            else
            {
                print("Error HTTP Request URL : " + url)
                print("Error debug description is : " + error.debugDescription)
                exit(1)
            }
        })
    }
    
    
    func downLoad(url:String, destPath:String) {
        
        if FileManager.default.fileExists(atPath: destPath) == false {
            let remoteUrl = URL(string: url)
            self.client.download(url: remoteUrl!, completionHandler: { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
        
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        if statusCode != 200 {
                            print("Error HTTP Request URL : " + url)
                            exit(1)
                        }
                    }

                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: URL(fileURLWithPath: destPath))
                    } catch (_) {
                        print("Error writing file : " + destPath)
                        exit(1)
                    }
                } else {
                    print("Failure");
                    exit(1)
                }
            })
        }
    }
}
