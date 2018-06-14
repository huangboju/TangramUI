//
//  ImageCollectionViewGlobalHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 17/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

//
//  ImageCollectionViewHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

/// Custom UICollectionReusableView section header that serves as
/// a Global Header
extension UIImage {
    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

enum Asset: String {
    case LayoutConfigOptionsAsset = "LayoutConfigOptions"
    case LayoutConfigOptionsTouchedAsset = "LayoutConfigOptionsTouched"
    case GlobalHeaderBackground = "GlobalHeaderBackground"
    
    var image: UIImage {
        return UIImage(asset: self)!
    }
}

class ImageCollectionViewGlobalHeader: UICollectionReusableView {
    private lazy var configStackView: UIStackView = {
        let configStackView = UIStackView()
        configStackView.translatesAutoresizingMaskIntoConstraints = false
        configStackView.axis = .horizontal
        configStackView.distribution = .fill
        configStackView.alignment = .center
        configStackView.spacing = 10.0
        configStackView.layoutMargins = UIEdgeInsets(top: 0, left: configStackView.spacing, bottom: 0, right: configStackView.spacing)
        configStackView.isLayoutMarginsRelativeArrangement = true
        return configStackView
    }()
    
    private lazy var configButton: UIButton = {
        let configButton = UIButton(type: .custom)
        configButton.translatesAutoresizingMaskIntoConstraints = false
        configButton.setBackgroundImage(UIImage(asset: .LayoutConfigOptionsAsset), for: .normal)
        configButton.setBackgroundImage(UIImage(asset: .LayoutConfigOptionsTouchedAsset), for: .selected)
        configButton.showsTouchWhenHighlighted = true
        configButton.addTarget(nil, action: #selector(AKPFlowLayoutController.showLayoutConfigOptions), for: .touchUpInside)
        return configButton
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "About Cats and Dogs..."
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        return label
    }()

    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .darkGray
        self.clipsToBounds = true

        configureStackView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var bckgImageViewFullHeight: CGFloat = 0
    fileprivate var bckgImageViewHeightConstraint: NSLayoutConstraint?
}

extension ImageCollectionViewGlobalHeader {
    func configureStackView() {
        let backgImage = Asset.GlobalHeaderBackground.image
        bckgImageViewFullHeight = backgImage.size.width *  backgImage.scale
        
        backgroundImageView.image = backgImage
        addSubview(backgroundImageView)

        configStackView.addArrangedSubview(label)
        configStackView.addArrangedSubview(configButton)
        addSubview(configStackView)
    }
}

extension ImageCollectionViewGlobalHeader {
    // MARK: - 📐Constraints
    func setConstraints() {

        bckgImageViewHeightConstraint = {
            $0.priority = .required
            return $0
        }( backgroundImageView.heightAnchor.constraint(equalToConstant: bckgImageViewFullHeight) )
        
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bckgImageViewHeightConstraint!,
            backgroundImageView.widthAnchor.constraint(equalTo: backgroundImageView.heightAnchor),
            
            configStackView.topAnchor.constraint(equalTo: topAnchor),
            configStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            configStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            configStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension ImageCollectionViewGlobalHeader {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let layoutAttributes = layoutAttributes as? AKPFlowLayoutAttributes,
              let bckgImageViewHeightConstraint = bckgImageViewHeightConstraint else { return }
        bckgImageViewHeightConstraint.constant = bckgImageViewFullHeight - layoutAttributes.stretchFactor
    }
}


