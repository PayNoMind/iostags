import UIKit

enum Tags: String {
  case Default = "Add Tag"
}

open class TagDelegate: NSObject {
  fileprivate var tags = [String]()

  fileprivate weak var collectionView: UICollectionView?
  fileprivate weak var currentCell: TagCell?

  fileprivate lazy var parser: TagParser = TagParser(tags: self.tagDataSource)

  fileprivate lazy var collectionDataSource: CollectionArrayDataSource<String, TagCell> = {
    return CollectionArrayDataSource<String, TagCell>(anArray: [self.tags as! Array<_>], withCellIdentifier: String(TagCell), andCustomizeClosure: self.customizeCell)
  }()

  fileprivate var textEntryController: TextEntryController? {
    didSet {
      textEntryController?.suggestions = getSuggestions
    }
  }

  public convenience init(collectionView: UICollectionView, tags: [String]) {
    self.init()
    self.tags = tags
    collectionView.dataSource = collectionDataSource
    self.collectionView = collectionView
  }

  open var ownerController: UIViewController!

  open var tagDataSource: TagsDataSource!

  fileprivate func getSuggestions(_ item: String, closure: ([TagParser.TagContainer]) -> Void) {
    let items = parser.parse(item)
    closure(items)
  }

  fileprivate func passText(_ text: String) {
    currentCell?.tagTitle = text
    collectionView?.collectionViewLayout.invalidateLayout()
  }

  fileprivate func customizeCell(_ cell: TagCell, item: String, path: IndexPath) {
    cell.tagTitle = item
    cell.insertNewTag = { cell in

      guard let currentIndexPath = self.collectionView?.indexPath(for: cell)
        else { return }

      self.tags.append("")
      self.collectionDataSource.updateData([self.tags])

      let newIndexPath = IndexPath(row: currentIndexPath.row+1, section: currentIndexPath.section)
      self.collectionView?.insertItems(at: [newIndexPath])
    }
    currentCell = cell
  }
}

extension TagDelegate: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? TagCell
      else { return }

    textEntryController = TextEntryController(nibName: String(TextEntryController), bundle: Bundle(for: type(of: self)))

    textEntryController?.textPass = passText

    if let textEntry = textEntryController {
      self.ownerController.present(textEntry, animated: true) {
        textEntry.text = cell.tagTitle
      }
    }
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let cell = collectionView.cellForItem(at: indexPath) as? TagCell,
    let tagText = cell.tagLabel.text, let font = cell.tagLabel.font
      else { return CGSize(width: 20, height: collectionView.bounds.height) }

    let width = cell.cellWidth ?? CellWidth.widthOf(Text: tagText, withFont: font)
    return CGSize(width: width, height: collectionView.bounds.height)
  }
}
