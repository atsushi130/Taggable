# Taggable

Taggable is tagging library. inspired Evernote.

<p align="center">
  <img src="https://github.com/atsushi130/Taggable/blob/master/Taggable/images/taggable.gif" alt="Taggable" width="320"/>
</p>

## Usage

At first, clone Taggable

```zsh
git clone https://github.com/atsushi130/Taggable.git
```
and import Taggable/Taggable into your project.  

second, implement `TaggableViewDelegate` and `TaggableViewDataSource`

```swift
class ViewController: UIViewController {
	var taggableView: TaggableView!
	var taggables = [String]()
}
```

```swift
extension ViewController: TaggableViewDelegate {
	func taggableMarginInTAggableView(tagableView: TaggableView) -> CGFloat {
        return 5
    }

	func taggableView(taggableView: TaggableView, didReturnWithText text: String) {
        self.taggables.append(text)
        self.taggableView.reloadData()
    }
    
    func taggableView(taggableView: TaggableView, didRemoveTaggableAtIndex index: Int) {
        self.taggables.removeAtIndex(index)
        self.taggableView.reloadData()
    }
   
    func taggableViewShouldEndEditing(taggableView: TaggableView) -> Bool {
        return false
    }
}
```

```swift
private let NibNamed = "Taggable"
extension ViewController: TaggableViewDataSource {
    
    func numberOfTaggableInTaggableView(taggableView: TaggableView) -> Int {
        return self.taggables.count
    }
    
    func taggableView(taggableView: TaggableView, taggableForRowAtIndex indexPath: NSIndexPath) -> Taggable {
        let taggable = NSBundle.mainBundle().loadNibNamed(NibNamed, owner: self, options: nil)[0] as! Taggable
        
        taggable.label.text    = self.taggables[indexPath.row]
        taggable.removeHandler = {
            if let index = self.taggableView.indexIfTaggableView(taggable) {
                self.taggables.removeAtIndex(index)
                self.taggableView.reloadData()
            }
        }
        
        return taggable
    }
}
```
removeHandler is called, when pressed removeButton of Taggable.

Last, Taggable.xib is Taggable design. Let's customize!!

## Contact

Atsushi Miyake
 - https://twitter.com/tsushi130


## License (MIT)

Copyright (c) 2016 - Atsushi Miyake

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
