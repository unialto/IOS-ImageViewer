# IOS-ImageViewer
### #SwiftUI #Image #Scale #Offset #MagnificationGesture #DragGesture

## Play
![ImageViewer-7](https://user-images.githubusercontent.com/6913816/123514227-c911ee00-d6cc-11eb-9885-3d1e832ec53e.gif)

## Using
```
import SwiftUI

struct ContentView: View {
    @State var image: UIImage?
    @State var imageName: String?
    @State var showImage: Bool = false
    
    var body: some View {
        ZStack {
            Button {
                // test assets image
                self.image = UIImage(named: "AppleImage")
                self.imageName = "apple.png"
                self.showImage.toggle()
            } label: {
                Text("View Image")
            }
            
            if self.showImage {
                ImageView(self.image!, imageName: self.imageName ?? "", showImage: self.$showImage)
                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```
