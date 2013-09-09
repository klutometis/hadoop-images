#!/usr/bin/env chicken-scheme

;; [[file:~/prg/org/hadoop-images/TODO.org::*Streaming][Streaming:3]]

(use debug
     matchable
     srfi-13
     srfi-69
     srfi-95)

(let ((aggregate (make-hash-table))
      (sums (make-hash-table))
      (initial-time (make-hash-table))
      (total 0))
  (let iter ((line (read-line)))
    (unless (eof-object? line)
      (match (string-split line)
        ((time index bytes)
         (let ((bytes (string->number bytes)))
           (set! total (+ total bytes))
           (hash-table-set!
            aggregate
            (cons time index)
            (if (hash-table-exists? aggregate (cons time index))
                (+ (hash-table-ref aggregate (cons time index)) bytes)
                bytes)))))
      (iter (read-line)))) 
  (for-each
      (lambda (time-index)
        (match time-index
          ((time . index)
           (let ((value (hash-table-ref aggregate time-index)))
             (hash-table-set!
              sums
              index
              (let ((pre-value (hash-table-ref/default sums index 0)))
                (+ pre-value value)))
             (unless (hash-table-exists? initial-time index)
               (hash-table-set! initial-time index time))
             (let ((sum (hash-table-ref sums index)))
               (format #t "~a ~a ~a~%" (- (string->number time)
                                          (string->number (hash-table-ref initial-time index)))
                       index
                       sum))))))
    (sort (hash-table-keys aggregate) string<? car)))

;; Streaming:3 ends here
