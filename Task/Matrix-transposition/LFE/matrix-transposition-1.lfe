(defun transpose
  ((`(() . ,_))
   '())
  ((matrix)
   (cons (lists:map #'car/1 matrix)
         (transpose (lists:map #'cdr/1 matrix)))))
