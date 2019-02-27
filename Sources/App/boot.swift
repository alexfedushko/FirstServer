import Vapor



func foo(on container: Container) {
    let future = container.withPooledConnection(to: .sqlite) { (conn) -> EventLoopFuture<Todo> in
        let a = try Todo.query(on: conn).filter(\.id, ._greaterThanOrEqual, 5).all().do({ todo in
            for obj in todo {
                obj.delete(on: conn)
            }
        })
        return  Todo.query(on: conn).first().unwrap(or: Abort(.badRequest))
    }
//    future.do{ msg in
//        print(msg)
//        }.catch{ error in
//            print("\(error.localizedDescription)")
//    }
}

public func boot(_ app: Application) throws {
    func runRepeatTimer() {
        app.eventLoop.scheduleTask(in: TimeAmount.seconds(10), runRepeatTimer)
        foo(on: app)
    }
    runRepeatTimer()
}
