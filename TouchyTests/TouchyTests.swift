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

    func testTapButtonWithDifferentAction() {
        let frame = CGRect(x: 0, y: 0, width: 42, height: 42)

        let view = UIView(frame: frame)
        let button = UIButton(frame: frame)

        button.setTitle("Fixture Title", for: .normal)
        button.addTarget(captor, action: #selector(TargetActionCaptor.action), for: .valueChanged)

        view.addSubview(button)

        view.specTapElement(with: "Fixture Title")

        XCTAssertFalse(captor.actionCalled, "It should not have called the targets action")
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

    func testBarButtonItemWithCustomButtonViewWithTargetAction() {
        let button = UIButton()
        button.addTarget(captor, action: #selector(TargetActionCaptor.action), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)

        barButtonItem.specSimulateTap()

        XCTAssertTrue(captor.actionCalled, "It should have called the target with action")
    }

    func testBarButtonItemWithCustomButtonViewWithAction() {
        var actionCalled = false
        let button = UIButton(primaryAction: .init(handler: { _ in
            actionCalled = true
        }))
        let barButtonItem = UIBarButtonItem(customView: button)

        barButtonItem.specSimulateTap()

        XCTAssertTrue(actionCalled, "It should have called the action")
    }

    // MARK: UITableView

    func testTableView() {
        let dataSource = DummyTableDelegateDataSource()
        let tableView = UITableView(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 480)))
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.layoutIfNeeded()

        tableView.specTapTableViewCell(with: "Fixture Text 3")

        guard let lastSelectedIndexPath = dataSource.lastSelectedIndexPath else {
            XCTFail("No index path was recorded")
            return
        }

        XCTAssertEqual(lastSelectedIndexPath, IndexPath(row: 3, section: 0))
    }

    // MARK: UICollectionView

    func testCollectionView() {
        let dataSource = DummyCollectionViewDelegateDataSource()
        let collectionView = UICollectionView(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 480)), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.register(DummyCollectionViewDelegateDataSource.TitleableCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.layoutIfNeeded()

        collectionView.specTapCollectionViewCell(with: "Fixture Text 3")

        guard let lastSelectedIndexPath = dataSource.lastSelectedIndexPath else {
            XCTFail("No index path was recorded")
            return
        }

        XCTAssertEqual(lastSelectedIndexPath, IndexPath(row: 3, section: 0))
    }
}

class TargetActionCaptor: NSObject {

    var actionCalled = false

    @objc func action() {
        actionCalled = true
    }
}

class DummyTableDelegateDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {

    var lastSelectedIndexPath: IndexPath?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: .zero)
        cell.textLabel?.text = "Fixture Text \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedIndexPath = indexPath
    }
}

class DummyCollectionViewDelegateDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    class TitleableCollectionViewCell: UICollectionViewCell, Titleable {
        var title: String?
    }

    var lastSelectedIndexPath: IndexPath?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TitleableCollectionViewCell
        cell.title = "Fixture Text \(indexPath.row)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lastSelectedIndexPath = indexPath
    }
}
