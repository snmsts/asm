(uiop/package:define-package :asm/src/allocate (:nicknames) (:use :cl)
                             (:shadow) (:export :asm-free :asm-alloc :asm-call)
                             (:intern))
(in-package :asm/src/allocate)
;;;don't edit above
(cffi:defcfun "posix_memalign" :int
  (memptr :pointer)
  (alignment osicat-posix::size)
  (size osicat-posix::size))

(cffi:defcfun "mprotect" :int
  (addr :pointer)
  (len osicat-posix::size)
  (prot :int))

(cffi:defcfun ("free" asm-free) :void
  (ptr :pointer))

(defun asm-alloc (asm)
  (cffi:with-foreign-object (p :pointer)
    (let ((psize (osicat-posix:getpagesize)))
      (and (zerop (posix-memalign p psize psize))
           (zerop (mprotect (cffi:mem-aref p :pointer)
                            psize
                            (+ 1    ;; prot-read
                               2    ;; prot-write
                               4))) ;; prot-exec
           (let ((p2 (cffi:mem-aref p :pointer)))
             (loop for byte in asm
                for i from 0
                do (setf (cffi:mem-aref p2 :uchar i) byte))
             p2)))))

(defmacro asm-call (pointer &rest rest)
  `(cffi:foreign-funcall-pointer ,pointer () ,@rest))
