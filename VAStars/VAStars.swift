import UIKit

class VAStars: UIView {
    
    private var configuration: VAStarsConfiguration
    
    private var stars: [VASingleStar] = []
    private var firstStarView: VASingleStar { stars[0] }
    private var secondStarView: VASingleStar { stars[1] }
    private var thirdStarView: VASingleStar { stars[2] }
    
    init(configuration: VAStarsConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupStars()
        
        addSubview(firstStarView)
        addSubview(secondStarView)
        addSubview(thirdStarView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVisibility(animated flag: Bool, with type: AnimationType, isHidden: Bool, completion: ((VAStars) -> Void)? = nil) {
        if !flag {
            noAnimation(isHidden: isHidden, completion: completion)
            return
        }
        
        switch type {
        case .fade(let duration, let delay):
            fadeAnimation(with: duration, delay: delay, isHidden: isHidden, completion: completion)
        case .scale(let duration, let factor):
            scaleAnimation(with: duration, scale: factor, isHidden: isHidden, completion: completion)
        case .none:
            noAnimation(isHidden: isHidden, completion: completion)
        }
    }
    
    /// Метод для анимации падающий звезд
    /// - Parameters:
    ///   - type: Определяет количество падающих звезд и их цвета.
    ///   - animated: Флаг, указывающий на необходимость анимации падения звезд
    ///   - firstDelay: Задержка перед падением первой звезды
    ///   - delay: Задержка перед падением следующей звезды
    ///   - completion: Замыкание, вызываемое после завершения анимации
    func animateFallingStars(fill type: VAStarsConfiguration.FillType, animated flag: Bool, firstDelay: TimeInterval, delay: TimeInterval, completion: @escaping () -> Void) {
        func animateStarsFill(_ count: Int, colors: [UIColor]) {
            guard !stars.isEmpty else { return }
            
            let lastStarIndex = count - 1
            
            for index in 0...lastStarIndex {
                guard index < stars.count else { return }
                
                stars[index].show(animated: flag, delay: delay * Double(index)) { [weak self] in
                    guard let self = self, !colors.isEmpty else { return }
                    
                    if index == lastStarIndex {
                        for index in 0...lastStarIndex {
                            let color = colors.count > index ? colors[index] : colors.last!
                            self.stars[index].animate(toColor: color, delay: delay * Double(index)) {
                                if index == lastStarIndex {
                                    completion()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + firstDelay) {
            switch type {
            case .zero: break
            case .one(let color): animateStarsFill(1, colors: [color])
            case .two(let colors): animateStarsFill(2, colors: colors)
            case .three(let colors): animateStarsFill(3, colors: colors)
            }
        }
    }
    
    private func noAnimation(isHidden: Bool, completion: ((VAStars) -> Void)?) {
        let alpha: CGFloat = isHidden ? 0 : 1
        
        for star in stars {
            star.alpha = alpha
            if isHidden {
                star.hideFill()
            }
        }
        
        completion?(self)
    }
    
    private func fadeAnimation(with duration: TimeInterval, delay: TimeInterval, isHidden: Bool, completion: ((VAStars) -> Void)? = nil) {
        let stars = isHidden ? stars.reversed() : stars
        let curve: UIView.AnimationOptions = isHidden ? .curveEaseOut : .curveEaseIn
        let alpha: CGFloat = isHidden ? 0 : 1
        
        stars.enumerated().forEach { index, star in
            UIView.animate(withDuration: duration, delay: delay * TimeInterval(index), options: curve, animations: {
                star.alpha = alpha
            }) { _ in
                if isHidden {
                    star.hideFill()
                }
                
                if index == stars.count - 1 {
                    completion?(self)
                }
            }
        }
    }

    
    private func scaleAnimation(with duration: TimeInterval, scale factor: CGFloat, isHidden: Bool, completion: ((VAStars) -> Void)? = nil) {
        let transform = CGAffineTransform(scaleX: factor, y: factor)
        
        let size = configuration.starSize
        let scaleSize = size * factor
        let tx = (size - scaleSize + scaleSize/3) / factor
        let curve: UIView.AnimationOptions = isHidden ? .curveEaseIn : .curveEaseOut
        
        firstStarView.transform = isHidden ? .identity : transform.translatedBy(x: tx, y: 0)
        secondStarView.transform = isHidden ? .identity : transform
        thirdStarView.transform = isHidden ? .identity : transform.translatedBy(x: -tx, y: 0)
        
        UIView.animate(withDuration: duration, delay: 0, options: curve, animations: {
            self.stars.forEach { $0.alpha = isHidden ? 0 : 1 }
            
            self.firstStarView.transform = isHidden ? transform.translatedBy(x: tx, y: 0) : .identity
            self.secondStarView.transform = isHidden ? transform : .identity
            self.thirdStarView.transform = isHidden ? transform.translatedBy(x: -tx, y: 0) : .identity
        }) { _ in
            if isHidden {
                self.stars.forEach { $0.hideFill() }
                self.stars.forEach { $0.transform = .identity }
            }
            completion?(self)
        }
    }
    
    private func setupStars() {
        for _ in 0...2 {
            let view = VASingleStar(starSize: configuration.starSize)
            view.alpha = 0
            view.setDefault(borderColor: configuration.borderColor, starColor: configuration.defaultColor)
            
            stars.append(view)
        }
    }
    
    private func setupConstraints() {
        firstStarView.translatesAutoresizingMaskIntoConstraints = false
        secondStarView.translatesAutoresizingMaskIntoConstraints = false
        thirdStarView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            firstStarView.leftAnchor.constraint(equalTo: leftAnchor),
            firstStarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            firstStarView.rightAnchor.constraint(equalTo: secondStarView.leftAnchor),
            
            secondStarView.topAnchor.constraint(equalTo: topAnchor),
            secondStarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -configuration.starSize * 0.3),
            
            thirdStarView.leftAnchor.constraint(equalTo: secondStarView.rightAnchor),
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

#Preview(traits: .portrait) {
    return ViewController()
}
