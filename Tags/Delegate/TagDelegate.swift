import UIKit

open class TagDelegate: NSObject {
  fileprivate weak var collectionView: UICollectionView?

  fileprivate lazy var parser: TagParser = TagParser(tags: self.tagDataSource)

  fileprivate lazy var collectionDataSource: CollectionArrayDataSource<Tag, TagCell> = {
    return CollectionArrayDataSource<Tag, TagCell>(anArray: [self.tags], withCellIdentifier: String(describing: TagCell.self), andCustomizeClosure: self.customizeCell)
  }()

  private var textEntryController: TextEntryController? {
    didSet {
      textEntryController?.suggestions = getSuggestions
    }
  }

  private var tags = [Tag]()

  public convenience init(collectionView: UICollectionView, tags: [String]) {
    self.init()
    self.tags = tags.map { Tag.tag($0) }
    collectionView.dataSource = collectionDataSource
    self.collectionView = collectionView
  }

  open var ownerController: UIViewController!

  open var tagDataSource: TagsDataSource!

  open func update(Tags tags: [Tag]) {
    self.tagDataSource.insert(Tags: tags.toStringSet)
    self.tags = tags + (tags.isEmpty ? [Tag.addTag] : [])
    collectionDataSource.updateData([self.tags])
  }

  open func getTags() -> Set<Tag> {
    return tags.filter {
      return $0 != Tag.addTag
    }.toSet
  }

  open func tapCellAndCollection() {
    let sb = UIStoryboard(name: "TagPresentation", bundle: Bundle.tagBundle)
    let root = sb.instantiateInitialViewController() as? UINavigationController

    textEntryController = root?.topViewController as? TextEntryController
    textEntryController?.tagPassBack = passText

    if let rv = root, let textEntry = textEntryController {
      textEntry.tags = tags
      self.ownerController.present(rv, animated: true, completion: nil)
    }
  }

  private func getSuggestions(_ item: String, closure: ([TagParser.TagContainer]) -> Void) {
    let items = parser.parse(item)
    closure(items)
  }

  private func passText(_ tags: [Tag]) {
    self.update(Tags: tags)
    self.collectionView?.reloadData()
  }

  private func customizeCell(_ cell: TagCell, item: Tag, path: IndexPath) {
    cell.tagTitle = item.value
  }
}

extension TagDelegate: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.tapCellAndCollection()
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let cell = collectionView.cellForItem(at: indexPath) as? TagCell,
    let tagText = cell.tagLabel.text, let font = cell.tagLabel.font
      else { return CGSize(width: 20, height: collectionView.bounds.height) }

    let width = cell.cellWidth ?? CellWidth.widthOf(Text: tagText, withFont: font)
    return CGSize(width: width, height: collectionView.bounds.height)
  }
}
