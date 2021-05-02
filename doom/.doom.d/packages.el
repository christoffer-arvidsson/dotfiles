;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! ix)                                                       ; Pastebin alternative
(package! yaml-mode)                                                ; Yaml my way downtown
(package! keychain-environment)                                     ; Manage ssh and gpg keys

;; Writing stuff
(when (package! org)
  (package! org-appear
    :recipe (:host github
             :repo "awth13/org-appear"))                            ; Make ** appear on bolded words on hover
  (package! org-auto-tangle)
  (package! org-drill)                                              ; Anki for org mode (flashcards)
  (package! org-fragtog)                                            ; Automate inline latex rendering
  (package! org-ref))                                               ; Helps with references

(package! academic-phrases)                                         ; Scientific lingo for reports

(unpin! org-roam company-org-roam)
(when (package! org-roam)
  (package! org-roam-server)
  (package! org-roam-bibtex
    :recipe (:host github :repo "org-roam/org-roam-bibtex")))

;; UI
(package! zoom) ; Replacement for golden-ratio.el

