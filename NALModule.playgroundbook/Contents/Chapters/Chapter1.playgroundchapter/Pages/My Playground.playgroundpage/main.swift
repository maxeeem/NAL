let bird: Word = "bird"
let animal: Word = "animal"
let robin: Word = "robin"

let kb = KnowledgeBase.instance
    /*
kb.insert(bird --> animal)
kb.insert(bird --> bird)

kb.insert(robin --> bird)

kb.insert(robin --> "red")
kb.insert("seagull" --> bird)

kb.insert("water" --> "liquid")


print("tautology:", eval(bird --> bird))

print("transitive:", eval(robin --> animal))

//  print("transitive:", eval("seagull" --> "red"))

//  print("\n", kb.vocabulary,"\n")

//  print("extension of `animal`:", kb.extension(animal))
//  print("intension of `water`:", kb.intension("water"))

kb.knowledge.removeAll()
 */
kb.insert(bird --> animal)
kb.insert(robin --> bird)

    // question answering
print(eval(bird --> animal))
print(eval(bird --> "mammal"))

    // substitution
kb.infer(bird --> "?")
kb.infer("?" --> animal)

