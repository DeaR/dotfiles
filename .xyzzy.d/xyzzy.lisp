;; -*- mode: lisp; package: user; encoding: shift_jis -*-

; @name        xyzzy.lisp
; @description xyzzy settings
; @namespace   http://kuonn.mydns.jp/
; @author      DeaR
; @timestamp   <2013-05-24 13:51:07 DeaR>

;-----------------------------------------------------------------------------
; abbrev
(require "abbrev")
(quietly-read-abbrev-file)


;-----------------------------------------------------------------------------
; auto-time-stamp
(require "auto-time-stamp")
(setf *time-stamp-start* (compile-regexp "\\(Last[ \t]*\\(Changed?\\|Updated?\\|Modified\\)[ \t]*:\\|@?time[- \t]*stamp[ \t]*:?\\)[ \t]*[<\"]" t))
(setf *time-stamp-end* (compile-regexp "[>\"]" t))
(setf *time-stamp-format* "%Y-%m-%d %H:%M:%S DeaR")


;-----------------------------------------------------------------------------
; auto-time-stamp-bottom
(require "auto-time-stamp-bottom")
(setf *time-stamp-alist* nil)


;-----------------------------------------------------------------------------
; ffap
(require "ffap")
(setf *ffap-path-alist*
      (list (append '(lisp-mode) *load-path*)
            (append '(lisp-interaction-mode) *load-path*)))


;-----------------------------------------------------------------------------
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

