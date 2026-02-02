def fizz_buzz_plus (factorwords, limit)
  factorwords = factorwords.sort_by { |f, w| f }
  (1..limit).each do |n|
    shout = ""
    factorwords.each do |factor, word|
      shout += word if n % factor == 0
    end
    puts (shout == "" ? n : shout)
  end
end

fizz_buzz_plus [{3, "Fizz"}, {5, "Buzz"}, {7, "Baxx"}], 20
