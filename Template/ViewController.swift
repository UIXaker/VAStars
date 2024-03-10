import UIKit

class ViewController: UIViewController {

    private var mainView: MainView { view as! MainView }
    override func loadView() { view = MainView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        mainView.addGestureRecognizer(gesture)
    }

    @objc private func viewDidTapped() {
        mainView.starsView.show(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.mainView.starsView.showStars(animated: true, deley: 0.15) { }
            }
        }
    }
}

class MainView: UIView {
    
    let starsView: VAStars = {
//        let configuration = VAStarsConfiguration(animationType: .fade(duration: 0.3, deley: 0.1))
        let configuration = VAStarsConfiguration(animationType: .scale(duration: 0.3, factor: 0.6))
        let view = VAStars(configuration: configuration)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(hex: 0x252525)
        
        addSubview(starsView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        starsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            starsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}

struct VAStarsConfiguration {
    var starSize: CGFloat = 40.0
    var hSpacing: CGFloat = 0
    var vSpacing: CGFloat = -12
    
    /// need for initial state for stars
    var animationType: AnimationType = .none
    
    enum AnimationType: Equatable {
        case fade(duration: TimeInterval, deley: TimeInterval)
        case scale(duration: TimeInterval, factor: CGFloat)
        case none
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.fade, .fade), (.scale, .scale), (.none, .none): return true
            default: return false
            }
        }
    }
}

class VAStars: UIView {
    
    private var configuration: VAStarsConfiguration
    private var firstStarRightConstraint: NSLayoutConstraint!
    private var thirdStarLeftConstraintird: NSLayoutConstraint!
    
    private lazy var firstStarView: VAStarView = {
        let view = VAStarView(
            starSize: configuration.starSize,
            animated: configuration.animationType != .none
        )
        view.alpha = configuration.animationType != .none ? 0 : 1
        
        return view
    }()
    
    private lazy var secondStarView: VAStarView = {
        let view = VAStarView(
            starSize: configuration.starSize,
            animated: configuration.animationType != .none
        )
        view.alpha = configuration.animationType != .none ? 0 : 1
        
        return view
    }()
    
    private lazy var thirdStarView: VAStarView = {
        let view = VAStarView(
            starSize: configuration.starSize,
            animated: configuration.animationType != .none
        )
        view.alpha = configuration.animationType != .none ? 0 : 1
        
        return view
    }()
    
    init(configuration: VAStarsConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        addSubview(firstStarView)
        addSubview(secondStarView)
        addSubview(thirdStarView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(animated flag: Bool, completion: (() -> Void)? = nil) {
        if !flag {
            noneAnimation(completion: completion)
            return
        }
        
        switch configuration.animationType {
        case .fade(let duration, let deley): 
            fadeAnimation(with: duration, deley: deley, completion: completion)
        case .scale(let duration, let factor): 
            scaleAnimation(with: duration, scale: factor, completion: completion)
        case .none: 
            noneAnimation(completion: completion)
        }
    }
    
    func showStars(animated flag: Bool, deley: TimeInterval, completion: @escaping () -> Void) {
        firstStarView.show(animated: flag)
        secondStarView.show(animated: flag, deley: deley)
        thirdStarView.show(animated: flag, deley: deley * 2) {
            completion()
        }
    }
    
    private func noneAnimation(completion: (() -> Void)?) {
        firstStarView.alpha = 1
        secondStarView.alpha = 1
        thirdStarView.alpha = 1
        
        completion?()
    }
    
    private func fadeAnimation(with duration: TimeInterval, deley: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.firstStarView.alpha = 1
        }
        
        UIView.animate(withDuration: duration, delay: deley) {
            self.secondStarView.alpha = 1
        }
        
        UIView.animate(withDuration: duration, delay: deley * 2, animations: {
            self.thirdStarView.alpha = 1
        }) { _ in
            completion?()
        }
    }
    
    private func scaleAnimation(with duration: TimeInterval, scale factor: CGFloat, completion: (() -> Void)? = nil) {
        let transform = CGAffineTransform(scaleX: factor, y: factor)
        let firstTransform = transform.translatedBy(x: configuration.hSpacing + configuration.starSize, y: 0)
        let thirdTransform = transform.translatedBy(x: configuration.hSpacing - configuration.starSize, y: 0)
                
        firstStarView.transform = firstTransform
        secondStarView.transform = transform
        thirdStarView.transform = thirdTransform
                        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.firstStarView.alpha = 1
            self.secondStarView.alpha = 1
            self.thirdStarView.alpha = 1

            self.firstStarView.transform = .identity
            self.secondStarView.transform = .identity
            self.thirdStarView.transform = .identity
        }) { _ in
            completion?()
        }
    }
    
    private func setupConstraints() {
        firstStarView.translatesAutoresizingMaskIntoConstraints = false
        secondStarView.translatesAutoresizingMaskIntoConstraints = false
        thirdStarView.translatesAutoresizingMaskIntoConstraints = false
        
        firstStarRightConstraint = firstStarView.rightAnchor.constraint(equalTo: secondStarView.leftAnchor, constant: -configuration.hSpacing)
        thirdStarLeftConstraintird = thirdStarView.leftAnchor.constraint(equalTo: secondStarView.rightAnchor, constant: configuration.hSpacing)
                
        NSLayoutConstraint.activate([
            firstStarView.leftAnchor.constraint(equalTo: leftAnchor),
            firstStarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            firstStarRightConstraint,
            
            secondStarView.topAnchor.constraint(equalTo: topAnchor),
            secondStarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: configuration.vSpacing),
            
            thirdStarLeftConstraintird,
            thirdStarView.rightAnchor.constraint(equalTo: rightAnchor),
            thirdStarView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

class VAStarView: UIView {

    var isAnimating = false
    
    private let starSize: CGFloat
    private let animatedFlag: Bool
    
    private var fillStarYAnchorConstraint: NSLayoutConstraint!
    
    private let borderStarImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "star-border")
        view.tintColor = .init(hex: 0x929292)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let fillStarImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "star-fill")
        view.tintColor = .init(hex: 0x929292)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    init(starSize: CGFloat = 40.0, animated flag: Bool = false) {
        self.starSize = starSize
        animatedFlag = flag
        
        super.init(frame: .zero)
        
        fillStarImageView.alpha = animatedFlag ? 0 : 1
        
        addSubview(borderStarImageView)
        addSubview(fillStarImageView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(animated flag: Bool = false, deley: TimeInterval = 0.0, comletion: (() -> Void)? = nil) {
        fillStarYAnchorConstraint.constant = 0
        
        if !flag {
            setNeedsLayout()
            fillStarImageView.alpha = 1
            comletion?()
            return
        }
        
        UIView.animate(withDuration: 0.66, delay: deley, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
            self.isAnimating = true
            self.fillStarImageView.alpha = 1
            self.layoutIfNeeded()
        } completion: { _ in
            self.isAnimating = false
            comletion?()
        }
    }
    
    private func setupConstraints() {
        borderStarImageView.translatesAutoresizingMaskIntoConstraints = false
        fillStarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        fillStarYAnchorConstraint = fillStarImageView.centerYAnchor.constraint(equalTo: borderStarImageView.centerYAnchor, constant: animatedFlag ? -starSize/1.5 : 0)
        
        NSLayoutConstraint.activate([
            borderStarImageView.leftAnchor.constraint(equalTo: leftAnchor),
            borderStarImageView.rightAnchor.constraint(equalTo: rightAnchor),
            borderStarImageView.topAnchor.constraint(equalTo: topAnchor),
            borderStarImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderStarImageView.widthAnchor.constraint(equalToConstant: starSize),
            borderStarImageView.heightAnchor.constraint(equalToConstant: starSize),
            
            fillStarYAnchorConstraint,
            fillStarImageView.centerXAnchor.constraint(equalTo: borderStarImageView.centerXAnchor),
            fillStarImageView.widthAnchor.constraint(equalTo: borderStarImageView.widthAnchor, multiplier: 0.8),
            fillStarImageView.heightAnchor.constraint(equalTo: borderStarImageView.heightAnchor, multiplier: 0.8),
        ])
    }

}

#Preview(traits: .portrait) {
    return ViewController()
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}
