; (current-time <segments>)
; segments <= (segment .... )
; segment <= (time queue) 
; queue <= (tlist-add-right q action))
; 

(defvar debug-flag nil)
(defvar *no-delay-mode* nil)
(defvar *direct-call-after-daly* nil)
;
(defun make-agenda ()
  (list 0))
;
(defvar the-agenda (make-agenda))
;

(defun segments (agenda)
  (cdr agenda))
(defun empty-agenda-p (agenda)
  (null (segments agenda)))

(defun first-segment (agenda)
  (car (segments agenda)))
(defun segment-time (seg)
  (car seg))
(defun segment-queue (seg)
  (cdr seg))
(defun set-current-time (agenda new-time)
  (setf (car agenda) new-time))

(defun get-current-time (agenda) (car agenda))

(defun set-segments (agenda seg)
  (setf (cdr agenda) seg))

(defun rest-segments (agenda)
  (cdr (segments agenda)))

(defun first-agenda-item (agenda)
  (if (empty-agenda-p agenda)
    (error "first-agenda-item")
    (let ((first-seg (first-segment agenda)))
      (set-current-time agenda (segment-time first-seg))
      (tlist-left (segment-queue first-seg)))))

(defun remove-first-agenda-item (agenda)
    (let ((q (segment-queue (first-segment agenda))))
      (tlist-rem-left q)
      (if (tlist-empty-p q)
	(set-segments agenda (rest-segments agenda)))))


(defun make-time-segment (time seg)
  (cons time seg))

(defun propagate (delta)
  (if (empty-agenda-p the-agenda)
    (progn 
      (set-current-time the-agenda (+ (get-current-time the-agenda) delta))
      'done)
    (let* ((cur-time (get-current-time the-agenda))
	   (diff-time (- (caadr the-agenda) cur-time)))
      (if (> diff-time delta)
	(set-current-time the-agenda (+ cur-time delta))
	(let ((action (first-agenda-item the-agenda)))
	  (funcall action)
	  (remove-first-agenda-item the-agenda)
	  (propagate (- delta diff-time)))))))

(defun add-to-agenda (delay-time action agenda)
  (let ((time (+ delay-time (get-current-time the-agenda))))
    (if debug-flag
      (format t "add-to-agenda delay ~a ~a~%" time action))
    (labels ((belong-before-p (segments)
			      (or (null segments)
				  (< time (segment-time (car segments)))))
	     (make-new-time-segments (time action)
				     (let ((q (make-tlist)))
				       (tlist-add-right q action)
				       (make-time-segment time q)))
	     (add-to-segments (segs)
			      (if (and (< 0 delay-time)
				       (= (segment-time (car segs)) time))
				(let ((q (segment-queue (car segs))))
				  (tlist-add-right q action))
				(let ((rest (cdr segs)))
				  (if (belong-before-p rest)
				    (setf (cdr segs)
					  (cons (make-new-time-segments time action) (cdr segs)))
				    (add-to-segments rest))))))
      (let ((segments (segments agenda)))
	(if (belong-before-p segments)
	  (set-segments agenda
			(cons (make-new-time-segments time action)
			      segments))
	  (add-to-segments segments))))))

(defun after-delay (delay-time proc)
  (if *direct-call-after-daly*
    (funcall proc)
    (progn
      (if *no-delay-mode*
	(setf delay-time 0))
      (add-to-agenda delay-time
		     proc
		     the-agenda))))
