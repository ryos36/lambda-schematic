
(defun half-addr (a b s c)
  (let ((d (make-xsignal))
        (e (make-xsignal)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter-gate c e)
    (and-gate d e s)
    'ok))

(defun full-addr (a b c-in sum c-out)
  (let ((s (make-xsignal))
        (c1 (make-xsignal))
        (c2 (make-xsignal)))
    (half-addr b c-in s c1)
    (half-addr a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))
