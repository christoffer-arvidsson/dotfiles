;;; ~/.doom.d/+org.el -*- lexical-binding: t; -*-
;;;
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Projects/org/")

;, Org drill ~ Anki flashcards for org mode
(use-package org-drill
  :after org)

(after! org
  (setq org-hide-emphasis-markers t)
  ;; Fix org export bibliography
  (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f")))
  (setq org-latex-prefer-user-labels t)

(after! spell
  ; Make spellcheck faster
  (remove-hook 'mu4e-compose-mode-hook #'org-mu4e-compose-org-mode)
  (setq enable-flyspell-auto-completion t)
  )
