//
//  PictureDiaryModel.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/30.
//

class PictureDiaryModel {
    
    func saveImage(image: UIImage, path: String){
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent("HARU")
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
        } catch let e {
            print(e.localizedDescription)
            
        }

        let imageURL = directoryURL.appendingPathComponent("20210430.png")
        do {
            let pngImageData = image.pngData()
            try pngImageData?.write(to: imageURL)
            
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    func loadImage(path: String) -> UIImage {

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent("HARU")
        let imagePath = directoryURL.appendingPathComponent(path)

        let image = UIImage(contentsOfFile: imagePath.path)
        return image!

    }
}
