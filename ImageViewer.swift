import SwiftUI

struct ImageView: View {
    let top: CGFloat = 44 + 44
    let bottom: CGFloat = 34
    let padding: CGFloat = 16
    let closeWidth: CGFloat = 19
    
    var image: UIImage
    var imageName: String
    var showImage: Binding<Bool>
    
    @State var screenWidth:CGFloat
    @State var screenHeight:CGFloat
    @State var imageWidth: CGFloat
    @State var imageHeight: CGFloat
    @State var imageScale: CGFloat
    @State var lastImageScale: CGFloat
    @State var imageOffset: CGSize
    @State var lastImageOffset: CGSize
    
    init(_ image: UIImage, imageName: String, showImage: Binding<Bool>) {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let screenWidth = UIScreen.main.bounds.width - self.padding
        let screenHeight = UIScreen.main.bounds.height - self.top - self.padding
                
        self.imageName = imageName
        self.image = image
        self.showImage = showImage
        
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        
        if imageWidth / screenWidth >= imageHeight / screenHeight {
            self.imageWidth = screenWidth
            self.imageHeight = imageHeight * screenWidth / imageWidth
        } else {
            self.imageHeight = screenHeight
            self.imageWidth = imageWidth * screenHeight / imageHeight
        }
        
        self.imageScale = 1.0
        self.lastImageScale = 1.0
        self.imageOffset = CGSize(width: 0, height: self.bottom / 2)
        self.lastImageOffset = CGSize(width: 0, height: self.bottom / 2)
    }
    
    var body: some View {
        VStack {
            NavigationView {
                Image(uiImage: self.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.imageWidth, height: self.imageHeight, alignment: .center)
                    .scaleEffect(self.imageScale)
                    .offset(self.imageOffset)
                    .gesture(MagnificationGesture().onChanged{ value in
                        let delta = value / self.lastImageScale
                        self.lastImageScale = value
                        let scale = self.imageScale * delta
                        self.imageScale = scale < 1.0 ? 1.0 : scale
                        
                        processOffset(width: self.imageOffset.width, height: self.imageOffset.height)
                    }.onEnded{ value in
                        self.lastImageScale = 1.0
                    }
                    .simultaneously(with: DragGesture().onChanged{ value in
                        let widthOffset = value.translation.width - self.lastImageOffset.width
                        let heightOffset = value.translation.height - self.lastImageOffset.height
                        self.lastImageOffset = value.translation
                        let width = self.imageOffset.width + widthOffset
                        let height = self.imageOffset.height + heightOffset
                        
                        processOffset(width: width, height: height)
                    }.onEnded{ value in
                        self.lastImageOffset = CGSize(width: 0, height: self.bottom / 2)
                    }))
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarItems(
                        leading: Text(self.imageName),
                        trailing: Button(action: {
                            self.showImage.wrappedValue.toggle()
                        }, label: {
                            Image("CloseButton")
                        })
                    )
            }
        }
    }
    
    func processOffset(width: CGFloat, height: CGFloat) {
        // width
        let scaledImageWidth = self.imageWidth * self.imageScale;
        
        if scaledImageWidth <= self.screenWidth {
            self.imageOffset.width = 0
        } else {
            let maxWidth = (scaledImageWidth - self.screenWidth) / 2
            self.imageOffset.width = width > maxWidth ? maxWidth : width < -maxWidth ? -maxWidth : width
        }
        
        // height
        let scaledImageHeight = self.imageHeight * self.imageScale;
        
        if scaledImageHeight <= self.screenHeight {
            self.imageOffset.height = self.bottom / 2
        } else {
            let maxHeight = (scaledImageHeight - (self.screenHeight - self.bottom)) / 2
            let minHeight = -(scaledImageHeight - (self.screenHeight + self.bottom)) / 2
            self.imageOffset.height = height > maxHeight ? maxHeight : height < minHeight ? minHeight : height
        }
    }
}
