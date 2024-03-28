import UIKit

class VASingleStar: UIView {

    var isAnimating = false
    
    private let starSize: CGFloat
    private var defaultColor: UIColor = .white
    private var fillStarYAnchorConstraint: NSLayoutConstraint!
    
    private let borderStarImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "star-border")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let fillStarImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "star-fill")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    init(starSize: CGFloat, animated flag: Bool = false) {
        self.starSize = starSize
        super.init(frame: .zero)
        
        fillStarImageView.alpha = flag ? 0 : 1
        
        addSubview(borderStarImageView)
        addSubview(fillStarImageView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(animated flag: Bool = false, delay: TimeInterval = 0.0, comletion: (() -> Void)? = nil) {        
        if !flag {
            fillStarImageView.alpha = 1
            comletion?()
            return
        }
        
        fillStarImageView.transform = CGAffineTransform(translationX: 0, y: -starSize/1.5)
        
        UIView.animate(withDuration: 0.66, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
            self.isAnimating = true
            self.fillStarImageView.alpha = 1
            self.fillStarImageView.transform = .identity
        } completion: { _ in
            self.isAnimating = false
            comletion?()
        }
    }
    
    func hideFill() {
        fillStarImageView.alpha = 0
        fillStarImageView.tintColor = defaultColor
    }
    
    func animate(toColor: UIColor, withDuration duration: TimeInterval = 0.3, delay: TimeInterval, completion: (() -> Void)? = nil) {
        defaultColor = fillStarImageView.tintColor
        
        UIView.animate(withDuration: duration, delay: delay, animations: {
            self.fillStarImageView.tintColor = toColor
        }) { _ in
            completion?()
        }
    }
    
    func setDefault(borderColor: UIColor, starColor: UIColor) {
        borderStarImageView.tintColor = borderColor
        fillStarImageView.tintColor = starColor
    }
    
    private func setupConstraints() {
        borderStarImageView.translatesAutoresizingMaskIntoConstraints = false
        fillStarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            borderStarImageView.leftAnchor.constraint(equalTo: leftAnchor),
            borderStarImageView.rightAnchor.constraint(equalTo: rightAnchor),
            borderStarImageView.topAnchor.constraint(equalTo: topAnchor),
            borderStarImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderStarImageView.widthAnchor.constraint(equalToConstant: starSize),
            borderStarImageView.heightAnchor.constraint(equalToConstant: starSize),
            
            fillStarImageView.centerYAnchor.constraint(equalTo: borderStarImageView.centerYAnchor),
            fillStarImageView.centerXAnchor.constraint(equalTo: borderStarImageView.centerXAnchor),
            fillStarImageView.widthAnchor.constraint(equalTo: borderStarImageView.widthAnchor, multiplier: 0.8),
            fillStarImageView.heightAnchor.constraint(equalTo: borderStarImageView.heightAnchor, multiplier: 0.8),
        ])
    }

}
