//
//  PickerTextField.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 27.12.2020.
//

import SwiftUI

struct PickerTextField: UIViewRepresentable {
    
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let helper = Helper()

    var data: [String]
    var placeholder: String

    @Binding var lastSelected: String?

    func makeUIView(context: Context) -> UITextField {
        self.pickerView.delegate = context.coordinator
        self.pickerView.dataSource = context.coordinator
        
        self.textField.placeholder = self.placeholder
        self.textField.inputView = self.pickerView
        
        // Configure Accessory View
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self.helper, action: #selector(self.helper.doneButtonAction))
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        self.textField.inputAccessoryView = toolBar
        
        self.helper.doneButtonTapped =  {
            if self.lastSelected == nil {
                self.lastSelected = ""
            }
            self.textField.resignFirstResponder()
        }
        
        self.textField.textAlignment = .center

        return self.textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if let lastSelected = self.lastSelected {
            uiView.text = self.data.first(where: { text in
                text == lastSelected
            })
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(data: self.data) { index in
            self.lastSelected = index
        }
    }
    
    class Helper {
        public var doneButtonTapped: (() -> Void)?
        
        @objc func doneButtonAction() {
            self.doneButtonTapped?()
        }
    }

    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

        private var data: [String]
        private var didSelectItem: ((String) -> Void)?

        init(data: [String], didSelectItem: ((String) -> Void)? = nil) {
            self.data = data
            self.didSelectItem = didSelectItem
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.data.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.data[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.didSelectItem?(self.data[row])
        }
    }
}
