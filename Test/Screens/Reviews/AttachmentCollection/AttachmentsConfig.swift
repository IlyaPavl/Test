//
//  AttachmentsConfig.swift
//  Test
//
//  Created by Илья Павлов on 28.02.2025.
//

import UIKit

struct AttachmentsConfig: UIContentConfiguration {
    var attachmentURL: String?
    
    func makeContentView() -> UIView & UIContentView {
        return AttachmentsContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> AttachmentsConfig {
        return self
    }
}
