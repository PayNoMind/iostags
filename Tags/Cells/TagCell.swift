import UIKit

class TagCell: UICollectionViewCell {
  private let cornerRadius: CGFloat = 5.0
  private let borderWidth: CGFloat = 0.5
  private let borderColor = UIColor.blackColor().CGColor
  private let padding: CGFloat = 5.0

  @IBOutlet weak var textField: UITextField! {
    didSet {

    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor
  }

  override func layoutSubviews() {
    var size = bounds.size
    size.width -= padding
    textField.frame = CGRect(origin: CGPoint(x: padding, y: 0), size: size)
  }
}
