//
//  BasePopupViewController.swift
//  PopupViewController
//
//  Created by Henry Heguang Miao on 11/6/17.
//  Copyright © 2017 Henry Miao. All rights reserved.
//

import UIKit

public protocol PopupContentViewType: class {
    func setParentController(_ controller: PopupViewController)
}

/// Pop up any view using PopupViewController.
public class PopupViewController: UIViewController {

    public enum Position {
        case aboveTop
        case top
        case middle
        case bottom
        case belowBottom
    }

    public var contentView: UIView

    public var beginPosition: Position = .belowBottom
    public var endPosition: Position = .middle

    public var animationDuration: TimeInterval = 0.4

    /// Left margin between the popup view and the container.
    public var marginLeft: CGFloat = 30

    /// Right margin between the popup view and the container.
    public var margingRight: CGFloat = 30

    public var marginTop: CGFloat = 0
    public var marginBottom: CGFloat = 0

    /// Height of the popup view. By default it will be calculated by the auto layout constraints.
    public var contentViewHeight: CGFloat = UITableViewAutomaticDimension

    fileprivate var animator: PopAnimator!

    public init<T: UIView>(contentView: T) where T: PopupContentViewType {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        self.animator = PopAnimator(popupViewController: self)
        contentView.setParentController(self)
        self.modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(contentView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundOnTap(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)

    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func backgroundOnTap(gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PopupViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.reverse = false
        return animator
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.reverse = true
        return animator
    }
}

fileprivate class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    unowned var popupViewController: PopupViewController
    var reverse = false

    init(popupViewController: PopupViewController) {
        self.popupViewController = popupViewController
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return popupViewController.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if !reverse {
            popupAnimation(using: transitionContext)
        } else {
            dismissAnimation(using: transitionContext)
        }
    }

    func popupAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let animateDuration = self.transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to) as? PopupViewController else { return }
        containerView.addSubview(toViewController.view)
        toViewController.view.frame = containerView.bounds
        toViewController.view.backgroundColor = .clear

        let contentView = toViewController.contentView

        let width = containerView.frame.size.width - toViewController.marginLeft - toViewController.margingRight
        var height = toViewController.contentViewHeight
        if height == -1 {
            // Calculate height according to constraints
            var compressedSize = UILayoutFittingCompressedSize
            compressedSize.width = width
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
            let fittingSize = contentView.systemLayoutSizeFitting(compressedSize)
            height = fittingSize.height
        }


        func yAxis(forPosition position: PopupViewController.Position) -> CGFloat {
            var y: CGFloat = 0
            switch position {
            case .aboveTop:
                y = -height
            case .top:
                y = toViewController.marginTop
            case .middle:
                y = (containerView.frame.height - height) / 2
            case .bottom:
                y = containerView.frame.height - height - toViewController.marginBottom
            case .belowBottom:
                y = containerView.frame.height
            }
            return y
        }

        let beginY = yAxis(forPosition: toViewController.beginPosition)
        let endY = yAxis(forPosition: toViewController.endPosition)


        let beginFrame = CGRect(x: toViewController.marginLeft, y: beginY, width: width, height: height)
        let endFrame = CGRect(x: toViewController.marginLeft, y: endY, width: width, height: height)

        contentView.frame = beginFrame

        UIView.animate(withDuration: animateDuration, animations: {
            toViewController.view.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
            contentView.frame = endFrame
        }) { (_) in
            transitionContext.completeTransition(true)
        }

    }

    func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let animateDuration = self.transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? PopupViewController else { return }

        containerView.addSubview(fromViewController.view)
        fromViewController.view.backgroundColor = .clear

        let contentView = fromViewController.contentView

        let height = contentView.frame.height

        func yAxis(forPosition position: PopupViewController.Position) -> CGFloat {
            var y: CGFloat = 0
            switch position {
            case .aboveTop:
                y = -height
            case .top:
                y = fromViewController.marginTop
            case .middle:
                y = (containerView.frame.height - height) / 2
            case .bottom:
                y = containerView.frame.height - height - fromViewController.marginBottom
            case .belowBottom:
                y = containerView.frame.height
            }
            return y
        }

        let endY = yAxis(forPosition: fromViewController.beginPosition)
        let endFrame = CGRect(x: fromViewController.marginLeft, y: endY, width: contentView.frame.width, height: height)

        UIView.animate(withDuration: animateDuration, animations: {
            fromViewController.view.backgroundColor = .clear
            contentView.frame = endFrame
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
