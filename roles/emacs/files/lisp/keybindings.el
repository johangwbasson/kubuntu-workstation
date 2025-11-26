;; Enable CUA mode (standard cut/copy/paste)
(cua-mode t)
(setq cua-enable-cua-keys t)

;; Ctrl+S to save buffer
(global-set-key (kbd "C-s") 'save-buffer)

;; Ctrl+F: project-aware file open
(defun my/find-file ()
  "Open a file using Projectile if in a project, else regular find-file."
  (interactive)
  (if (projectile-project-p)
      (projectile-find-file)
    (call-interactively 'find-file)))
(global-set-key (kbd "C-f") 'my/find-file)

;; Other example keybindings
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)
(global-set-key (kbd "C-c g") 'magit-status)

(provide 'keybindings)
