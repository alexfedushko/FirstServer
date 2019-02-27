import Vapor


/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    
    init() {
        
    }
    
    
    func deleteUsers() {
        
    }
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> /*Future<[Todo]>*/Future<CustomResponse> {
       let obj = CustomResponse()
       
let promise = req.eventLoop.newPromise(CustomResponse.self)
        let arr = Todo.query(on: req).all()
        
        obj.message = "All good"
        //obj.data = arr
        
        var tarr = [Todo]()
        var isDone = false
        _ = try arr.do({ todo in
            print("Done")
            obj.data = todo
            isDone = true
            promise.succeed(result: obj)
        })
        
        print("Done2")
        
        return promise.futureResult
        
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        let obj = try req.content.syncGet(Todo.self, at: "data")
//        var error =  Abort(.badRequest)
//        error.reason = "Bad number"
//        throw error

        guard let title = req.query[String.self, at: "title"] else {
            throw Abort(.badRequest)
        }
        
        guard let customID = req.query[Int.self, at: "id"] else {
            throw Abort(.badRequest)
        }

        let par = try req.parameters.next(String.self)
        let par2 = try req.parameters.next(String.self)
        
        let baseObj = obj.save(on: req)
        
        return baseObj
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<String> {
        guard let customID = req.query[Int.self, at: "id"] else {
            throw Abort(.badRequest)
        }
        
        return Todo.find(customID, on: req).flatMap({ todo -> Future<Void> in
            guard let temp = todo else {
                var error = Abort(.notFound)
                error.reason = "Object with id \(customID) not found"
                throw error
            }

            return temp.delete(on: req)
        }).transform(to: "Delete object with id \(customID) succes")
        
//        return isDelete ? "Delete object with id \(customID) succes" : "object not found"
//
//
//        return "buuuuu"
        //        syncConc.sync {
        //
        //        }
        
        //        obj.de
//        return try req.parameters.next(Todo.self).flatMap { todo in
//            return todo.delete(on: req)
//        }.transform(to: .ok)
    }
}
