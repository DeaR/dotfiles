; Xyzzy settings
;
; Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
; Last Change:  13-Aug-201313-Aug-2013.
; License:      MIT License {{{
;     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
;
;     Permission is hereby granted, free of charge, to any person obtaining a
;     copy of this software and associated documentation files (the
;     "Software"), to deal in the Software without restriction, including
;     without limitation the rights to use, copy, modify, merge, publish,
;     distribute, sublicense, and/or sell copies of the Software, and to permit
;     persons to whom the Software is furnished to do so, subject to the
;     following conditions:
;
;     The above copyright notice and this permission notice shall be included
;     in all copies or substantial portions of the Software.
;
;     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
;     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
;     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
;     OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
;     THE USE OR OTHER DEALINGS IN THE SOFTWARE.
; }}}

;------------------------------------------------------------------------------
; abbrev
(require "abbrev")
(quietly-read-abbrev-file)


;------------------------------------------------------------------------------
; auto-time-stamp
(require "auto-time-stamp")
(setf *time-stamp-start* (compile-regexp "Last Change:[ \t]*" t))
(setf *time-stamp-end* (compile-regexp "\." t))
(setf *time-stamp-format* "%d-%b-%Y")


;------------------------------------------------------------------------------
; auto-time-stamp-bottom
(require "auto-time-stamp-bottom")
(setf *time-stamp-alist* nil)


;------------------------------------------------------------------------------
; ffap
(require "ffap")
(setf *ffap-path-alist*
      (list (append '(lisp-mode) *load-path*)
            (append '(lisp-interaction-mode) *load-path*)))


;------------------------------------------------------------------------------
; info
(require "info")
(setf *info-directory-list*
      (mapcan #'(lambda (dir)
                  (when (file-exist-p (merge-pathnames "dir" dir))
                    (list dir)))
              `(,(merge-pathnames "share/info" (user-homedir-pathname))
                ,(merge-pathnames "info" (user-homedir-pathname))
                ,(merge-pathnames "share/info" (si:system-root))
                ,(merge-pathnames "info" (si:system-root))
                "C:/cygwin/usr/local/share/info"
                "C:/cygwin/usr/local/info"
                "C:/cygwin/usr/share/info"
                "C:/cygwin/usr/info"
                "C:/emacs/info"
                "C:/msysgit/share/info"
                "C:/msysgit/msys/1.0/share/info"
                "C:/MinGW/share/info"
                "C:/MinGW/msys/1.0/share/info")))

