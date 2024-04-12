//
//  AnimatedGIFView.swift
//  Pokedex
//
//  Created by Luke Taylor on 17/03/2024.
//

import SwiftUI
import SwiftyGif

struct AnimatedGifView: UIViewRepresentable {
    private let name: String?
    private let loopCount: Int?
    
    @Binding var playGif: Bool
    
    init(name: String, loopCount: Int = -1, playGif: Binding<Bool> = .constant(true)) {
        self.name = name
        self.loopCount = loopCount
        self._playGif = playGif
    }
    
    func makeUIView(context: Context) -> UIGIFImageView {
        return UIGIFImageView(name: name!, loopCount: loopCount!, playGif: playGif)
    }
    
    func updateUIView(_ gifImageView: UIGIFImageView, context: Context) {
        if playGif {
            gifImageView.imageView.startAnimatingGif()
        } else {
            gifImageView.imageView.stopAnimatingGif()
        }
    }
}

class UIGIFImageView: UIView {
    private var image = UIImage()
    var imageView = UIImageView()
    private var name: String?
    private var loopCount: Int?
    open var playGif: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String, loopCount: Int, playGif: Bool) {
        self.init()
        self.name = name
        self.loopCount = loopCount
        self.playGif = playGif
        createGIF()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        self.addSubview(imageView)
    }
    
    func createGIF() {
        do {
            image = try UIImage(gifName: self.name!)
        } catch {
            print(error)
        }
        
        imageView = UIImageView(gifImage: image, loopCount: loopCount!)
        imageView.contentMode = .scaleAspectFit
    }
}
