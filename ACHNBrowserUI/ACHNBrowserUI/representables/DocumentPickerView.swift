//
//  DocumentPickerView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 14/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

#if !os(tvOS)
public final class DocumentPickerView: NSObject, UIViewControllerRepresentable, UIDocumentPickerDelegate {
    public let url: URL?
    public let mode: UIDocumentPickerMode
    
    @Binding var importedFile: URL?
        
    public init(url: URL?, mode: UIDocumentPickerMode, importedFile: Binding<URL?>) {
        self.url = url
        self.mode = mode
        self._importedFile = importedFile
    }
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let file = urls.first {
                parent.importedFile = file
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPickerView>) -> UIDocumentPickerViewController {
        if let url = url, mode == .exportToService {
            let picker = UIDocumentPickerViewController(url: url, in: mode)
            return picker
        } else {
            let picker = UIDocumentPickerViewController(documentTypes: ["com.thomasricouard.ACNH.achelper"],
                                                        in: .import)
            picker.delegate = context.coordinator
            return picker
        }
    }
    
    public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController,
                                       context: UIViewControllerRepresentableContext<DocumentPickerView>) {
        
    }
}
#endif

