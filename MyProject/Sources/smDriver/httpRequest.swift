//
//  httpReuest.swift
//  smDriver
//
//  Created by Takahiro Kaneko on 2018/07/02.
//

import Foundation

class HttpRequest {
    
    let session: URLSession = URLSession.shared
    let sem = DispatchSemaphore(value: 0);
    
    func get(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        session.dataTask(with: url, completionHandler: {(data, response, error) in completionHandler(data, response, error)
            self.sem.signal()
        }).resume()
        self.sem.wait()
    }

    func download(url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) {
        session.downloadTask(with: url, completionHandler: {(url, response, error) in completionHandler(url, response, error)
            self.sem.signal()
        }).resume()
        self.sem.wait()
    }
}
