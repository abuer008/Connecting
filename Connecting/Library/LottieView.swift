//
//  LottieView.swift
//  Connecting
//
//  Created by bowei xiao on 05.08.20.
//

import SwiftUI
#if os(iOS)
//import Lottie
#endif

//struct LottieView: UIViewRepresentable {
//    var fileName: String
//    var fromFrame: AnimationFrameTime? = nil
//    var toFrame: AnimationFrameTime? = nil
//
//    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
//        let view = UIView(frame: .zero)
//        let animationView = AnimationView()
//        animationView.animation = Animation.named(fileName)
//        animationView.contentMode = .scaleAspectFit
//
//        if let startFrame = fromFrame, let endFrame = toFrame {
//            animationView.play(fromFrame: startFrame, toFrame: endFrame, loopMode: .loop)
//        } else {
//            animationView.loopMode = .loop
//            animationView.play()
//        }
//
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(animationView)
//
//        NSLayoutConstraint.activate([
//                                        animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
//                                     animationView.heightAnchor.constraint(equalTo: view.heightAnchor)])
//
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
//
//    }
//
//    typealias UIViewType = UIView
//
//
//}
