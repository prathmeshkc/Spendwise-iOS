//
//  LottieView.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 12/5/23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let animation: LottieAnimations
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode
    let animationView: LottieAnimationView
    
    init(animation: LottieAnimations, loopMode: LottieLoopMode = .playOnce, animationSpeed: CGFloat = 1, contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.animation = animation
        self.animationView = LottieAnimationView(name: animation.rawValue)
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.play()
        
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
 
        return animationView
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    
}

#Preview {
    LottieView(animation: .verifyEmail, loopMode: .loop)
}
