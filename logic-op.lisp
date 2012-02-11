
(defun logic= (v0 v1)
  (cond ((not (and (numberp v0) (numberp v1))) nil)
	(t (= v0 v1))))

(defun logic-not  (value)
  (cond 
    ((not (numberp value)) value)
    ((= 0 value) 1)
    ((= 1 value) 0)
    (t value)))

(defun logic-and  (v0 v1)
  (cond 
    ((and (numberp v0) (= v0 0)) 0)
    ((and (numberp v1) (= v1 0)) 0)
    ((not (and (numberp v0) (numberp v1))) nil)
    ((and (= 1 v0) (= 1 v1)) 1)
    (t nil)))

(defun logic-nand  (v0 v1)
  (cond 
    ((and (numberp v0) (= v0 0)) 1)
    ((and (numberp v1) (= v1 0)) 1)
    ((not (and (numberp v0) (numberp v1))) nil)
    ((and (= 1 v0) (= 1 v1)) 0)
    (t nil)))

(defun logic-or  (v0 v1)
  (cond 
    ((and (numberp v0) (= v0 1)) 1)
    ((and (numberp v1) (= v1 1)) 1)
    ((not (and (numberp v0) (numberp v1))) nil)
    ((and (= 0 v0) (= 0 v1)) 0)
    (t nil)))

(defun logic-nor  (v0 v1)
  (cond 
    ((and (numberp v0) (= v0 1)) 0)
    ((and (numberp v1) (= v1 1)) 0)
    ((not (and (numberp v0) (numberp v1))) nil)
    ((and (= 0 v0) (= 0 v1)) 1)
    (t nil)))

(defun logic-xor  (v0 v1)
  (cond 
    ((not (and (numberp v0) (numberp v1))) nil)
    ((and (= 0 v0) (= 0 v1)) 0)
    ((and (= 1 v0) (= 0 v1)) 1)
    ((and (= 0 v0) (= 1 v1)) 1)
    ((and (= 1 v0) (= 1 v1)) 0)
    (t nil)))

