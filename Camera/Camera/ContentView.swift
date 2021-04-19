//
//  ContentView.swift
//  Camera
//
//  Created by Erika on 05.04.2021.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    var body: some View {
        CameraView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CameraView: View{
    
    @StateObject var camera = CameraModel()
    
    var body: some View{
        
        ZStack{
            
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack{
                
                HStack{
                
                    Spacer()
                    
                    if camera.isTaken{
                        Button(action: camera.retakePicture, label: {
                            Image(systemName: "camera.rotate")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                            
                        })
                        .padding(.trailing)
                    
                    }
                }
                
                Spacer()
                
                HStack{
                    
                    if camera.isTaken{
                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                            
                        })
                        .padding(.leading)
                        
                        Spacer()
                        
                    }
                    
                    else{
                        
                        Button(action: {camera.takePicture()}, label: {
                            
                            ZStack{
                            
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.checkAuthorization()
        })
    }
}


class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    
    @Published var isTaken = false
    @Published var session  = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    
    func checkAuthorization(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {(status) in
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
                
        default:
            return
        }
        
    }
    
    func setUp() {
        
        do {
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            if self.session.canAddOutput(output){
                self.session.addOutput(output)
            }
            
            self.session.commitConfiguration()
            
        }
        
        catch{
            print(error.localizedDescription)
        }
    }
    
    func takePicture(){
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func retakePicture(){
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                self.isSaved = false
                self.picData = Data(count: 0)
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil{
            return
        }
        print("picture taken..")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        
        self.picData = imageData
        
    }
    
    func savePic(){
        
        guard let image = UIImage(data: self.picData) else{return}
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("saved successfully..")
        self.isSaved = true
        
    }
}


struct CameraPreview: UIViewRepresentable{
    
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
