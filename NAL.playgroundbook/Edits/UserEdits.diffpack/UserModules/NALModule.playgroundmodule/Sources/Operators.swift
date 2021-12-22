
postfix operator -?
extension Statement {
    public static postfix func -?(_ s: Statement) -> Sentence {
        Sentence(s-?)
    }
    public static postfix func -?(_ s: Statement) -> Question {
        Question(s)
    }
}

postfix operator -*
extension Statement {
    public static postfix func -*(_ s: Statement) -> Sentence {
        s -* (1, 0.9)
    }
}

//postfix operator -!
//extension Statement {
//    public static postfix func -!(_ s: Statement) -> Sentence {
//        Sentence.question(Question(s)) // TODO: goal
//    }
//}
