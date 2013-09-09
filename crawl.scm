#!/usr/bin/env chicken-scheme

;; [[file:~/prg/org/hadoop-images/TODO.org::*Get%20some%20images][Get-some-images:1]]

(use debug
     http-client
     html-parser
     sxpath
     sxpath-lolevel
     sxml-transforms
     uri-common)

(require-library aima-csp)
(import (only aima-csp shuffle))

(let ((images (make-hash-table))
      (horizon (alist->hash-table
                '(("http://www.apple.com" . #f))))
      (explored (make-hash-table)))
  (let iter ((time 0))
    (debug time)
    (if (or (zero? (hash-table-size horizon))
            (> time 10))
        (debug (hash-table-keys images))
        (let* ((url (car (shuffle (hash-table-keys horizon))))
               (document (with-input-from-request
                          url
                          #f
                          html->sxml)))
          (debug url)
          (let ((links (make-hash-table)))
            (pre-post-order
             document
             `((*default* . ,(lambda node node))
               (img . ,(lambda node (hash-table-set! images (sxml:text (sxml:attr node 'src)) #f)))
               (a . ,(lambda node (hash-table-set! links (sxml:text (sxml:attr node 'href)) #f)))))
            (hash-table-walk links
              (lambda (url _)
                (when (and (absolute-uri? (uri-reference url))
                           (hash-table-ref/default explored url #t))
                  (hash-table-set! horizon url #f))))
            (hash-table-delete! horizon url)
            (hash-table-set! explored url #f)
            (iter (add1 time)))))))

;; Get-some-images:1 ends here
