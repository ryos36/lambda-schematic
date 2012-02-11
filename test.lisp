(load "lol.lisp")
(setf (symbol-function 'lel)
      (let ((count 0))
	(dlambda 
		 (:inv (&optional (f t))
		       (if f (decf count) (incf count)))
		 (t () (incf count)))))

