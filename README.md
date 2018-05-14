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
(let ((asm  #+arm64 '(#xc0 #x03 #x5f #xd6) ;; ret
            #+x86-64   '(#x89 #xF8            ;; mov edi, eax
                      #xc3)                ;; ret
            ))
  (when asm
    (let ((p (asm-alloc asm)))
      (unwind-protect
           (asm-call p :int 300 :int)
        (asm-free p)))))
```
