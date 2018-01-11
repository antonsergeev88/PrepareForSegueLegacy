# PrepareForSegue
The framework contain implementation of `prepare(for:sender:)` and `shouldPerformSegue(withIdentifier:sender:)` that automaticly invoke custom methods based on segue's identifier.

Objective-C:
```
- (void)prepareFor<Identifier>:(UIStoryboardSegue *)segue sender:(id)sender
- (void)shouldPerform<Identifier>WithSender:(id)sender
```
Swift:
```
@objc func prepareFor<Identifier>(_ segue: UIStoryboardSegue, sender: Any?)
@objc func shouldPerform<Identifier>(sender: Any?) -> Bool
```

# Using
All you need is to add the library or files `UIViewController+PrepareForSegue.*` to your project. Then for all segue you want to add custom prepare logic add prepare method with names like above.

If in some subclass UIViewController you need another logic, just override `prepareForSegue:sender:` and `shouldPerformSegueWithIdentifier:sender:` for Objective-C or `prepare(for:sender:)` and `shouldPerformSegue(withIdentifier:sender:)` for Swift.
