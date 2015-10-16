import UIKit

protocol TagProtocol {
  func getTags() -> [String]
}

private let FontSize: CGFloat = 14.0
private let CornerRadius: CGFloat = 5.0
private let BorderWidth: CGFloat = 0.5
private let BorderColor = UIColor.blackColor().CGColor
private let StartingWidth: CGFloat = 20.0
private let Padding: CGFloat = 5.0

class TagCell: UICollectionViewCell {
  private var textField: UITextField!
  var text: String = ""

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    textField = UITextField(frame: bounds)
    textField.font = UIFont.systemFontOfSize(FontSize)
    textField.text = text
    addSubview(textField)
    layer.cornerRadius = CornerRadius
    layer.borderWidth = BorderWidth
    layer.borderColor = BorderColor
  }
  override func layoutSubviews() {
    var size = bounds.size
    size.width -= Padding
    textField.frame = CGRect(origin: CGPointMake(Padding, 0), size: size)
  }
}

class CompletionCell: UICollectionViewCell {
  @IBOutlet weak var label: UILabel!
}

class TagDelegate: TagProtocol {
  private var tags: [String] = [String]()
  private var tagDelegate: TagCollectionViewDelegate!
  private var tagDataSource: TagDataSource!
  var currentIndex: Int = 0
  
  convenience init(tags: [String]) {
    self.init()
    var temp = tags
    temp.append("Add Tag")
    self.tags = temp
  }
  
  func setupDelegateAndDataSource(collectionView: UICollectionView, interface: TagsInterface) -> (delegate: TagCollectionViewDelegate, dataSource: TagDataSource) {
    tagDelegate = TagCollectionViewDelegate()
    tagDelegate.delegate = self
    tagDataSource = TagDataSource(collectionView: collectionView, data: interface)
    tagDataSource.delegate = self
    return (tagDelegate, tagDataSource)
  }
  
  func getTags() -> [String] {
    return tags
  }
}

class TagCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
  var delegate: TagDelegate!

  private func getStringSize(string: String) -> CGSize {
    return string.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(FontSize)])
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    var stringSize = ""
    if indexPath.row < delegate.getTags().count {
      stringSize = delegate.getTags()[indexPath.row]
    }
    var size = CGSizeMake(StartingWidth, 20)
    if stringSize != "" {
      size = getStringSize(stringSize)
    }
    return CGSizeMake(size.width + 10, 20)
  }
}

class TagDataSource: NSObject {
  private var currentTextField: UITextField?
  private var delegate: TagDelegate!
  private var collectionView: UICollectionView!
  private lazy var completionView: UICollectionView = {
    let view = self.collectionView
    let _layout = UICollectionViewFlowLayout()
    _layout.scrollDirection = .Horizontal
    _layout.estimatedItemSize = CGSize(width: 100, height: 38)
    _layout.minimumInteritemSpacing = 10
    let _completion = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40), collectionViewLayout: _layout)
    _completion.registerNib(UINib(nibName: "CompletionCell", bundle: nil), forCellWithReuseIdentifier: "completionCell")
    _completion.dataSource = self
    _completion.delegate = self
    return _completion
  }()
  private var parser: TagParser!

  convenience init(collectionView: UICollectionView, data: TagsInterface) {
    self.init()
    self.collectionView = collectionView
    self.parser = TagParser(tags: data)
  }
  func updateSuggestions(tag: TagContainer) {
    if self.completionView.numberOfItemsInSection(0) != tag.suggestedTypes.count {
      completionView.performBatchUpdates({ () -> Void in
        for var x=0; x<self.completionView.numberOfItemsInSection(0); x++ {
          self.completionView.deleteItemsAtIndexPaths([NSIndexPath(forRow: x, inSection: 0)])
        }
        for var x=0; x<tag.suggestedTypes.count; x++ {
          self.completionView.insertItemsAtIndexPaths([NSIndexPath(forRow: x, inSection: 0)])
        }
        }) { (complete) -> Void in
          
      }
    }
  }
}

extension TagDataSource: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return collectionView === completionView
  }
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CompletionCell, tf = currentTextField {
      tf.text = ":\(cell.label.text!)"
      tagTextChanged(tf)
    }
  }
}

extension TagDataSource: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionView == completionView ? parser.currentContainer.suggestedTypes.count : delegate.tags.count
  }
  func cellIdentifier(collectionView: UICollectionView) -> String {
    return collectionView == completionView ? "completionCell" : "tagCell"
  }
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier(collectionView), forIndexPath: indexPath)
    if let cell = cell as? TagCell {
      cell.backgroundColor = UIColor.redColor()
      cell.textField.addTarget(self, action:"tagTextChanged:", forControlEvents: .EditingChanged)
      cell.textField.delegate = self

      cell.textField.text = ""
      if indexPath.row < delegate.getTags().count {
        cell.textField.text = delegate.getTags()[indexPath.row]
      }
    } else if let cell = cell as? CompletionCell {
      cell.label.text = parser.currentContainer.suggestedTypes[indexPath.row]
      cell.backgroundColor = UIColor.redColor()
    }
    return cell
  }
  func tagTextChanged(textField: UITextField) {
    var resultFrame = CGRectZero
    if !textField.text!.isEmpty && textField.text != " " {
      let pos = textField.beginningOfDocument
      if let pos2 = textField.tokenizer.positionFromPosition(pos, toBoundary: .Line, inDirection: 0) {
        let range = textField.textRangeFromPosition(pos, toPosition: pos2)
        resultFrame = textField.firstRectForRange(range!)
      }
      let rectHold = textField.frame

      var width : CGFloat = 20.0
      if resultFrame.size.width+12.0 > StartingWidth {
        collectionView.collectionViewLayout.invalidateLayout()
        width = resultFrame.size.width+12.0
      }
      delegate.tags[delegate.currentIndex] = textField.text!
      textField.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, width, resultFrame.size.height)
      collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: delegate.currentIndex, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
    }
  }
}

extension TagDataSource: UITextFieldDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if textField.text == "Add Tag" {
      textField.text = ""
    }
    currentTextField = textField
    textField.inputAccessoryView = completionView
    return true
  }
  func textFieldDidBeginEditing(textField: UITextField) {
    if let cellIndex = textField.superview as? UICollectionViewCell, temp = collectionView.indexPathForCell(cellIndex)  {
      delegate.currentIndex = temp.row
    }
  }
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if string.characters.count > 0 {
      let completeString = textField.text! + string
      let lastCharacter = string.substringFromIndex(string.endIndex.advancedBy((-1)))

      updateSuggestions(parser.parse(completeString))
      if lastCharacter == " " {
        var idx = delegate.currentIndex+1
        if delegate.currentIndex == delegate.tags.endIndex {
          idx = delegate.tags.endIndex
        }
        delegate.tags.insert("", atIndex: idx)
        let indexPath = NSIndexPath(forRow: idx, inSection: 0)
        collectionView.insertItemsAtIndexPaths([indexPath])

        UIView.animateWithDuration(0.2, animations: { () -> Void in
          self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
          }, completion: { (complete) -> Void in
            if let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? TagCell {
              cell.textField.becomeFirstResponder()
            }
        })
        return false
      }
    }
    return true
  }
}
