// version 2.3.0

fun main() {
    val s = "alphaBETA"
    println(s.uppercase())
    println(s.lowercase())
    println(s.replaceFirstChar{ it.uppercase() })
    println(s.replaceFirstChar{ it.lowercase() })
}
