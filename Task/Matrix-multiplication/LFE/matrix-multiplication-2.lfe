(defun matrix*-lc (m1 m2)
  (let ((m2T (transpose m2)))
    (list-comp
        ((<- row  m1))
      (list-comp
          ((<- col m2T))
        (dot-product row col)))))
