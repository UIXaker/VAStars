import UIKit

class MainView: UIView {
    
    let whiteStarsView: VAStars = {
        let configuration = VAStarsConfiguration(
            starSize: 40,
            borderColor: .white,
            defaultColor: .white,
            animationType: .fade(duration: 0.3, deley: 0.15)
        )
        
       return VAStars(configuration: configuration)
    }()
    
    let whiteFullStarsView: VAStars = {
        let configuration = VAStarsConfiguration(
            starSize: 40,
            borderColor: .white,
            defaultColor: .white,
            animationType: .scale(duration: 0.3, factor: 0.6)
        )
        
       return VAStars(configuration: configuration)
    }()
    
    let redStarsView: VAStars = {
        let configuration = VAStarsConfiguration(
            starSize: 40,
            borderColor: .init(hex: 0x929292),
            defaultColor: .init(hex: 0x929292),
            animationType: .fade(duration: 0.3, deley: 0.15)
        )
        
       return VAStars(configuration: configuration)
    }()
    
    let yellowStarsView: VAStars = {
        let configuration = VAStarsConfiguration(
            starSize: 40,
            borderColor: .init(hex: 0x929292),
            defaultColor: .init(hex: 0x929292),
            animationType: .fade(duration: 0.3, deley: 0.15)
        )
        
       return VAStars(configuration: configuration)
    }()
    
    let greenStarsView: VAStars = {
        let configuration = VAStarsConfiguration(
            starSize: 40,
            borderColor: .init(hex: 0x929292),
            defaultColor: .init(hex: 0x929292),
            animationType: .scale(duration: 0.3, factor: 0.6)
        )
        
       return VAStars(configuration: configuration)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(hex: 0x252525)
        
        addSubview(whiteStarsView)
        addSubview(whiteFullStarsView)
        addSubview(redStarsView)
        addSubview(yellowStarsView)
        addSubview(greenStarsView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        whiteStarsView.translatesAutoresizingMaskIntoConstraints = false
        whiteFullStarsView.translatesAutoresizingMaskIntoConstraints = false
        redStarsView.translatesAutoresizingMaskIntoConstraints = false
        yellowStarsView.translatesAutoresizingMaskIntoConstraints = false
        greenStarsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            whiteStarsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            whiteStarsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24.0),
            
            whiteFullStarsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            whiteFullStarsView.topAnchor.constraint(equalTo: whiteStarsView.bottomAnchor, constant: 24.0),
            
            redStarsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            redStarsView.topAnchor.constraint(equalTo: whiteFullStarsView.bottomAnchor, constant: 24.0),
            
            yellowStarsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            yellowStarsView.topAnchor.constraint(equalTo: redStarsView.bottomAnchor, constant: 24.0),
            
            greenStarsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            greenStarsView.topAnchor.constraint(equalTo: yellowStarsView.bottomAnchor, constant: 24.0),
        ])
    }
    
}
