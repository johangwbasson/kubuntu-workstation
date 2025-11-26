;; Tuareg for OCaml
(use-package tuareg
  :mode ("\\.ml[iylp]?" . tuareg-mode))

;; Merlin for IDE-like features
(use-package merlin
  :hook (tuareg-mode . merlin-mode))

;; Dune integration
(use-package dune
  :hook (tuareg-mode . dune-mode))

