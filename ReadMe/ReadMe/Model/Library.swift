import UIKit

// MARK:- Reusable SFSymbol Images
enum LibrarySymbol {
  case bookmark
  case bookmarkFill
  case book
  case letterSquare(letter: Character?)
  
    
    
  var image: UIImage {
    let imageName: String
    switch self {
    case .bookmark, .book:
      imageName = "\(self)"
    case .bookmarkFill:
      imageName = "bookmark.fill"
    case .letterSquare(let letter):
      guard let letter = letter?.lowercased(),
      let image = UIImage(systemName: "\(letter).square")
        else {
          imageName = "square"
          break
      }
      return image
    }
    return UIImage(systemName: imageName)!
  }
}

// MARK:- Library
enum Library {
  private static let startData: [Book] = [
    Book(title: "Ein Neues Land", author: "Shaun Tan", readMe:  true),
    Book(title: "Bosch", author: "Laurinda Dixon", readMe: true),
    Book(title: "Dare to Lead", author: "Brené Brown", readMe: true),
    Book(title: "Blasting for Optimum Health Recipe Book", author: "NutriBullet", readMe: true),
    Book(title: "Drinking with the Saints", author: "Michael P. Foley", readMe: true),
    Book(title: "A Guide to Tea", author: "Adagio Teas", readMe: true),
    Book(title: "The Life and Complete Work of Francisco Goya", author: "P. Gassier & J Wilson", readMe: true),
    Book(title: "Lady Cottington's Pressed Fairy Book", author: "Lady Cottington", readMe: false),
    Book(title: "How to Draw Cats", author: "Janet Rancan", readMe: true),
    Book(title: "Drawing People", author: "Barbara Bradley", readMe: true),
    Book(title: "What to Say When You Talk to Yourself", author: "Shad Helmstetter", readMe: true)
  ]
    
    static var books: [Book] = loadBooks()
    
    private static let booksJSONURL = URL(fileURLWithPath: "Books", relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("json")
    
    private static func loadBooks() -> [Book] {
         let decoder = JSONDecoder()
        
        guard let bookData = try? Data(contentsOf: booksJSONURL) else {
            return startData
        }
        
        do{
            let books = try decoder.decode([Book].self, from: bookData)
            return books.map { libraryBook in
                Book( title: libraryBook.title,
                      author: libraryBook.author,
                      readMe: libraryBook.readMe,
                      review: libraryBook.review,
                      image:  loadImage(forBook: libraryBook)
                )
            }
        } catch let error {
            print(error)
            return startData
        }
    }
    
    private static func saveAllBook() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let bookData = try encoder.encode(books)
            try bookData.write(to: booksJSONURL, options: .atomicWrite)
        }catch let error {
            print(error)
        }
    }
    
   /// Add a New book to the `books` array and save it to disk.
    /// - Parameters:
    ///     - book: The book to be added to he library.
    ///     - image :  An option image to associate with the book.
    
    static func addNew(book: Book) {
        if let image = book.image {saveImage(image, forBook: book)}
        books.insert(book, at: 0)
        saveAllBook()
    }
    
    /// Update the stored value for a single book.
    /// - parameter book: The book to be update
    
    static func update (book: Book){
        if let newImage = book.image {
            saveImage(newImage, forBook: book)
            guard let bookIndex = books.firstIndex(where: {storedBook in book.title == storedBook.title})
            else {
                print("No book to update")
                return
            }
        books[bookIndex] = book
        saveAllBook()
        }
    }

    /// Remove a b ook from the `books ` array.
    /// - Parameter book: The book to be deleted from tthe library.
    static func delete (book: Book) {
        guard let bookIndex = books.firstIndex(where: { storedBook in book == storedBook })
        else { return }
        
        books.remove(at: bookIndex)
        
        let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
        do {
            try FileManager().removeItem(at: imageURL)
            
        } catch let error {print (error)}
        
        saveAllBook()
    }
    
    static func reorderBooks(bookToMove: Book, bookAtDestination: Book) {
        let destinationIndex = Library.books.firstIndex(of: bookAtDestination) ?? 0
        books.removeAll(where: {$0.title == bookToMove.title})
        books.insert(bookToMove, at: destinationIndex)
        saveAllBook()
    }

    /// Save an image associated with a gien book file
    
  static func saveImage(_ image: UIImage, forBook book: Book) {
      let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
      if let jpgData = image.jpegData(compressionQuality: 0.7) {
        try? jpgData.write(to: imageURL, options: .atomicWrite)
      }
    }
    
    static func loadImage(forBook book: Book) -> UIImage? {
      let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
      return UIImage(contentsOfFile: imageURL.path)
    }
  }


  extension FileManager {
    static var documentDirectoryURL: URL {
      return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
  }

