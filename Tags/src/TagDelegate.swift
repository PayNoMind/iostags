import UIKit

enum Tags: String {
  case defaultName = "Add Tag"
}

open class TagDelegate: NSObject {
  fileprivate var tags = [String]()

  fileprivate weak var collectionView: UICollectionView?
  fileprivate weak var currentCell: TagCell?

  fileprivate lazy var parser: TagParser = TagParser(tags: self.tagDataSource)

  fileprivate lazy var collectionDataSource: CollectionArrayDataSource<String, TagCell> = {
    return CollectionArrayDataSource<String, TagCell>(anArray: [self.tags], withCellIdentifier: String(describing: TagCell.self), andCustomizeClosure: self.customizeCell)
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

  fileprivate func passText(_ text: [String]) {
    self.collectionDataSource.updateData([text])
    self.collectionView?.reloadData()
  }

  fileprivate func customizeCell(_ cell: TagCell, item: String, path: IndexPath) {
    cell.tagTitle = item
    currentCell = cell
  }
}

extension TagDelegate: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let sb = UIStoryboard(name: "TagPresentation", bundle: Bundle.tagBundle)
    let root = sb.instantiateInitialViewController() as? UINavigationController
    textEntryController = root?.topViewController as? TextEntryController

    textEntryController?.tagPassBack = passText

    if let rv = root, let textEntry = textEntryController {
      textEntry.tags = self.tags
      self.ownerController.present(rv, animated: true, completion: nil)
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
