//
// AEXML.swift
//
// Copyright (c) 2014 Marko Tadic - http://markotadic.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

open class AEXMLElement {
    
    // MARK: Properties
    
    open fileprivate(set) weak var parent: AEXMLElement?
    open fileprivate(set) var children: [AEXMLElement] = [AEXMLElement]()
    
    public let name: String
    open fileprivate(set) var attributes: [AnyHashable: Any]
    open var value: String?
    
    open var stringValue: String {
        return value ?? String()
    }
    open var boolValue: Bool {
        return stringValue.lowercased() == "true" || Int(stringValue) == 1 ? true : false
    }
    open var intValue: Int {
        return Int(stringValue) ?? 0
    }
    open var doubleValue: Double {
        return (stringValue as NSString).doubleValue
    }
    
    // MARK: Lifecycle
    
    public init(_ name: String, value: String? = nil, attributes: [AnyHashable: Any] = [AnyHashable: Any]()) {
        self.name = name
        self.attributes = attributes
        self.value = value
    }
    
    // MARK: XML Read
    
    // this element name is used when unable to find element
    open class var errorElementName: String { return "AEXMLError" }
    
    // non-optional first element with given name (<error> element if not exists)
    open subscript(key: String) -> AEXMLElement {
        if name == AEXMLElement.errorElementName {
            return self
        } else {
            let filtered = children.filter { $0.name == key }
            return filtered.count > 0 ? filtered.first! : AEXMLElement(AEXMLElement.errorElementName, value: "element <\(key)> not found")
        }
    }
    
    open var all: [AEXMLElement]? {
        return parent?.children.filter { $0.name == self.name }
    }
    
    open var first: AEXMLElement? {
        return all?.first
    }
    
    open var last: AEXMLElement? {
        return all?.last
    }
    
    open var count: Int {
        return all?.count ?? 0
    }
    
    open func allWithAttributes <K: NSObject, V: AnyObject> (_ attributes: [K : V]) -> [AEXMLElement]? where K: Equatable, V: Equatable {
        var found = [AEXMLElement]()
        if let elements = all {
            for element in elements {
                var countAttributes = 0
                for (key, value) in attributes {
                    if element.attributes[key] as? V == value {
                        countAttributes += 1
                    }
                }
                if countAttributes == attributes.count {
                    found.append(element)
                }
            }
            return found.count > 0 ? found : nil
        } else {
            return nil
        }
    }
    
    open func countWithAttributes <K: NSObject, V: AnyObject> (_ attributes: [K : V]) -> Int where K: Equatable, V: Equatable {
        return allWithAttributes(attributes)?.count ?? 0
    }
    
    // MARK: XML Write
    
    open func addChild(_ child: AEXMLElement) -> AEXMLElement {
        child.parent = self
        children.append(child)
        return child
    }
    
    open func addChild(name: String, value: String? = nil, attributes: [AnyHashable: Any] = [AnyHashable: Any]()) -> AEXMLElement {
        let child = AEXMLElement(name, value: value, attributes: attributes)
        return addChild(child)
    }
    
    open func addAttribute(_ name: NSObject, value: AnyObject) {
        attributes[name] = value
    }
    
    open func addAttributes(_ attributes: [AnyHashable: Any]) {
        for (attributeName, attributeValue) in attributes {
            addAttribute(attributeName as NSObject, value: attributeValue as AnyObject)
        }
    }
    
    fileprivate var parentsCount: Int {
        var count = 0
        var element = self
        while let parent = element.parent {
            count += 1
            element = parent
        }
        return count
    }
    
    fileprivate func indentation(_ count: Int) -> String {
        var indent = String()
        if count > 0 {
            for _ in 0..<count {
                indent += "\t"
            }
        }
        return indent
    }
    
    open var xmlString: String {
        var xml = String()
        
        // open element
        xml += indentation(parentsCount - 1)
        xml += "<\(name)"
        
        if attributes.count > 0 {
            // insert attributes
            for att in attributes {
                xml += " \(att.0.description)=\"\((att.1 as AnyObject).description)\""
            }
        }
        
        if value == nil && children.count == 0 {
            // close element
            xml += " />"
        } else {
            if children.count > 0 {
                // add children
                xml += ">\n"
                for child in children {
                    xml += "\(child.xmlString)\n"
                }
                // add indentation
                xml += indentation(parentsCount - 1)
                xml += "</\(name)>"
            } else {
                // insert string value and close element
                xml += ">\(stringValue)</\(name)>"
            }
        }
        
        return xml
    }
    
    open var xmlStringCompact: String {
        let chars = CharacterSet(charactersIn: "\n\t")
        return xmlString.components(separatedBy: chars).joined(separator: "")
    }
}

// MARK: -

open class AEXMLDocument: AEXMLElement {
    
    // MARK: Properties
    
    public let version: Double
    public let encoding: String
    public let standalone: String
    
    open var root: AEXMLElement {
        return children.count == 1 ? children.first! : AEXMLElement(AEXMLElement.errorElementName, value: "XML Document must have root element.")
    }
    
    // MARK: Lifecycle
    
    public init(version: Double = 1.0, encoding: String = "utf-8", standalone: String = "no", root: AEXMLElement? = nil) {
        // set document properties
        self.version = version
        self.encoding = encoding
        self.standalone = standalone
        
        // init super with default name
        super.init("AEXMLDocument")
        
        // document has no parent element
        parent = nil
        
        // add root element to document (if any)
        if let rootElement = root {
            addChild(rootElement)
        }
    }
    
    public convenience init(version: Double = 1.0, encoding: String = "utf-8", standalone: String = "no", xmlData: Data) throws {
        self.init(version: version, encoding: encoding, standalone: standalone)
        if let parseError = readXMLData(xmlData) {
            throw parseError
        }
    }
    
    // MARK: Read XML
    
    open func readXMLData(_ data: Data) -> NSError? {
        children.removeAll(keepingCapacity: false)
        let xmlParser = AEXMLParser(xmlDocument: self, xmlData: data)
        return xmlParser.tryParsing() ?? nil
    }
    
    // MARK: Override
    
    open override var xmlString: String {
        var xml =  "<?xml version=\"\(version)\" encoding=\"\(encoding)\" standalone=\"\(standalone)\"?>\n"
        for child in children {
            xml += child.xmlString
        }
        return xml
    }
    
}

// MARK: -

class AEXMLParser: NSObject, XMLParserDelegate {
    
    // MARK: Properties
    
    let xmlDocument: AEXMLDocument
    let xmlData: Data
    
    var currentParent: AEXMLElement?
    var currentElement: AEXMLElement?
    var currentValue = String()
    var parseError: NSError?
    
    // MARK: Lifecycle
    
    init(xmlDocument: AEXMLDocument, xmlData: Data) {
        self.xmlDocument = xmlDocument
        self.xmlData = xmlData
        currentParent = xmlDocument
        super.init()
    }
    
    // MARK: XML Parse
    
    func tryParsing() -> NSError? {
        var success = false
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        success = parser.parse()
        return success ? nil : parseError
    }
    
    // MARK: NSXMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentValue = String()
        currentElement = currentParent?.addChild(name: elementName, attributes: attributeDict)
        currentParent = currentElement
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string ?? String()
        let newValue = currentValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        currentElement?.value = newValue == String() ? nil : newValue
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentParent = currentParent?.parent
        currentElement = nil
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseError = parseError as NSError?
    }
    
}
