/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


struct Photo {
  
  var caption: String
  var comment: String
  var image: UIImage
  
  
  init(caption: String, comment: String, image: UIImage) {
    self.caption = caption
    self.comment = comment
    self.image = image
  }
  
  init?(dictionary: [String: String]) {
    guard let caption = dictionary["Caption"], let comment = dictionary["Comment"], let photo = dictionary["Photo"],
      let image = UIImage(named: photo) else {
        return nil
    }
    self.init(caption: caption, comment: comment, image: image)
  }

  static func allPhotos() -> [Photo] {
    var photos = [Photo]()
    guard let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
      let photosFromPlist = NSArray(contentsOf: URL) as? [[String: String]] else {
        return photos
    }
    for dictionary in photosFromPlist {
      if let photo = Photo(dictionary: dictionary) {
        photos.append(photo)
      }
    }
    return photos
  }
    
   static var gifLink: [String] {
        return [
        "https://media.giphy.com/media/l2R0aKwejYr8ycKAg/giphy.gif",
        "https://media.giphy.com/media/HfPLDqZ50hYFa/giphy.gif",
        "https://media3.giphy.com/media/swXeHfBiRSUkE/giphy.gif",
        "https://media3.giphy.com/media/Y3j1L0h1zhA6Q/giphy.gif",
        "https://media2.giphy.com/media/26BRry8KnZ3zeifeM/giphy.gif",
        "https://media1.giphy.com/media/EyvM6QjqkaOQM/giphy.gif",
        "https://media2.giphy.com/media/mL1KW5MhqFdgQ/giphy.gif",
        "https://media1.giphy.com/media/3osxYBdM2Hl6PXTwRi/giphy.gif",
        "https://media1.giphy.com/media/tpCVcOB6qB7os/giphy.gif",
        "https://media1.giphy.com/media/3osxYjITKBnDpv5orK/giphy.gif",
        "https://media1.giphy.com/media/ZeB4HcMpsyDo4/giphy.gif",
        "https://media1.giphy.com/media/iBoiluDH61ah2/giphy.gif",
        "https://media2.giphy.com/media/12gD9mCSgi5u4o/giphy.gif",
        "https://media2.giphy.com/media/kYNDwz40FWhz2/giphy.gif",
        "https://media3.giphy.com/media/d2Z11bakS9capwZy/giphy.gif",
        "https://media1.giphy.com/media/125QVfheBlAOnm/giphy.gif",
        "https://media3.giphy.com/media/YSPXKqwTUIN8c/giphy.gif",
        "https://media0.giphy.com/media/QHAfOXnQbGCGs/giphy.gif",
        "https://media.giphy.com/media/hf1TGBV2qfA7m/giphy.gif",
        "https://media1.giphy.com/media/3o85xKPAEDCuXxRepO/giphy.gif",
        "https://media1.giphy.com/media/fUwQuyDC6eZ0s/giphy.gif",
        "https://media1.giphy.com/media/q1zsIXcp8N2ne/giphy.gif",
        "https://media0.giphy.com/media/HP3pRDw8U3eZq/giphy.gif",
        "https://media1.giphy.com/media/qxOLqsKVHxqr6/giphy.gif",
        "https://media1.giphy.com/media/3og0Iw2eUAFbUxhaFy/giphy.gif",
        "https://media1.giphy.com/media/PGQ1xNzOa6sxy/giphy.gif",
        "https://media1.giphy.com/media/WotHgjtqxZwfS/giphy.gif",
        "https://media2.giphy.com/media/Jp5yOwzJL8oMM/giphy.gif",
        "https://media1.giphy.com/media/arjG49t3cMYTu/giphy.gif",
        "https://media3.giphy.com/media/OoId38go2peTu/giphy.gif",
        "https://media1.giphy.com/media/VqmD0FGLfzBmw/giphy.gif",
        "https://media1.giphy.com/media/AGkwrGuTfa7Uk/giphy.gif",
        "https://media1.giphy.com/media/8JC7d2W7CgPzW/giphy.gif",
        "https://media1.giphy.com/media/7JDXBtIdOErbG/giphy.gif",
        "https://media1.giphy.com/media/ltvbZD1ugIgh2/giphy.gif",
        "https://media1.giphy.com/media/aj3cmpLOloe9a/giphy.gif",
        "https://media1.giphy.com/media/oebOcslmnSXMQ/giphy.gif",
        "https://media0.giphy.com/media/11V6rs3BsLzVcs/giphy.gif",
        "https://media1.giphy.com/media/Hw1FAuSamUk3m/giphy.gif",
        "https://media3.giphy.com/media/btHtrzeHcveus/giphy.gif",
        "https://media3.giphy.com/media/ND6xkVPaj8tHO/giphy.gif",
        "https://media3.giphy.com/media/G3773sSDJHHy0/giphy.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_mcwz38gDyu1r1r78ao1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_mfuwxzD2EP1r1r78ao1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_n6sosh5kU01r1r78ao1_r1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nsvn6cFkFa1r1r78ao1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_mmpl60cYqH1r1r78ao1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nm1r5xOJeg1r1r78ao1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_o0ld9zV0rt1r1r78ao1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nnet7oE10b1r1r78ao1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_mxgrg0AYh41r1r78ao1_r1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_o0n5iituqy1r1r78ao1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nutip5I2jC1rxowjfo1_400.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nsee1mWDai1rxowjfo1_400.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nutip5I2jC1rxowjfo1_400.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nuyz8rESH81rxowjfo1_400.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nx4yzt1YXa1rxowjfo1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_o1yvlpQwjQ1rxowjfo1_400.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_nxn9lr3Duz1rxowjfo1_1280.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/4dfb0bd4de490ab7-tumblr_na1okz9P2Z1tqoxjko1_500.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/PageImage-508251-4264719-fightcloud500.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_inline_mr63c7Ijs01qz4rgp.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/PageImage-508251-4235169-HoT_GIF_final600.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_inline_mijozliWJA1qz4rgp.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/e2c9bfb056a969bb6a9dde38c881b5d8b7ceaaa7b952f-Gygpf4_fw658.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_inline_mr63c7Ijs01qz4rgp.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/tumblr_inline_mqzle9Gt9r1qz4rgp.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/006-sofiahydman-pulpfiction-2016.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/1%EF%BC%8D1.gif",
        "http://speedup.voicer.me/wp-content/uploads/2016/03/2%EF%BC%8D2.gif"
        ]
    }
  
}
