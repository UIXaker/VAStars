import UIKit

class VAStars: UIView {
    
    private var configuration: VAStarsConfiguration
    
    private lazy var firstStarView: VASingleStar = {
        let view = VASingleStar(
            starSize: configuration.starSize,
            animated: configuration.animationType != .none
        )
        view.alpha = configuration.animationType != .none ? 0 : 1
        view.setDefault(borderColor: configuration.borderColor, starColor: configuration.defaultColor)
        
        return view
    }()
    
    private lazy var secondStarView: VASingleStar = {
        let view = VASingleStar(
            starSize: configuration.starSize,
            animated: configuration.animationType != .none
        )
        view.alpha = configuration.animationType != .none ? 0 : 1
        view.setDefault(borderColor: configuration.borderColor, starColor: configuration.defaultColor)
        
        return view
    }()
    
    private lazy var thirdStarView: VASingleStar = {
        let view = VASingleStar(
            starSize: configuration.starSize,
            animated: configuration.animationType != .none
        )
        view.alpha = configuration.animationType != .none ? 0 : 1
        view.setDefault(borderColor: configuration.borderColor, starColor: configuration.defaultColor)
        
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
            noAnimation(completion: completion)
            return
        }
        
        switch configuration.animationType {
        case .fade(let duration, let deley):
            fadeAnimation(with: duration, deley: deley, completion: completion)
        case .scale(let duration, let factor):
            scaleAnimation(with: duration, scale: factor, completion: completion)
        case .none:
            noAnimation(completion: completion)
        }
    }
    
    /// Метод для анимации падающий звезд
    /// - Parameters:
    ///   - type: Сколько звезд упадет и с каким цветом будет каждая из звезд
    ///   - flag: Нужна ли анимация для падения звезд
    ///   - firstDeley: Задержка перед падением первой звезды
    ///   - deley: Задержка перед падением следующей звезды
    ///   - completion: Метод вызывается после анимации падения и анимации заливки всех цветов
    func fillStars(fill type: VAStarsConfiguration.FillType, animated flag: Bool, firstDeley: TimeInterval, deley: TimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + firstDeley) {
            switch type {
            case .one(let first):
                self.firstStarView.show(animated: flag) { [weak self] in
                    self?.firstStarView.animate(color: first, completion: completion)
                }
                
            case .two(let first, let second):
                self.firstStarView.show(animated: flag)
                self.secondStarView.show(animated: flag, deley: deley) { [weak self] in
                    guard let self = self else { return }
                    
                    self.firstStarView.animate(color: first)
                    self.secondStarView.animate(color: second, completion: completion)
                }
                
            case .three(let first, let second, let third):
                self.firstStarView.show(animated: flag)
                self.secondStarView.show(animated: flag, deley: deley)
                self.thirdStarView.show(animated: flag, deley: deley * 2) { [weak self] in
                    guard let self = self else { return }
                    
                    self.firstStarView.animate(color: first)
                    self.secondStarView.animate(color: second)
                    self.thirdStarView.animate(color: third, completion: completion)
                }
            }
        }
    }
    
    private func noAnimation(completion: (() -> Void)?) {
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
                
        NSLayoutConstraint.activate([
            firstStarView.leftAnchor.constraint(equalTo: leftAnchor),
            firstStarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            firstStarView.rightAnchor.constraint(equalTo: secondStarView.leftAnchor, constant: -configuration.hSpacing),
            
            secondStarView.topAnchor.constraint(equalTo: topAnchor),
            secondStarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: configuration.vSpacing),
            
            thirdStarView.leftAnchor.constraint(equalTo: secondStarView.rightAnchor, constant: configuration.hSpacing),
            thirdStarView.rightAnchor.constraint(equalTo: rightAnchor),
            thirdStarView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
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
