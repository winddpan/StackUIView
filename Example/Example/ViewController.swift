//
//  ViewController.swift
//  Example
//
//  Created by PAN on 2022/10/31.
//

import StackUIView
import UIKit

class ViewModel {
    @RxDriver private(set) var text: String = "short text"
    @RxDriver private(set) var text2: String = "dynamic load"
    @RxDriver private(set) var spacing: CGFloat = 20

    deinit {
        print("ViewModel deinit")
    }

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.text = "long text long text long text\n long text long text long text long text long\n text long text long text "
            self.text2 = "dynamic load >>>\n 💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊💊"
            self.spacing = .random(in: 80 ... 100)
        }
    }
}

class ViewController: UIViewController {
    let viewModel = ViewModel()

    deinit {
        print("ViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = self.viewModel
        let stackView = VStackView(alignment: .leading, spacing: 10) {
//            UILabel()
//                .perform { view in
//                    view.numberOfLines = 0
//                    view.backgroundColor = .lightGray
//                    view.textColor = .red
//                }
//                .onReceive(viewModel.$text) { view, text in
//                    view.text = text
//                }
//                .padding(.leading, 20)
//                .padding(.top, 30)
//                .perform { view in
//                    view.backgroundColor = .green
//                }
//
//            Divider()
//

//            Spacer()
//                .perform {
//                    $0.backgroundColor = .yellow
//                }
//                .onReceive(viewModel.$spacing) {
//                    $0.spacing = $1
//                }

            Spacer()
                .perform {
                    $0.backgroundColor = .purple
                    $0.addSubview(
                        UILabel()
                            .onReceive(viewModel.$spacing) {
                                $0.text = "spacing \($1)"
                            }
                    )
                }
                .onReceive(viewModel.$spacing) {
                    $0.spacing = $1
                }

//
//            Divider()
//
//            LazyBoxView(whenLoad: viewModel.$text2.map { $0.count > 3 }) {
//                UILabel()
//                    .perform { view in
//                        view.numberOfLines = 0
//                        view.backgroundColor = .lightGray
//                        view.textColor = .red
//                    }
//                    .onReceive(viewModel.$text2) { view, text in
//                        view.text = text
//                    }
//                    .padding(20)
//                    .onReceive(viewModel.$text2) { view, text in
//                        view.alpha = text.count < 5 ? 0.5 : 1
//                    }
//                    .perform { view in
//                        view.backgroundColor = .yellow
//                    }
//            }

            ZStackView(alignment: .center) {
                UIView()
                    .sizeConstraint(width: 200, height: 200)
                    .perform { view in
                        view.backgroundColor = .blue

                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            view.sizeConstraint(width: 300, height: 300)
                        }
                    }

                UILabel()
                    .perform { label in
                        label.backgroundColor = .yellow
                        label.numberOfLines = 0
                        label.text = "ZStack\nmultiple line!\nmultiple line!"

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            label.text = "ZStack one line!"
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            label.text = " === ZStack alignment changed! === "
                        }
                    }
            }
            .perform { zstack in
                zstack.backgroundColor = .red

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    zstack.insertArrangedSubview(at: 1) {
                        UILabel()
                            .perform {
                                $0.backgroundColor = .systemPink
                                $0.numberOfLines = 0
                                $0.text = "\n\n new arrange view!"
                            }
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    zstack.alignment = .top
                }
            }
        }

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0.0, *)
struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController().toPreview()
    }
}

#endif
