(in-package :lambda-schematic)

(defvar *vcd-version* "lambda Schematic 0.0")
(defvar *day-names* '("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"))
(defvar *vcd-chars* "abcdefghijklmnopqrstuvwxyz")
(defparameter *vcd-chars-pos* 0)

(defstruct vcd (timescale '(1 :ns)) vars (stream t))

(defun vcd-show-header (vcd-obj)
  (let ((str (vcd-stream vcd-obj)))
    (format str "$date~%")
    (multiple-value-bind
        (second minute hour day month year day-of-week dst-p tz)
        (get-decoded-time)
      (format str "    ~a ~a ~a ~a:~a:~a (GMT~@d) ~a~%"
	    	 (nth day-of-week *day-names*)
	    	 month
	    	 day
	    	 hour
	    	 minute
	    	 second
	    	 (- tz)
	    	 year
         ))
    (format str "$end~%")
    (format str "$version~%")
    (format str "    ~a~%" *vcd-version*)
    (format str "$end~%")
    (format str "$timescale~%")
    (let* ((timescale (vcd-timescale vcd-obj))
           (timescale-num (car timescale))
           (timescale-unit (string-downcase (cadr timescale))))
      (format str "    ~a~a~%" timescale-num timescale-unit))
    (format str "$end~%")))


(defun vcd-probe (vcd-obj id-code xsig)
  (let ((_id-code id-code)
        (_vcd-obj vcd-obj))
     (add-action
       xsig
       (lambda (sig)
         (format (vcd-stream vcd-obj) "#~a~%~a~a~%" (get-current-time the-agenda) 
                 (get-xsignal sig) _id-code )))))

(defun get-id-code ()
  (let ((rv (char *vcd-chars* *vcd-chars-pos*)))
    (incf *vcd-chars-pos*)
    rv))

(defstruct vcd-var xsig type size id-code reference-name)
  
(defun vcd-add-vars (vcd-obj xsig var-type size id-code reference-name)
  (let* ((_id-code (or id-code (get-id-code)))
         ;(_reference-name (or reference-name (string-downcase (symbol-name xsig))))
         (var (make-vcd-var :xsig xsig :type var-type :size size :id-code _id-code :reference-name reference-name)))
    (vcd-probe vcd-obj _id-code xsig)
    (push var (vcd-vars vcd-obj))))

; 簡易的に TB のトップモジュールのみをサポート
; 階層化は将来的に
(defun vcd-show-module-tb (vcd-obj)
  (let ((str (vcd-stream vcd-obj))
        (vars (vcd-vars vcd-obj)))
    (format str "$scope module tb $end~%")
    (format str "$upscope $end~%")
    (dolist (var-obj vars)
      (format str "$var ~a ~a ~a ~a $end~%"
        (vcd-var-type var-obj)
        (vcd-var-size var-obj)
        (vcd-var-id-code var-obj)
        (vcd-var-reference-name var-obj)))
    (format str "$enddefinitions $end~%")))

(defun vcd-show-start-dumpvars (vcd-obj)
  (let ((str (vcd-stream vcd-obj)))
    (format str "$dumpvars~%")))
