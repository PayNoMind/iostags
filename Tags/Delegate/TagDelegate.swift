import UIKit

open class TagDelegate: NSObject {
  private lazy var parser: TagParser = TagParser(tags: self.tagDataSource)

  private(set) lazy var collectionDataSource: CollectionArrayDataSource<Tag, TagCell> = {
    return CollectionArrayDataSource<Tag, TagCell>(anArray: [self.tags], withCellIdentifier: String(describing: TagCell.self), andCustomizeClosure: self.customizeCell)
  }()

  private var textEntryController: TagEntryController? {
    didSet {
      textEntryController?.suggestions = getSuggestions
    }
  }

  private var tags = [Tag]()

  weak var collectionView: UICollectionView?
  open var tagDataSource: TagsDataSource!

  public convenience init(tags: [String]) {
    self.init()
    self.tags = tags.map { Tag.tag($0) }
  }

  open func update(Tags tags: [Tag]) {
    self.tagDataSource.insert(Tags: tags.toStringSet)
    self.tags = tags + (tags.isEmpty ? [Tag.addTag] : [])
    collectionDataSource.updateData([self.tags])
  }

  open func getTags() -> OrderedSet<Tag> {
    let tags = self.tags.filter {
      return $0 != Tag.addTag
    }
    return OrderedSet<Tag>(tags)
  }

  open func tapCellAndCollection() {
    let storyBoard = UIStoryboard(name: "TagPresentation", bundle: Bundle.tagBundle)
    let root = storyBoard.instantiateInitialViewController() as? UINavigationController

    textEntryController = root?.topViewController as? TagEntryController
    textEntryController?.tagPassBack = passText

    if let navController = root, let textEntry = textEntryController {
      textEntry.tags = TagContainer(tags: tags)
      self.presentOnRootController(navController)
    }
  }

  // TODO: - Make this more robust
  private func presentOnRootController(_ controller: UIViewController) {
    if let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      if let temp = navController.topViewController?.presentedViewController {
       temp.present(controller, animated: true, completion: nil)
      } else {
        navController.topViewController?.present(controller, animated: true, completion: nil)
      }
    } else {
      UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
    }
  }

  private func getSuggestions(_ item: String, closure: ([Tag]) -> Void) {
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
