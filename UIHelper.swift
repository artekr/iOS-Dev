//
//  UIHelper.swift
//  Festival
//
//  Created by Heng Wang on 2015-12-15.
//  Copyright © 2015 Heng Wang. All rights reserved.
//

import UIKit
import MapKit

class UIHelper {
  
  // Basic color collection
  static let ultraLightGreyColor = UIHelper.UIColorFromRGB("F5F5F5")
  static let lightGreyColor = UIHelper.UIColorFromRGB("EEEEEE")
  static let mediumGreyColor = UIHelper.UIColorFromRGB("E0E0E0")
  // 1565C0 blue
  // D32F2F red
  
  static let NavigationBarColor = UIHelper.UIColorFromRGB("E8624A")
  
  class func getScreenRect() -> CGRect {
    return UIScreen.main.bounds
  }
  
  class func UIColorFromRGB(_ colorCode: String, alpha: Float = 1.0) -> UIColor {
    let scanner = Scanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt32(&color)
    
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
    let b = CGFloat(Float(Int(color) & mask)/255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
  }
  
  class func regularAlert(_ title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "好吧", style: .default, handler: nil)
    alert.addAction(action)
    return alert
  }
  
  class func updateDateFormatter() -> DateFormatter {
    let updateDateFormatter = DateFormatter()
    updateDateFormatter.dateStyle = .medium
    updateDateFormatter.timeStyle = .medium
    return updateDateFormatter
  }
  
  class func chineseItalicFontWithSize(_ size: CGFloat) -> UIFont {
    let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(15 * .pi / 180)), d: 1, tx: 0, ty: 0)
    let fontDesc = UIFontDescriptor(name: UIFont.systemFont(ofSize: size).fontName , matrix: matrix)
    return UIFont(descriptor: fontDesc, size: size)
  }
  
  
  class func setTextViewString(_ text: String, withLinceSpacing space: CGFloat) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = space
    
    let attributes = [
      NSParagraphStyleAttributeName: paragraphStyle
    ]
    return NSAttributedString(string: text, attributes: attributes)
  }
  
  
  
  //*******************************************************************************
  // MARK: - Image related
  class func addGradientLayerOn(_ frame: CGRect, withColors colors: [AnyObject], startPos: CGPoint, endPos: CGPoint) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = frame
    gradientLayer.colors = colors
    gradientLayer.startPoint = startPos
    gradientLayer.endPoint = endPos
    
    return gradientLayer
  }
  
  
  class func imageWithColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  
  
  class func converToRoundImageView(_ imageView: UIImageView, borderWith: CGFloat = 0.0) {
    imageView.layer.cornerRadius = imageView.frame.width / 2
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = borderWith
    imageView.layer.borderColor = UIColor.white.cgColor
  }
  
  class func addBlurEffectToImageView(_ imageView: UIImageView, style: UIBlurEffectStyle = .light) {
    let effect = UIBlurEffect(style: style)
    let effectView = UIVisualEffectView(effect: effect)
    effectView.frame = imageView.bounds
    imageView.addSubview(effectView)
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
  }
  
  class func scaleImage(_ sourceImage: UIImage, toWidth newWidth: CGFloat) -> UIImage {
    let oldWidth = sourceImage.size.width
    let scaleFactor = newWidth / oldWidth
    
    let newHeight = sourceImage.size.height * scaleFactor
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return newImage!;
    
  }
  
  //*******************************************************************************
  // MARK: - Location related
  class func getLocationFromAddressString(_ address: String) -> CLLocationCoordinate2D {
    
    let GOOGLE_MAP_API_URL = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@"
    var latitude = 0.0
    var longitude = 0.0
    var result: String
    
    let encodeAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    
    let request = String(format: GOOGLE_MAP_API_URL, encodeAddress!)
    
    do {
      result = try String(contentsOf: URL(string: request)!, encoding: String.Encoding.utf8)
      let scanner = Scanner(string: result)
      if scanner.scanUpTo("\"lat\" :", into: nil) && scanner.scanString("\"lat\" :", into: nil) {
        scanner.scanDouble(&latitude)
        if scanner.scanUpTo("\"lng\" :", into: nil) && scanner.scanString("\"lng\" :", into: nil) {
          scanner.scanDouble(&longitude)
        }
      }
    } catch let error as NSError {
      print("Oops...Can't find the location. Error: \(error)")
    }
  
    var location = CLLocationCoordinate2D()
    location.latitude = latitude
    location.longitude = longitude
    
    return location
  }
  
  
  // NSDate function
  class func fullDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter
  }
  
  class func monthDayFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM dd"
    
    return dateFormatter
  }
  
  class func getDaysFrom(_ startDate: Date, toDate endDate: Date) -> Int {
    
    let gregorianCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let components: DateComponents = (gregorianCalendar as NSCalendar).components(.day, from: startDate, to: endDate, options: .wrapComponents)
    
    return components.day!
  }
  
}
//#####################################################################
// MARK: - UIView Extension
extension UIView {
  func addBottomBorder() {
    let bottomBorder = CALayer()
    bottomBorder.frame = CGRect(x: 0.0, y: self.frame.height, width: self.frame.width, height: 0.8);
    bottomBorder.backgroundColor = UIHelper.mediumGreyColor.cgColor
    self.layer.addSublayer(bottomBorder)
  }

}


//#####################################################################
// MARK: - UIImage Extension
extension UIImage {
  
  var highestQualityJPEGNSData: Data { return UIImageJPEGRepresentation(self, 1.0)! }
  var highQualityJPEGNSData: Data    { return UIImageJPEGRepresentation(self, 0.75)!}
  var mediumQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.5)! }
  var lowQualityJPEGNSData: Data     { return UIImageJPEGRepresentation(self, 0.25)!}
  var lowestQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.0)! }
  
  
  class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
    let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
}

//#####################################################################
// MARK: - UINavigationBar Extension
var key: String = "coverView"
extension UINavigationBar {
  
  var coverView: UIView? {
    get {
      // 这句的意思大概可以理解为利用key在self中取出对应的对象,如果没有key对应的对象就返回nil
      return objc_getAssociatedObject(self, &key) as? UIView
    }
    
    set {
      objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  func setBarBackgroundColor(_ color: UIColor) {
    if let coverView = self.coverView {
      coverView.backgroundColor = color
    } else {
      self.setBackgroundImage(UIImage(), for: .default)
      self.shadowImage = UIImage()
      let view = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.size.width, height: self.bounds.height + 20))
      view.tag = 1
      view.isUserInteractionEnabled = false
      view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      self.insertSubview(view, at: 0)
      
      view.backgroundColor = color
      self.coverView = view
    }
  }
  
  func setBarBackgroundColorAlpha(_ alpha: CGFloat) {
    
    guard let coverView = self.coverView else {
      return
    }
    self.coverView!.backgroundColor = coverView.backgroundColor?.withAlphaComponent(alpha)
  }

}


extension UISegmentedControl {
  func removeBorders() {
    setBackgroundImage(UIHelper.imageWithColor(UIColor.init(white: 1.0, alpha: 0.2)), for: UIControlState(), barMetrics: .default)
    setBackgroundImage(UIHelper.imageWithColor(UIColor.init(white: 1.0, alpha: 1.0)), for: .selected, barMetrics: .default)
    setDividerImage(UIHelper.imageWithColor(UIColor.clear), forLeftSegmentState: UIControlState(), rightSegmentState: UIControlState(), barMetrics: .default)
  }
}
