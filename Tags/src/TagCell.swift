//
//  TagCell.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2015 Fluiddynamics. All rights reserved.
//

import UIKit

@IBDesignable
public class TagCell: UICollectionViewCell {
  @IBInspectable var FontSize: CGFloat = 14.0
  @IBInspectable let CornerRadius: CGFloat = 5.0
  @IBInspectable let BorderWidth: CGFloat = 0.5
  @IBInspectable let BorderColor = UIColor.blackColor().CGColor
  @IBInspectable let Padding: CGFloat = 5.0

  public var textField: UITextField!
  public var text: String = ""

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    textField = UITextField(frame: bounds)
    textField.font = UIFont.systemFontOfSize(FontSize)
    textField.text = text
    addSubview(textField)
    layer.cornerRadius = CornerRadius
    layer.borderWidth = BorderWidth
    layer.borderColor = BorderColor
  }
  override public func layoutSubviews() {
    var size = bounds.size
    size.width -= Padding
    textField.frame = CGRect(origin: CGPointMake(Padding, 0), size: size)
  }
}
