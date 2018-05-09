# my practice on low layer.

execute hand assembled something on x86-64/linux sbcl.

# install

```
$ ros install snmsts/asm
```

# what?

```
(ql:quickload :asm)
(in-package :asm/src/allocate)
(let ((p (asm-alloc '(#x89 #xF8 ;; mov edi, eax
                      #xc3      ;; ret
                      ))))
  (unwind-protect
      (asm-call p :int 300 :int)
    (asm-free p)))
```
