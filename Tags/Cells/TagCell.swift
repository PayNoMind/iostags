import UIKit

public class TagCell: UICollectionViewCell {
  @IBInspectable var cornerRadius = CGFloat(5.0)
  @IBInspectable var borderWidth = CGFloat(0.5)
  @IBInspectable var borderColor = UIColor.blackColor().CGColor

  @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var textTrailingConstraint: NSLayoutConstraint!

  @IBOutlet weak var textField: UITextField! {
    didSet {
      textField.delegate = self
    }
  }

  private let newTagCell = " "

  var insertNewTag: (UICollectionViewCell -> Void)?

  public var tagTitle: String = "" {
    didSet {
      textField.text = tagTitle
    }
  }

  var cellWidth: CGFloat? {
    if let tagText = textField.text, font = textField.font where !tagText.isEmpty {
      let width = CellWidth.widthOf(Text: tagText, withFont: font)

      let widthSum = width + leadingConstraint.constant + textTrailingConstraint.constant + 5

      return widthSum
    }
    return nil
  }

  public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
    if let cellWidth = cellWidth {
      layoutAttributes.bounds.size.width = cellWidth
    }
    textField.setNeedsDisplay()

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

    if string.hasSuffix(newTagCell) {
      insertNewTag?(self)
      return false
    }
    return true
  }
}
