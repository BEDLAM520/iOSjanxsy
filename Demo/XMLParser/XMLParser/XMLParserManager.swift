//
//  XMLParserManager.swift
//  XMLParser
//
//  Created by user on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

import UIKit

class XMLParserManager: NSObject {
    
    fileprivate var currentElementName = ""
    fileprivate var currentElementTitle = ""
    fileprivate var currentElementPudate = ""
    fileprivate var currentElementDescription = ""
    
    fileprivate var docmentDatas = [(title: String, pubDate: String, description: String)]()
    fileprivate var complectionAction: ((_ dataArray: Array<(title: String, pubDate: String, description: String)>)-> Void)?
    
    func requestData(urlStr: String, complection: ((_ dataArray: Array<(title: String, pubDate: String, description: String)>)-> Void)?) {
        
        complectionAction = complection
        
        guard let url = URL(string: urlStr) else {
            print("url is invalid")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, respose, err) in
            
            if let error = err {
                print(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
            }.resume()
        
    }
}

extension XMLParserManager: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("start")
        
        docmentDatas.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("startele  \(elementName)  \(String(describing: namespaceURI))  \(String(describing: qName))  \(attributeDict)")
        
        currentElementName = elementName
        
        if currentElementName == "item" {
            currentElementTitle = ""
            currentElementDescription = ""
            currentElementPudate = ""
        }
    }
    
    /// 因为不止item里有title这些元素，所以不能等于，而在start里面name为item的时候重新开始了
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("found  \(string)")
        
        switch currentElementName {
        case "description":
            currentElementDescription += string
        case "title":
            print("title --\(string)--")
            currentElementTitle += string
        case "pubDate":
            currentElementPudate += string
        default: break
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("didele  \(elementName)   \(String(describing: namespaceURI))   \(String(describing: qName))")
        
        if elementName == "item" {
            docmentDatas.append((title: currentElementTitle, pubDate: currentElementPudate, description: currentElementDescription))
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("did")
        print(docmentDatas)
        
        complectionAction?(docmentDatas)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}

