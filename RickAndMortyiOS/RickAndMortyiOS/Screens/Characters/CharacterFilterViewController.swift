//
//  CharacterFilterViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 26.12.2020.
//

import SwiftUI

protocol CharacterFilterDelegate {
    func didFilterTapped(selectedStatus: String?, selectedGender: String?)
}

struct CharacterFilterView: View {
    var filterDelegate: CharacterFilterDelegate

    @State private var lastSelectedStatus: String?
    @State private var lastSelectedGender: String?
    
    init(filterDelegate: CharacterFilterDelegate, currentStatus: String, currentGender: String) {
        self.filterDelegate = filterDelegate
    }

    var body: some View {
        VStack {
            PickerTextField(
                data: ["alive", "dead", "unknown"],
                placeholder: "Select Status",
                lastSelected: $lastSelectedStatus
            )
            .frame(height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(UIColor.rickBlue), lineWidth: 1)
            )
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.vertical, 5)

            PickerTextField(
                data: ["female", "male", "genderless", "unknown"],
                placeholder: "Select Gender",
                lastSelected: $lastSelectedGender
            )
            .frame(height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(UIColor.rickBlue), lineWidth: 1)
            )
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.vertical, 5)

            CustomButtonView(backgroundColor: Color(UIColor.rickBlue), title: "Filter") {
                filterDelegate.didFilterTapped(selectedStatus: lastSelectedStatus, selectedGender: lastSelectedGender)
            }
            .padding(.horizontal)

            CustomButtonView(backgroundColor: Color(UIColor.rickBlue), title: "Clear") {
                filterDelegate.didFilterTapped(selectedStatus: "", selectedGender: "")
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(width: 200)
        .padding()
    }
}
