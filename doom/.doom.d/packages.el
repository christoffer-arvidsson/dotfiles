;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! ix)                                                       ; Pastebin alternative
(package! yaml-mode)                                                ; Yaml my way downtown
(package! keychain-environment)                                     ; Manage ssh and gpg keys

(unpin! org-roam company-org-roam)

;; Writing stuff
(when (package! org)
  (package! org-appear
    :recipe (:host github
             :repo "awth13/org-appear"))                            ; Make ** appear on bolded words on hover
  (package! org-auto-tangle)
  (package! org-drill)                                              ; Anki for org mode (flashcards)
  (package! org-fragtog)                                            ; Automate inline latex rendering
  (package! org-alert)                                              ; System notifications for agenda
  (package! org-super-agenda)

  (when (package! org-roam)
    (package! org-roam-server)
    (package! org-roam-bibtex
      :recipe (:host github :repo "org-roam/org-roam-bibtex")))

  (package! org-ref))                                               ; Helps with references

(package! academic-phrases)                                         ; Scientific lingo for reports
(package! ivy-bibtex)

(unpin! jupyter) ; Fix jupyter in gccemacs

;; MAIL
(package! mu4e-alert) ; Desktop and emacs notifications when there is new mail

;; (package! evil-colemak
;;   :recipe (:local-repo "~/.dotfiles/doom/.doom.d/packages/evil-colemak/"))
