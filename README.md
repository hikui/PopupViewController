A view controller to pop up any views like `UIAlertController`.

**Usage:**

```
let contentView = UINib.init(nibName: "TestContentView", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! TestContentView
contentView.label.text = "long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text "
let popupController = PopupViewController(contentView: contentView)
popupController.beginPosition = .belowBottom
popupController.endPosition = .bottom
popupController.marginBottom = 40
self.present(popupController, animated: true, completion: nil)
```