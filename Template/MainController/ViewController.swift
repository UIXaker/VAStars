import UIKit

class ViewController: UIViewController {

    private var mainView: MainView { view as! MainView }
    override func loadView() { view = MainView() }
    
    let whiteFillConf: VAStarsConfiguration.FillType = .zero
    let whiteFullFillConf: VAStarsConfiguration.FillType = .three([.white])
    let redFillConf: VAStarsConfiguration.FillType = .one(.init(hex: 0xF63E28))
    let yellowFillConf: VAStarsConfiguration.FillType = .two([.init(hex: 0xF6B928)])
    let greenFillConf: VAStarsConfiguration.FillType = .three([.init(hex: 0x1DB954)])
    
    var isHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        mainView.addGestureRecognizer(gesture)
    }
    
    @objc private func viewDidTapped() {
        isHidden.toggle()
        
        let anime: AnimationType = !isHidden ? .scale(duration: 0.3, factor: 0.6) : .fade(duration: 0.3, deley: 0.15)
        
        mainView.whiteStarsView.setVisibility(animated: true, with: .scale(duration: 0.3, factor: 0.6), isHidden: isHidden)
        
        mainView.whiteFullStarsView.setVisibility(animated: true, with: anime, isHidden: isHidden) { [weak self] stars in
            guard let self = self else { return }
            
            if !isHidden {
                stars.animateFallingStars(
                    fill: self.whiteFullFillConf,
                    animated: true,
                    firstDelay: 0.3,
                    delay: 0.15,
                    completion: { }
                )
            }
        }
        
        mainView.redStarsView.setVisibility(animated: true, with: .fade(duration: 0.3, deley: 0.15), isHidden: isHidden) { [weak self] stars in
            guard let self = self else { return }
            
            if !isHidden {
                stars.animateFallingStars(
                    fill: self.redFillConf,
                    animated: true,
                    firstDelay: 0.3,
                    delay: 0.15,
                    completion: { }
                )
            }
        }
  
        mainView.yellowStarsView.setVisibility(animated: true, with: .scale(duration: 0.3, factor: 0.6), isHidden: isHidden) { [weak self] stars in
            guard let self = self else { return }
              
            if !isHidden {
                stars.animateFallingStars(
                    fill: self.yellowFillConf,
                    animated: true,
                    firstDelay: 0.3,
                    delay: 0.15,
                    completion: { }
                )
            }
        }
 
        mainView.greenStarsView.setVisibility(animated: true, with: anime, isHidden: isHidden) { [weak self] stars in
            guard let self = self else { return }
              
            if !isHidden {
                stars.animateFallingStars(
                    fill: self.greenFillConf,
                    animated: true,
                    firstDelay: 0.3,
                    delay: 0.15,
                    completion: { }
                )
            }
        }
    }
}

#Preview(traits: .portrait) {
    ViewController()
}
