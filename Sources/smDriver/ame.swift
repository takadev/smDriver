//
//  ame.swift
//  smDriver
//
//  Created by Takahiro Kaneko on 2018/07/02.
//

import Foundation
import GD

class Ame {
    
    private let WIDTH : Int32 = 770
    private let HEIGHT : Int32 = 480
    
    enum Const: String {
        case AmeDir = "~/.ame"
        case AmeshURL = "http://tokyo-ame.jwa.or.jp"
        case Map000J = "map000.jpg"
        case Map000P = "map000.pnm"
        case Msk000 = "msk000.png"
        case AmeImg = "ame.gif"
        case DefaultLocation = "Asia/Tokyo"
    }
    
    let loader = Donwloader()
    
    func getAme() {
        
        let file = File()
        let ameDir = NSString(string: Const.AmeDir.rawValue).expandingTildeInPath
        file.createDir(path: ameDir)

        let orgUrl = Const.AmeshURL.rawValue + "/map/"
        let mapUrl = orgUrl + Const.Map000J.rawValue
        let mapFilePath = ameDir + "/" + Const.Map000P.rawValue
        loader.downLoad(url: mapUrl, destPath: mapFilePath)

        let mskUrl = orgUrl + Const.Msk000.rawValue
        let mskFilePath = ameDir + "/" + Const.Msk000.rawValue
        loader.downLoad(url: mskUrl, destPath: mskFilePath)

        let timeUrl = Const.AmeshURL.rawValue + "/scripts/mesh_index.js"
        var partString : String = ""
        loader.get(url:timeUrl, completionHandler: { (data, response, error) in
            let timeStr = String(data: data!, encoding: String.Encoding.utf8) ?? ""
            partString = String(timeStr[timeStr.index(timeStr.startIndex, offsetBy: 21)..<timeStr.index(timeStr.startIndex, offsetBy: 33)])
        })
        
        let imageUrl = Const.AmeshURL.rawValue + "/mesh/000/" + partString + ".gif"
        let ameFilePath = ameDir + "/" + Const.AmeImg.rawValue
        loader.downLoad(url: imageUrl, destPath: ameFilePath)
        
        let mapFile = fopen(mapFilePath, "rb")
        defer { fclose(mapFile) }
        let mskFile = fopen(mskFilePath, "rb")
        defer { fclose(mskFile) }
        let ameFile = fopen(ameFilePath, "rb")
        defer { fclose(mskFile) }
        let tmpFile = fopen(ameDir + "/tmp.jpg", "wb")
        defer { fclose(tmpFile) }
        
        let dispImage = gdImageCreate(WIDTH, HEIGHT);
        let mapImage = gdImageCreateFromJpeg(mapFile)
        gdImageCopy(dispImage, mapImage, 0, 0, 0, 0, WIDTH, HEIGHT)
        let maskImage = gdImageCreateFromPng(mskFile)
        gdImageCopy(dispImage, maskImage, 0, 0, 0, 0, WIDTH, HEIGHT)
        let ameImage = gdImageCreateFromGif(ameFile)
        gdImageCopy(dispImage, ameImage, 0, 0, 0, 0, WIDTH, HEIGHT)
        gdImagePng(dispImage, tmpFile)
    }
}
