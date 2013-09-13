#!/usr/bin/env chicken-scheme

;; [[file:~/prg/org/hadoop-images/TODO.org::*Get%20some%20images][Get-some-images:1]]

(use debug
     http-client
     html-parser
     posix
     sxpath
     sxpath-lolevel
     sxml-transforms
     syslog
     tcp
     uri-common)

(require-library aima-csp)
(import (only aima-csp shuffle))

(debug-priority prio/info)

(define (horizon-from-urls urls)
  (with-input-from-file urls horizon-from-input))

(define (horizon-from-input)
  (let ((horizon (make-hash-table)))
    (let iter ((url (read-line)))
      (unless (eof-object? url)
        (hash-table-set! horizon url #f)
        (iter (read-line))))
    horizon))

(define (absolute-url link url)
  (uri->string (uri-relative-to (uri-reference link) (uri-reference url))))

(let ((images (make-hash-table))
      (horizon (horizon-from-input))
      (explored (make-hash-table)))
  ;; (debug/syslog (hash-table->alist horizon))
  (let iter ((time 0))
    (debug/syslog time (hash-table-size images))
    (if (or (zero? (hash-table-size horizon))
            ;; (> time 10)
            (> (hash-table-size images) 100))
        ;; (debug/syslog (hash-table-keys images))
        (hash-table-walk images
          (lambda (image _)
            (format #t "~a\n" image)))
        (let ((url (car (shuffle (hash-table-keys horizon)))))
          (debug/syslog url)
          (handle-exceptions exn
            (begin
              (debug/syslog (condition->list exn))
              ;; (debug/syslog (get-condition-property exn 'exn 'message))
              (hash-table-delete! horizon url)
              (iter (add1 time)))
            (let ((document (parameterize ((tcp-connect-timeout 1000))
                              (with-input-from-request
                               url
                               #f
                               html->sxml))))
              ;; (debug/syslog document)
              (let ((links (make-hash-table)))
                (pre-post-order
                 document
                 `((*default* . ,(lambda node node))
                   (img . ,(lambda node (hash-table-set!
                                    images
                                    (absolute-url (sxml:text (sxml:attr node 'src)) url)
                                    #f)))
                   (a . ,(lambda node (hash-table-set!
                                  links
                                  (absolute-url (sxml:text (sxml:attr node 'href)) url)
                                  #f)))))
                (hash-table-walk links
                  (lambda (url _)
                    (when (hash-table-ref/default explored url #t)
                      (hash-table-set! horizon url #f))))
                (hash-table-delete! horizon url)
                (hash-table-set! explored url #f)
                (iter (add1 time)))))))))

;; Get-some-images:1 ends here
