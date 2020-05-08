//
//  Copyright © 2016-2020 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

import EarlGrey

public extension EarlGrey {

    class func element(_ accessibilityLabel: String, file: StaticString = #file, line: UInt = #line) -> GREYInteraction {
        return selectElement(with: grey_accessibilityLabel(accessibilityLabel), file: file, line: line).atIndex(0).assert(grey_sufficientlyVisible())
    }

    class func element(withID accessibilityID: String, file: StaticString = #file, line: UInt = #line) -> GREYInteraction {
        return selectElement(with: grey_accessibilityID(accessibilityID), file: file, line: line).atIndex(0).assert(grey_sufficientlyVisible())
    }

    class func keyWindow(file: StaticString = #file, line: UInt = #line) -> GREYInteraction {
        return selectElement(with: grey_keyWindow(), file: file, line: line).assert(grey_sufficientlyVisible())
    }

    class func doesElementExist(_ accessibilityLabel: String, file: StaticString = #file, line: UInt = #line) -> Bool {
        var error: NSError?
        selectElement(with: grey_accessibilityLabel(accessibilityLabel), file: file, line: line).atIndex(0).assert(grey_notNil(), error: &error)
        return error == nil
    }

    class func dismissKeyboard(withError errorOrNil: UnsafeMutablePointer<NSError?>! = nil, file: StaticString = #file, line: UInt = #line) {
        self.synchronized(false) {
            EarlGreyImpl.invoked(fromFile: file.description, lineNumber: line).dismissKeyboardWithError(errorOrNil)
        }
    }

    // MARK: Synchronization API
    class func synchronized(_ enabled: Bool = true, _ block: () -> Void) {
        let configuration = GREYConfiguration.sharedInstance()
        let originalValue = configuration.boolValue(forConfigKey: kGREYConfigKeySynchronizationEnabled)

        configuration.setValue(enabled, forConfigKey: kGREYConfigKeySynchronizationEnabled)
        block()
        configuration.setValue(originalValue, forConfigKey: kGREYConfigKeySynchronizationEnabled)
    }

    class func wait(seconds: CFTimeInterval = 2) {
        GREYCondition(name: "manual wait") {
            return false
        }.wait(withTimeout: seconds)
    }
}

public extension GREYCondition {

    /// Waits with the default timeout.
    @discardableResult func wait() -> Bool {
        return wait(withTimeout: 2)
    }
}

/// Helper to capture element/view after resolution
@objc class GREYDummyAction: NSObject, GREYAction {
    var element: Any?
    func perform(_ element: Any, error errorOrNil: UnsafeMutablePointer<NSError?>?) -> Bool {
        self.element = element
        return true
    }
    public func name() -> String { return "GREY/PSPDF Element Capturing Action" }
    override init() {}
}

public extension GREYInteraction {
    func tap() {
        __perform(grey_tap())
    }

    func tapAndWait() {
        __perform(grey_tap())
        drainUntilIdle()
    }

    func tap(at point: CGPoint) {
        __perform(grey_tapAtPoint(point))
    }

    func longPress() {
        __perform(grey_longPress())
    }

    func longPress(at point: CGPoint) {
        __perform(grey_longPressAtPointWithDuration(point, kGREYLongPressDefaultDuration))
    }

    func swipe(_ direction: GREYDirection = .right) {
        __perform(grey_swipeFastInDirection(direction))
    }

    func swipeSlowlyIn(direction: GREYDirection) {
        __perform(grey_swipeSlowInDirection(direction))
    }

    func type(_ text: String) {
        __perform(grey_typeText(text))
    }

    var snapshot: UIImage {
        var image: UIImage?
        perform(grey_snapshot(&image))
        return image!
    }

    func assertVisible() {
        assert(grey_sufficientlyVisible())
    }

    func drainUntilIdle() {
        GREYAssertNotNil(self, reason: "Using assert for idle draining")
    }

    /// Convert the GREYInteraction to a view, if possible
    func view() -> UIView? {
        let dummyAction = GREYDummyAction()
        perform(dummyAction)
        return dummyAction.element as? UIView
    }
}
