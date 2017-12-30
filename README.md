# PrepareForSegue
The framework contain implementation of prepare(for:sender:) that automaticly invoke custom prepare for segue method based on segue's identifier.

Objective-C:
```
- (void)prepareFor<Identifier>:(UIStoryboardSegue *)segue sender:(id)sender
```
Swift:
```
@objc func prepareFor<Identifier>(_ segue: UIStoryboardSegue, sender: Any?)
```

# Using
All you need is to add this library or files `UIViewController+PrepareForSegue.*` to your project. Then for all segue you want to add custom prepare logic add prepare method with names like above.

If in some subclass UIViewController you need another logic - just override `prepareForSegue:sender:` (Objective-C) or `prepare(for:sender:)` (Swift).
