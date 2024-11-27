//
//  ObservationsView.swift
//  DeviceClassifier
//
//  Created by Tomáš Pařízek on 27.11.2024.
//

import SwiftUI

struct ObservationsView: View {
    let observations: [String: Float]

    var body: some View {
        VStack(spacing: 16) {
            ForEach(Array(observations.keys).sorted(), id: \.self) { identifier in
                HStack {
                    Text(identifier)

                    Spacer()

                    Text(formatPercentage(observations[identifier] ?? 0))
                }
                .opacity(Double(observations[identifier] ?? 0) / 2 + 0.5)
            }
        }
        .foregroundStyle(Color.white)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.25))
        }
        .padding()
    }
}

private extension ObservationsView {
    func formatPercentage(_ value: Float) -> String {
        "\(Int(value * 100))%"
    }
}
