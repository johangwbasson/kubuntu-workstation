;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Use use-package via straight.el
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Load essential packages
(use-package doom-themes)
(use-package tuareg)
(use-package merlin)
(use-package dune)
(use-package projectile)
(use-package counsel-projectile)
(use-package treemacs)
(use-package treemacs-projectile)

(provide 'packages)
