import UIKit

open class TagCell: UICollectionViewCell {
  @IBInspectable var cornerRadius: CGFloat = CGFloat(5.0)
  @IBInspectable var borderWidth: CGFloat = CGFloat(0.5)
  @IBInspectable var borderColor: UIColor = .black

  @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var trailingConstraint: NSLayoutConstraint!

  @IBOutlet weak var tagLabel: UILabel!

  open var tagTitle: String = "" {
    didSet {
      tagLabel.text = tagTitle
    }
  }

  var cellWidth: CGFloat? {
    if let tagText = tagLabel.text, let font = tagLabel.font, !tagText.isEmpty {
      let width = font.widthOfText(tagText)
      let widthSum = width + leadingConstraint.constant + trailingConstraint.constant + 5

      return widthSum
    }
    return nil
  }

  open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    super.preferredLayoutAttributesFitting(layoutAttributes)
    if let cellWidth = cellWidth {
      layoutAttributes.bounds.size.width = cellWidth
    }
    tagLabel.setNeedsDisplay()

    return layoutAttributes
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor.cgColor
  }
}
