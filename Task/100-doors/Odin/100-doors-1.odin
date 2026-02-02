package doors

import "core:fmt"

main :: proc() {
	doors: [100]bool

	for every_n := 1; every_n < len(doors); every_n += 1 {
		i := every_n - 1
		for true {
			if i >= len(doors) do break

			doors[i] = !doors[i]

			i += every_n
		}
	}

	for &door, i in doors {
		if door do fmt.printf("%d ", i + 1)
	}
}
