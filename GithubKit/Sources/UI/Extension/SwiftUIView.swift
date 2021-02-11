//
//  SwiftUIView.swift
//  GithubKit
//
//  Created by marty-suzuki on 2021/02/11.
//  Copyright © 2021 marty-suzuki. All rights reserved.
//

#if DEBUG
import SwiftUI

struct SwiftUIView<T: UIView>: View, UIViewRepresentable {
    let make: () -> T
    let update: (T) -> Void

    func makeUIView(context: Context) -> T {
        make()
    }

    func updateUIView(_ uiView: T, context: Context) {
        update(uiView)
    }
}
#endif
