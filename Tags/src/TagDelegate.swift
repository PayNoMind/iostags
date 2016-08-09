import UIKit

enum Tags: String {
  case Default = "Add Tag"
}

public class TagDelegate: NSObject {
  private var tags = [String]()

  private weak var collectionView: UICollectionView?
  private weak var currentCell: TagCell?

  private lazy var parser: TagParser = TagParser(tags: self.tagDataSource)

  private lazy var collectionDataSource: CollectionArrayDataSource<String, TagCell> = {
    return CollectionArrayDataSource<String, TagCell>(anArray: [self.tags], withCellIdentifier: String(TagCell), andCustomizeClosure: self.customizeCell)
  }()

  private var textEntryController: TextEntryController? {
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

  public var ownerController: UIViewController!

  public var tagDataSource: TagsDataSource!

  private func getSuggestions(item: String, closure: [TagParser.TagContainer] -> Void) {
    let items = parser.parse(item)
    closure(items)
  }

  private func passText(text: String) {
    currentCell?.tagTitle = text
    collectionView?.collectionViewLayout.invalidateLayout()
  }

  private func customizeCell(cell: TagCell, item: String, path: NSIndexPath) {
    cell.tagTitle = item
    cell.insertNewTag = { cell in

      guard let currentIndexPath = self.collectionView?.indexPathForCell(cell)
        else { return }

      self.tags.append("")
      self.collectionDataSource.updateData([self.tags])

      let newIndexPath = NSIndexPath(forRow: currentIndexPath.row+1, inSection: currentIndexPath.section)
      self.collectionView?.insertItemsAtIndexPaths([newIndexPath])
    }
    currentCell = cell
  }
}

extension TagDelegate: UICollectionViewDelegateFlowLayout {
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TagCell
      else { return }

    textEntryController = TextEntryController(nibName: String(TextEntryController), bundle: NSBundle(forClass: self.dynamicType))

    textEntryController?.textPass = passText

    if let textEntry = textEntryController {
      self.ownerController.presentViewController(textEntry, animated: true) {
        textEntry.text = cell.tagTitle
      }
    }
  }

  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TagCell,
    tagText = cell.tagLabel.text, font = cell.tagLabel.font
      else { return CGSize(width: 20, height: collectionView.bounds.height) }

    let width = cell.cellWidth ?? CellWidth.widthOf(Text: tagText, withFont: font)
    return CGSize(width: width, height: collectionView.bounds.height)
  }
}
