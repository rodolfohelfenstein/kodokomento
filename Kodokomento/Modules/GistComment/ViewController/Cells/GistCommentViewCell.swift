//
//  GistCommentViewCell.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 06/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Kingfisher
import UIKit

class GistCommentViewCell: UITableViewCell {
    @IBOutlet var boxView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var commentTitle: UILabel!
    @IBOutlet var commentDate: UILabel!
    @IBOutlet var commentBody: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true

        boxView.layer.cornerRadius = 4.0
        boxView.layer.borderColor = #colorLiteral(red: 0.8196078431, green: 0.8352941176, blue: 0.8549019608, alpha: 1)
        boxView.layer.borderWidth = 1.0
    }

    func setItem(gistComment: GistComment) {
        avatarImageView.kf.indicator?.startAnimatingView()

        avatarImageView.kf.setImage(with: gistComment.user.avatar,
                                    placeholder: nil,
                                    options: [.transition(ImageTransition.fade(0.3))],
                                    progressBlock: nil) { _, _, _, _ in

            self.avatarImageView.kf.indicator?.stopAnimatingView()
        }

        commentTitle.text = gistComment.user.login
        commentBody.text = gistComment.body

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM\nyy"

        commentDate.text = formatter.string(from: gistComment.createdAt)
    }
}
