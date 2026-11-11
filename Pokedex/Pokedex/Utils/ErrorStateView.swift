//
//  ErrorStateView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 11/11/26.
//

import SwiftUI

/// Estado de erro reutilizável com botão de tentar novamente.
struct ErrorStateView: View {
    let error: RequestError
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)

            Text(error.localizedDescription)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Tentar novamente", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
    }
}

#Preview {
    ErrorStateView(error: .unexpectedStatusCode) {}
}
