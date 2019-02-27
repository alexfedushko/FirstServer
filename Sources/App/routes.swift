import Vapor
import Foundation

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("timer") { req in
        return "Hello, world!"
    }
    
    router.post("sent") { req in
        return "Hello"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", String.parameter, String.parameter, use: todoController.create)
    router.delete("todos", use: todoController.delete)

}
