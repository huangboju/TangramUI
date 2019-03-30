//
//  StretchyViewController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2019/3/30.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class StretchyViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let infoText = UILabel()
    private let imageView = UIImageView()
    private let textContainer = UIView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "header-background")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        infoText.textColor = .white
        infoText.numberOfLines = 0
        let text =  """
                    Lorem ipsum dolor sit amet, in alia adhuc aperiri nam. Movet scripta tractatos cu eum, sale commodo meliore ea eam, per commodo atomorum ea. Unum graeci iriure nec an, ea sit habeo movet electram. Id eius assum persius pro, id cum falli accusam. Has eu fierent partiendo, doming expetenda interesset cu mel, tempor possit vocent in nam. Iusto tollit ad duo, est at vidit vivendo liberavisse, vide munere nonumy sed ex.
                            
                    Quod possit expetendis id qui, consequat vituperata ad eam. Per cu elit latine vivendum. Ei sit nullam aliquam, an ferri epicuri quo. Ex vim tibique accumsan erroribus. In per libris verear adipiscing. Purto aliquid lobortis ea quo, ea utinam oportere qui.
                    """
        infoText.text = text + text + text
        infoText.translatesAutoresizingMaskIntoConstraints = false
        
        let imageContainer = UIView()
        imageContainer.backgroundColor = .darkGray
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        textContainer.backgroundColor = .clear
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let textBacking = UIView()
        textBacking.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1235740449, blue: 0.2699040081, alpha: 1)
        textBacking.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageContainer)
        scrollView.addSubview(textBacking)
        scrollView.addSubview(textContainer)
        scrollView.addSubview(imageView)
        
        textContainer.addSubview(infoText)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.7)
            ])
        
        let imageViewTop = imageView.topAnchor.constraint(equalTo: view.topAnchor)
        imageViewTop.priority = .defaultHigh
        
        let imageViewHeight = imageView.heightAnchor.constraint(greaterThanOrEqualTo: imageContainer.heightAnchor)
        imageViewHeight.priority = .required
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageViewTop,
            imageViewHeight,
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            textContainer.topAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            textContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            textBacking.topAnchor.constraint(equalTo: textContainer.topAnchor),
            textBacking.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textBacking.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textBacking.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            infoText.topAnchor.constraint(equalTo: textContainer.topAnchor, constant: 14),
            infoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            infoText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoText.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor)
            ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.scrollIndicatorInsets = view.tSafeAreaInsets
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.tSafeAreaInsets.bottom, right: 0)
    }
    
    //MARK: - Scroll View Delegate
    
    private var previousStatusBarHidden = false
    
    //MARK: - Status Bar Appearance
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    private var shouldHideStatusBar: Bool {
        let frame = textContainer.convert(textContainer.bounds, to: nil)
        return frame.minY < view.tSafeAreaInsets.top
    }
}

extension StretchyViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if previousStatusBarHidden != shouldHideStatusBar {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
}

extension UIView {
    var tSafeAreaInsets: UIEdgeInsets {
        guard #available(iOS 11.0, *) else {
            return .zero
        }
        return safeAreaInsets
    }
}
