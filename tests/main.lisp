(defpackage :lambda-schematic/tests/main
  (:use :cl
        :lambda-schematic
        :rove)

  (:export
    #:my-test-one
    )
        )
(in-package :lambda-schematic/tests/main)

;----------------------------------------------------------------

(deftest test-all
  (testing "should (= 1 1) to be true"
    (ok (make-xsignal))
    (let ((x 3))
      (ok (= x x)))
    (ng (= 2 1))
    )
    )

(deftest test-one
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))

