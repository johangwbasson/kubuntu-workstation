;;; -*- lexical-binding: t -*-

;; Add "lisp" folder to load path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))


(require 'packages)      ;; package manager & packages
(require 'keybindings)   ;; your custom keys
(require 'ui)            ;; theme, fonts, UI tweaks
(require 'programming)   ;; general programming config
(require 'ocaml)          ;; OCaml-specific
