# PrepareForSegue
The framework contain implementation of prepare(for:sender:) that automaticly invoke custom prepare for segue method based on segue's identifier.

Objective-C:
```
- (void)prepareFor<Identifier>:(UIStoryboardSegue *)segue sender:(id)sender
```
Swift:
```
func prepareFor<Identifier>(_ segue: UIStoryboardSegue, sender: Any?)
```
