fun sundayXmasYears () =
	let
		val startYear = 2008
		val endYear = 2121
		val years = List.tabulate (1+endYear-startYear, fn y => y + startYear)
		fun xmasDayOfWeek year = Date.weekDay (Date.date
			{ day=25, month=Date.Dec, year=year,
			  hour=0, minute=0, second=0, offset=NONE })
		val xmasSundays =
			List.filter (fn y => xmasDayOfWeek y = Date.Sun) years
	in
		app (fn y => print (concat [Int.toString y, "\n"])) xmasSundays
	end

val () = print (String.concatWith ", " (map Int.toString (sundayXmasYears ())))
