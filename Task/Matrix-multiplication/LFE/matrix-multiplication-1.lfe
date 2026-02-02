(defun matrix*-map (m1 m2)
  (let ((m2T (transpose m2)))
    (lists:map
     (lambda (row)
       (lists:map (lambda (col) (dot-product row col))
                  m2T))
     m1)))
