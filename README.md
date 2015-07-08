
##Nolan

Nolan is a library that converts __swift 2__ values into JSON format. It can convert any type (except functions and tuples) to JSON object. It uses protocol extensions, error handling that is only available in swift version 2.

###Requirements
* Swift 2
* Xcode 7

###Installation

Nolan supports [Carthage](https://github.com/Carthage/Carthage).  Add `github "mstfy/Nolan"` line into your Cartfile and run `carthage install` command on terminal.

###How to use
By default Nolan can convert `String`, `NSDate`, `Float`, `Double`, `Int`, `NSURL` and `Optional` types to json. To adopt it for your custom type just conform your type to `JSONConvertible` protocol and it is done (hopefully). Here is an example type:

    struct User: JSONConvertible {
        let name: String
        let age: Int
    }

Now to convert it to JSON just call `toJSON()` method that is declared in `JSONConvertible` protocol.

    let user = User(name: "Nolan", age: 25)
    try {
        let userJSON = try user.toJSON()
        print("user converted to \(userJSON)")
    } catch let JSONConversionError.TypeIsNotConvertibleToJSON(type) {
        print("Error: \(type) is not convertible to JSON")
    }

Here is more complicated example:

    struct User: JSONConvertible {
        let name: String
        let books: [Book]
    }

	struct Book: JSONConvertible {
	    let name: String
	    let author: String
	    let publisher: String?
	}

	let books = [Book(name: "The Lord Of the Rings", author: "J.R.R. Tolkien", publisher: "George Allen"), Book(name: "When Nietzsche Wept", author: "Irvin D. Yalom", publisher: nil)]
	let user = User(name: "Cooper", books: books)
	
	do {
		let userJson = try user.toJSON()
		print("user json is \(userJson)")
	} catch let JSONConversionError.TypeIsNotConvertibleToJSON(type) {
        print("Error: \(type) is not convertible to JSON")
    } catch let error as NSError {
        print("unknown error \(error.localizedDescription)")
    }

It prints:

    user json is {
        books =     (
                    {
                author = "J.R.R. Tolkien";
                name = "The Lord Of the Rings";
                publisher = "George Allen";
            },
                    {
                author = "Irvin D. Yalom";
                name = "When Nietzsche Wept";
                publisher = "<null>";
            }
        );
        name = Cooper;
    }

By default `toJSON` method produces key value pairs of the value using reflection api in Swift. But you can override this behavior in your custom type. For example: 

    struct User: JSONConvertible {
    	let name: String
    	let role: Role
    }
    
    enum Role: JSONConvertible {
    	case Pilot
    	case Captain
    	
    	func toJSON() throws -> JSON {
    	    switch self {
    	    case .Pilot: return "pilot"
    	    case .Captain: return "captain"
    	    }
    	}
    }

	let user = User(name: "Cooper", role: .Captain)
	do {
	    let userJSON = try user.toJSON()
	    print("user json = \(userJSON)")
	} catch let JSONConversionError.TypeIsNotConvertibleToJSON(type) {
        print("Error: \(type) is not convertible to JSON")
    } catch let error as NSError {
        print("unknown error \(error.localizedDescription)")
    }

It prints:

    user json = {
        name = Cooper;
        role = captain;
    }
