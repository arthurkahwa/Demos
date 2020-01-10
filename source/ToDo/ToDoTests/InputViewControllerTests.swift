//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Arthur Nsereko Kahwa on 1/10/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import XCTest
import CoreLocation

@testable import ToDo

extension InputViewControllerTests {
  class MockGeocoder: CLGeocoder {
     
    var completionHandler: CLGeocodeCompletionHandler?
     
    override func geocodeAddressString(
      _ addressString: String,
      completionHandler: @escaping CLGeocodeCompletionHandler) {

      self.completionHandler = completionHandler
    }
  }
    
    class MockPlacemark : CLPlacemark {
       
      var mockCoordinate: CLLocationCoordinate2D?
       
      override var location: CLLocation? {
        guard let coordinate = mockCoordinate else
        { return CLLocation() }
         

        return CLLocation(latitude: coordinate.latitude,
                          longitude: coordinate.longitude)
      }
    }
}

class InputViewControllerTests: XCTestCase {

    var inputViewController: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        inputViewController = storyboard
          .instantiateViewController(
            withIdentifier: "InputViewController")
            as? InputViewController
         

        inputViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_HasTitleTextField() {
      let titleTextFieldIsSubView =
        inputViewController.titleTextField?.isDescendant(
          of: inputViewController.view) ?? false
      XCTAssertTrue(titleTextFieldIsSubView)
    }
    
    func test_HasDateTextField() {
      let textFieldIsSubView =
        inputViewController.dateTextField?.isDescendant(
          of: inputViewController.view) ?? false
      XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasLocsationYextField() {
      let textFieldIsSubView =
        inputViewController.locsationYextField?.isDescendant(
          of: inputViewController.view) ?? false
      XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasAddressTextField() {
      let textFieldIsSubView =
        inputViewController.addressTextField?.isDescendant(
          of: inputViewController.view) ?? false
      XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasDescriptionTextField() {
      let textFieldIsSubView =
        inputViewController.descriptionTextField?.isDescendant(
          of: inputViewController.view) ?? false
      XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasCancelButton() {
      let textFieldIsSubView =
        inputViewController.cancelButton?.isDescendant(
          of: inputViewController.view) ?? false
      XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_HasSaveButton() {
      let textFieldIsSubView =
        inputViewController.saveButton?.isDescendant(
          of: inputViewController.view) ?? false
      XCTAssertTrue(textFieldIsSubView)
    }
    
    func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM/dd/yyyy"
         

      let timestamp = 1456095600.0
      let date = Date(timeIntervalSince1970: timestamp)
       

      inputViewController.titleTextField.text = "Foo"
      inputViewController.dateTextField.text = dateFormatter.string(from: date)
      inputViewController.locsationYextField.text = "Bar"
      inputViewController.addressTextField.text = "Infinite Loop 1, Cupertino"
      inputViewController.descriptionTextField.text = "Baz"
       
      let mockGeocoder = MockGeocoder()
      inputViewController.geocoder = mockGeocoder
       
      inputViewController.itemManager = ItemManager()
       
      inputViewController.save()
       
      placemark = MockPlacemark()
      let coordinate = CLLocationCoordinate2DMake(37.3316851,
                                                  -122.0300674)
      placemark.mockCoordinate = coordinate
      mockGeocoder.completionHandler?([placemark], nil)
       
      let item = inputViewController.itemManager?.item(at: 0)
       
      let testItem = ToDoItem(title: "Foo",
                              itemDescription: "Baz",
                              timeStamp: timestamp,
                              location: Location(name: "Bar",
                                                 coordinate: coordinate))
       
      XCTAssertEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
      let saveButton: UIButton = inputViewController.saveButton
       
      guard let actions = saveButton.actions(
        forTarget: inputViewController,
        forControlEvent: .touchUpInside) else {
          XCTFail(); return
      }
       
      XCTAssertTrue(actions.contains("save"))
    }
}
