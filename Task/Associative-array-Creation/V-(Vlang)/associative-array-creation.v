fn main() {
    // make empty map
    mut my_map := map[string]int{}

    // set value
    my_map['foo'] = 3

    // getting values
    y1 := my_map['foo']
    println(y1)

    // remove keys
    my_map.delete('foo')
    println(my_map)

    // make map with values
    my_map = {
        'foo': 2
        'bar': 42
        'baz': -1
    }
    println(my_map)
}
