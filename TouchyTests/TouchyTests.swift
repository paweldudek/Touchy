//
//  TouchyTests.swift
//  TouchyTests
//
//  Created by Paweł Dudek on 09/05/2017.
//  Copyright © 2017 Pawel Dudek. All rights reserved.
//

import XCTest
@testable import Touchy

class TouchyTests: XCTestCase {

    var captor: TargetActionCaptor!

    override func setUp() {
        captor = TargetActionCaptor()

        super.setUp()
    }

    override func tearDown() {
        captor = nil
        super.tearDown()
    }

    // MARK: UIButton

    func testTapButton() {
        let frame = CGRect(x: 0, y: 0, width: 42, height: 42)

        let view = UIView(frame: frame)
        let button = UIButton(frame: frame)

        button.setTitle("Fixture Title", for: .normal)
        button.addTarget(captor, action: #selector(TargetActionCaptor.action), for: .touchUpInside)

        view.addSubview(button)

        view.specTapElement(with: "Fixture Title")

        XCTAssertTrue(captor.actionCalled, "It should have tapped the button")
    }

    func testTapButtonInDeepHierarchy() {
        let view = UIView(frame: .zero)
        let secondView = UIView(frame: .zero)
        let thirdView = UIView(frame: .zero)
        let button = UIButton(frame: .zero)

        button.setTitle("Fixture Title", for: .normal)
        button.addTarget(captor, action: #selector(TargetActionCaptor.action), for: .touchUpInside)

        view.addSubview(secondView)
        secondView.addSubview(thirdView)
        thirdView.addSubview(button)

        view.specTapElement(with: "Fixture Title")

        XCTAssertTrue(captor.actionCalled, "It should have tapped the button")
    }

    func testTapButtonWhenMultipleButtonsFound() {
        let view = UIView(frame: .zero)
        let button1 = UIButton(frame: .zero)
        let button2 = UIButton(frame: .zero)
        let button3 = UIButton(frame: .zero)

        button1.setTitle("Fixture Title 1", for: .normal)
        button2.setTitle("Fixture Title 2", for: .normal)
        button3.setTitle("Fixture Title 3", for: .normal)
        button1.addTarget(captor, action: #selector(TargetActionCaptor.action), for: .touchUpInside)

        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)

        view.specTapElement(with: "Fixture Title 1")

        XCTAssertTrue(captor.actionCalled, "It should have tapped the button")
    }

    func testTapButtonWhenMultipleButtonsWithSameTitleFound() {
        let view = UIView(frame: .zero)
        let button1 = UIButton(frame: .zero)
        let button2 = UIButton(frame: .zero)
        let button3 = UIButton(frame: .zero)

        button1.setTitle("Fixture Title", for: .normal)
        button1.setTitle("Fixture Title", for: .normal)
        button1.setTitle("Fixture Title", for: .normal)
        button1.addTarget(captor, action: #selector(TargetActionCaptor.action), for: .touchUpInside)

        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)

        view.specTapElement(with: "Fixture Title")

        XCTAssertTrue(captor.actionCalled, "It should have tapped the first button")
    }

    // MARK: Accessibility

    func testTapButtonWithAccessibilityLabel() {
        let view = UIView(frame: .zero)
        let button1 = UIButton(frame: .zero)
        let button2 = UIButton(frame: .zero)
        let button3 = UIButton(frame: .zero)

        button1.accessibilityLabel = "Fixture Accessibility Label"
        button1.setTitle("Fixture Title", for: .normal)
        button1.setTitle("Fixture Title", for: .normal)
        button1.addTarget(captor, action: #selector(TargetActionCaptor.action), for: .touchUpInside)

        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)

        view.specTapAccessibilityElement(with: "Fixture Accessibility Label")

        XCTAssertTrue(captor.actionCalled, "It should have tapped the first button")
    }

    // MARK: UITextField

    func testEnterText() {
        let view = UIView(frame: .zero)
        let textField = UITextField(frame: .zero)

        textField.placeholder = "Fixture Placeholder"

        view.addSubview(textField)

        view.specEnter(text: "Fixture Text", intoElementWith: "Fixture Placeholder")

        XCTAssertEqual(textField.text, "Fixture Text", "It should have tapped the button")
    }

    func testEnterTextIntoAccessibilityElement() {
        let view = UIView(frame: .zero)
        let textField = UITextField(frame: .zero)

        textField.accessibilityLabel = "Fixture Accessibility Label"

        view.addSubview(textField)

        view.specEnter(text: "Fixture Text", intoAccessibilityElementWith: "Fixture Accessibility Label")

        XCTAssertEqual(textField.text, "Fixture Text", "It should have tapped the button")
    }

    // MARK: UIBarButtonItem

    func testBarButtonItem() {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: captor,
            action: #selector(TargetActionCaptor.action)
        )

        barButtonItem.specSimulateTap()

        XCTAssertTrue(captor.actionCalled, "It should have called the target with action")
    }
}

class TargetActionCaptor: NSObject {

    var actionCalled = false

    @objc func action() {
        actionCalled = true
    }
}
