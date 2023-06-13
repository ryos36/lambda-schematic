(def-entity comp
            (generic (k 10))
            (port
              (a :in :type (std_logic_vector (- k 1) 0))
              (b :in :type (std_logic_vector (- k 1) 0))
              (y :out :type (std_logic)))
            (setf x (make-logic-vector (-k 1) 0))

            (body
              (process (a b)
                       (if (> a b)
                         (setf y 1)
                         (setf y 0)))))
