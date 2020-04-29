# Face Tracking (ARKit) 

The Face tracking app demonstrates how ARKit allows us to work with front TrueDepth camera to identify faces and apply various effects using 3D graphics and texturing

### MVVM Architecture

##### Source structure
* `Model` - contains core types and use cases (business rules)
* `View` - passive view layer. It displays a representation of the `Model` and receives the user's interactions, and it forwards the handling of these to the `View model` via the data binding
* `ViewModel` - it's UIKit independent representation of the `View` and its state. The View Model invokes changes in the Model and updates itself. Data bindings allow to update the `View` when the `Model` changes
* `Flows` - contains a coordinators to navigate through the app scenes

#### Details
* Data binding: Combine
* Programmatically building a UIKit user interface 
* Protocol-oriented programming style
* There are currently 4 face effects and 2 green screen examples available
* There 2 types of renderers are used: SceneKit and Metal
* Developed and tested on iPad

#### Requirements
* TrueDepth camera
* A12 Bionic chip or newer
* iOS 13.0+

## Authors
* **Alexey Gross** - [alexey.gross][AG]

[AG]: https://github.com/grosshub
