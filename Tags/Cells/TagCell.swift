import UIKit

@IBDesignable
public class TagCell: UICollectionViewCell {
  @IBInspectable var cornerRadius: CGFloat = 5.0
  @IBInspectable var borderWidth: CGFloat = 0.5
  @IBInspectable var borderColor = UIColor.blackColor().CGColor

  @IBOutlet weak var textField: UITextField! {
    didSet {
      textField.delegate = self
    }
  }

  var insertNewTag: (UICollectionViewCell -> Void)?

  public var tagTitle: String = "" {
    didSet {
      textField.text = tagTitle
    }
  }

  public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
    if let tagText = textField.text, font = textField.font where !tagText.isEmpty {
      let width = CellWidth.widthOf(Text: tagText, withFont: font)
      layoutAttributes.frame.size.width = width
    }
    return layoutAttributes
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor
  }
}

extension TagCell: UITextFieldDelegate {
  public func textFieldDidBeginEditing(textField: UITextField) {
    if textField.text == Tags.Default.rawValue {
      textField.text = ""
    }
  }

  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard !string.characters.isEmpty
      else { return true }

    let lastCharacter = string.substringFromIndex(string.endIndex.advancedBy(-1))

    if lastCharacter == " " {
      insertNewTag?(self)
      return false
    }
    
    return true
  }
}
