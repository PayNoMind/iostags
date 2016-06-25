import UIKit

public protocol TagProtocol {
  func getTags() -> [String]
  func getTagAtIndex(index: Int) -> String?
}

enum Tags: String {
  case Default = "Add Tag"
}

public class TagDelegate: NSObject {
  private var tags = ["Cheese Burger"]
  private weak var collectionView: UICollectionView?

  private lazy var suggestionView: SuggestionView = {
    return SuggestionView()
  }()

  private lazy var dataSource: CollectionArrayDataSource<String, TagCell> = {
    let ds = CollectionArrayDataSource<String, TagCell>(anArray: [self.tags], withCellIdentifier: String(TagCell), andCustomizeClosure: self.customizeCell)
    return ds
  }()

  public convenience init(collectionView: UICollectionView) {
    self.init()
    collectionView.dataSource = dataSource
    self.collectionView = collectionView
  }

  func customizeCell(cell: TagCell, item: String, path: NSIndexPath) {
    cell.tagTitle = item
    cell.insertNewTag = { cell in

    guard let currentIndexPath = self.collectionView?.indexPathForCell(cell)
      else { return }

      self.tags.append("")
      self.dataSource.updateData([self.tags])

      let newIndexPath = NSIndexPath(forRow: currentIndexPath.row+1, inSection: currentIndexPath.section)
      self.collectionView?.insertItemsAtIndexPaths([newIndexPath])

      if let newCell = self.collectionView?.cellForItemAtIndexPath(newIndexPath) as? TagCell {
        newCell.textField.becomeFirstResponder()
      }
    }
    cell.textField.addTarget(self, action: #selector(TagDelegate.tagTextChanged), forControlEvents: .EditingChanged)
    cell.textField.inputAccessoryView = suggestionView
  }

  @objc
  private func tagTextChanged(textField: UITextField) {
    if let tagText = textField.text where !tagText.characters.isEmpty {

    }
    collectionView?.collectionViewLayout.invalidateLayout()
  }
}

extension TagDelegate: UICollectionViewDelegateFlowLayout {
  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TagCell, tagText = cell.textField.text, font = cell.textField.font {
      let width = CellWidth.widthOf(Text: tagText, withFont: font)
      return CGSize(width: width, height: collectionView.bounds.height)
    }
    return CGSize(width: 20, height: collectionView.bounds.height)
  }
}

extension TagDelegate: TagsInterface {
  public func getAllTags() -> Set<String> {
    return Set(tags)
  }

  public func getTagsByPrefix(prefix: String) -> [String] {
    return tags.filter {
      return $0.hasPrefix(prefix)
    }
  }

  public func insertTag(tag: String) {
    tags.append(tag)
  }
}
