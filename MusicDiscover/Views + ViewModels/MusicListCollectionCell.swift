
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MusicListCollectionCell: UICollectionViewCell {

  @IBOutlet weak var countContainerView: UIVisualEffectView! {
    didSet {
      countContainerView.layer.cornerRadius = 10
    }
  }
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var artWorkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    setAppearance()
  }

  private func setAppearance() {
    layer.cornerRadius = 10
    clipsToBounds = true
  }

  func setData(with data: MusicInfo) {
    let url = URL(string: data.currentTrack.artworkUrl)
    artWorkImageView.kf.setImage(with: url)
    nameLabel.text = data.name
    genreLabel.text = data.genres.joined(separator: ",")
    countLabel.text = String(data.listenerCount)
  }
}

extension MusicListCollectionCell {
  static var identifier: String { "\(self)" }
}
