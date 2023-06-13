(defun rs-ff (r s q not-q)
  (nor-gate r not-q q)
  (nor-gate q s not-q)
  'ok)

(defun rs-clk-ff (r s clk q not-q)
  (let ((s0 (make-xsignal))
        (s1 (make-xsignal)))
    (and-gate r clk s0)
    (and-gate clk s s1)

    (nor-gate s0 not-q q)
    (nor-gate s1 q not-q)
  'ok))

(defun latch (d st q not-q)
  (let ((s0 (make-xsignal))
        (s1 (make-xsignal)))
    (nand-gate d st s0)
    (nand-gate s0 st s1)

    (nand-gate s0 not-q q)
    (nand-gate s1 q not-q)
  'ok))
