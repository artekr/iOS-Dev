//
//  RegexParser.swift
//  Test
//
//  Created by Heng Wang on 2016-09-27.
//  Copyright © 2016 Heng Wang. All rights reserved.
//

import Foundation
import UIKit
import Ono

class RegexParser {

  /**
   Create an alert view with default OK button
   
   - parameter title:   Title to be displayed in the alert view
   - parameter message: Message to be displayed in the alert view
   
   - returns: An alert view with title and/or message, along with a default OK button
   */
  static func regularAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    return alert
  }
  
  /**
   Parse the XML stories into the story array
   
   - parameter xmlStories: Story items array in xml format
   
   - returns: An array of story
   */
  static func parseStoriesToArray(xmlStories: [AnyObject]) -> [Story] {
    var stories = [Story]()
    for xmlStory in xmlStories {
      
      let title = xmlStory.firstChildWithTag("title").stringValue()
      let author = xmlStory.firstChildWithTag("author").stringValue()
      let publicationDate = xmlStory.firstChildWithTag("pubDate").stringValue()
      let websiteLink = xmlStory.firstChildWithTag("link").stringValue()
      let imgData = xmlStory.firstChildWithTag("description").stringValue()
      
      let imageLink = imgData.capturedGroups(withRegex: "\'(http:.*)\' />").first
      
      let story = Story(title: title, publicationDate: publicationDate, author: author, websiteLink: websiteLink, imageUrl: imageLink)
      
      stories.append(story)
    }
    return stories
  }
  
  /**
   Parse a string with regex pattern
   
   - parameter regex: Regex pattern
   - parameter text:  Test string to be parsed
   
   - returns: Array of strings that match the regex
   */
  static func matchesForRegexInText(regex: String, text: String) -> [String] {
    
    do {
      let regex = try NSRegularExpression(pattern: regex, options: [])
      let nsString = text as NSString
      let results = regex.matchesInString(text,
                                          options: [], range: NSMakeRange(0, nsString.length))
      return results.map { nsString.substringWithRange($0.range)}
    } catch let error as NSError {
      print("invalid regex: \(error.localizedDescription)")
      return []
    }
  }

}

// MARK: - Helper function
extension String {
  func capturedGroups(withRegex pattern: String) -> [String] {
    var results = [String]()
    
    var regex: NSRegularExpression
    do {
      regex = try NSRegularExpression(pattern: pattern, options: [])
    } catch {
      return results
    }
    
    let matches = regex.matchesInString(self, options: [], range: NSRange(location:0, length: self.characters.count))
    
    guard let match = matches.first else { return results }
    
    let lastRangeIndex = match.numberOfRanges - 1
    guard lastRangeIndex >= 1 else { return results }
    
    for i in 1...lastRangeIndex {
      let capturedGroupIndex = match.rangeAtIndex(i)
      let matchedString = (self as NSString).substringWithRange(capturedGroupIndex)
      results.append(matchedString)
    }
    
    return results
  }
}
