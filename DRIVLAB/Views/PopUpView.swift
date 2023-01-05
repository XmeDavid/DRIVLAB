//
//  PopUpView.swift
//  DRIVLAB
//
//  Created by David Batista on 04/01/2023.
//

import SwiftUI



struct PopUpView: View {
    
    private func defaultAction(){}
    
    var title: String
    
    var subtitle: String
    var showSubtitle: Bool = true
    
    var bodyText: String = ""
    var showBody: Bool = false
    
    var image: String = "photo"
    var showImage: Bool = false
    
    var actionText: String
    var action: ()->()
    
    var emojiFirework: String = "🎉"
    
    
    var body: some View {
        ZStack{
            VStack{
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                if showSubtitle{
                    Text(subtitle)
                        .font(.title)
                        .padding()
                }
                
                if showImage{
                    Image(image)
                        .frame(maxWidth: UIScreen.screenWidth * 0.8)
                        .padding()
                }
                
                if showBody {
                    Text(bodyText)
                        .padding()
                }
                
                
                Spacer()
                Button(action: dismiss){
                        Text(actionText)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal,64)
                    
                }
                    .frame(width: UIScreen.screenWidth * 0.9)
                    .buttonStyle(.borderedProminent)
                    .padding(32)
                
            }
            Text(emojiFirework)
                            .frame(width: 64, height: 64)
                            .modifier(ParticlesModifier())
                            .offset(x: UIScreen.screenWidth / 2, y : UIScreen.screenHeight / 2)
            Text(emojiFirework)
                            .frame(width: 64, height: 64)
                            .modifier(ParticlesModifier())
                            .offset(x: -UIScreen.screenWidth / 2, y : UIScreen.screenHeight / 2)
            Text(emojiFirework)
                            .frame(width: 64, height: 64)
                            .modifier(ParticlesModifier())
                            .offset(x: 0, y : 0)
            Text(emojiFirework)
                            .frame(width: 64, height: 64)
                            .modifier(ParticlesModifier())
                            .offset(x: UIScreen.screenWidth / 2, y : -UIScreen.screenHeight / 2)
            Text(emojiFirework)
                            .frame(width: 64, height: 64)
                            .modifier(ParticlesModifier())
                            .offset(x: -UIScreen.screenWidth / 2, y : -UIScreen.screenHeight / 2)
        }
    }
    
    private func dismiss(){
        action()
        
        
        Global.instance.popUpViewModel.queueNextScreen()

    }
}

struct PopUpView_Previews: PreviewProvider {
    
    static func function(){
        print("Hello world!")
    }
    
    static var previews: some View {
        PopUpView(
            title: "You have earned 10 XP!",
            subtitle: "Thanks to your drive, you earned 10XP",
            bodyText: "Good job Keep it Up!",
            showBody: true,
            image: "image",
            showImage: true,
            actionText: "Continue!",
            action: function
        )
    }
}


struct FireworkParticlesGeometryEffect : GeometryEffect {
    var time : Double
    var speed = Double.random(in: 20 ... 200)
    var direction = Double.random(in: -Double.pi ...  Double.pi)

    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}

struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = Double.random(in: 1 ... 3)
    let duration = 3.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<80, id: \.self) { index in
                content
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}


extension UIScreen{
    static let screenWidth: Double = UIScreen.main.bounds.size.width
    static let screenHeight: Double = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
