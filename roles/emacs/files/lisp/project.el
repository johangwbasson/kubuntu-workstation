;; Projectile + Treemacs

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode +1)
  (setq projectile-indexing-method 'native)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; Counsel integration
(use-package counsel-projectile
  :after (projectile counsel)
  :config
  (counsel-projectile-mode t))

;; Treemacs
(use-package treemacs
  :bind (:map global-map
              ("M-0" . treemacs-select-window)))

(use-package treemacs-projectile
  :after (treemacs projectile))

(provide 'project)
