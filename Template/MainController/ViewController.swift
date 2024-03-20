import UIKit

class ViewController: UIViewController {

    private var mainView: MainView { view as! MainView }
    override func loadView() { view = MainView() }
    
    let whiteFillConf: VAStarsConfiguration.FillType = .zero
    let whiteFullFillConf: VAStarsConfiguration.FillType = .three(.white, .white, .white)
    let redFillConf: VAStarsConfiguration.FillType = .one(.init(hex: 0xF63E28))
    let yellowFillConf: VAStarsConfiguration.FillType = .two(
        .init(hex: 0xF6B928),
        .init(hex: 0xF6B928)
    )
    let greenFillConf: VAStarsConfiguration.FillType = .three(
        .init(hex: 0x1DB954),
        .init(hex: 0x1DB954),
        .init(hex: 0x1DB954)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        mainView.addGestureRecognizer(gesture)
    }

    @objc private func viewDidTapped() {
        mainView.whiteStarsView.show(animated: true)
        
        mainView.whiteFullStarsView.show(animated: true) { [weak self] stars in
            guard let self = self else { return }
            
            stars.fillStars(
                fill: self.whiteFullFillConf,
                animated: true,
                firstDelay: 0.3,
                delay: 0.15,
                completion: { }
            )
        }
        
        mainView.redStarsView.show(animated: true) { [weak self] stars in
            guard let self = self else { return }
            
            stars.fillStars(
                fill: self.redFillConf,
                animated: true,
                firstDelay: 0.3,
                delay: 0.15,
                completion: { }
            )
        }
        
        mainView.yellowStarsView.show(animated: true) { [weak self] stars in
            guard let self = self else { return }
            
            stars.fillStars(
                fill: self.yellowFillConf,
                animated: true,
                firstDelay: 0.3,
                delay: 0.15,
                completion: { }
            )
        }
        
        mainView.greenStarsView.show(animated: true) { [weak self] stars in
            guard let self = self else { return }
            
            stars.fillStars(
                fill: self.greenFillConf,
                animated: true,
                firstDelay: 0.3,
                delay: 0.15,
                completion: { }
            )
        }
    }
}

#Preview(traits: .portrait) {
    ViewController()
}
