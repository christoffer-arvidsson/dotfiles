;;; ~/.doom.d/+org.el -*- lexical-binding: t; -*-
;;;
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Projects/org/")

;; Org drill ~ Anki flashcards for org mode
(use-package! org-drill
  :after org)

(after! elfeed-org
  (elfeed-org)
  (add-hook! 'elfeed-search-mode-hook 'elfeed-update)
  (setq rmh-elfeed-org-files (list "~/Projects/org/elfeed/elfeed.org"))
  )

(after! org
  ;; Make ** into BOLD
  (setq org-hide-emphasis-markers t)

  ;; Fix org export bibliography
  ;; (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f")i)
  (setq org-latex-prefer-user-labels t)

  ;; Change screenshot backend of org-download (it now uses scrot!)
  (setq org-download-screenshot-method "xfce4-screenshooter -r -o cat > %s")
  ;; (setq org-download-method `directory)

  ;; Make agenda always show +7 days forward
  (setq org-agenda-start-on-weekday nil)
  (setq ob-mermaid-cli-path "/usr/bin/mmdc")

  ;; Show habit tracker!
  (setq org-habit-show-habits t))

(after! spell
  (remove-hook 'mu4e-compose-mode-hook #'org-mu4e-compose-org-mode()
               (setq enable-flyspell-auto-completion t)
               ))

  ;; SOURCE: from https://github.com/zaen323
  (after! org-super-agenda
    (setq org-agenda-time-grid '((daily today require-timed) "----------------------" nil))
    (setq org-agenda-skip-scheduled-if-done t)
    (setq org-agenda-skip-deadline-if-done t)
    (setq org-agenda-include-deadlines t)
    (setq org-agenda-include-diary t)
    (setq org-agenda-block-separator nil)
    (setq org-agenda-compact-blocks nil)
    (setq org-agenda-start-with-log-mode t)
    (setq org-agenda-custom-commands
          '(("z" "Super agenda!"
             ((agenda "" ((org-agenda-span 'day)
                          (org-super-agenda-groups
                           '((:name "Today"
                              :time-grid t
                              :date today
                              :todo "TODAY"
                              :scheduled today
                              :order 1)))))
              (alltodo "" ((org-agenda-overriding-header "")
                           (org-super-agenda-groups
                            '((:name "Next to do"
                               :todo "NEXT"
                               :order 1)
                              (:name "Important"
                               :tag "Important"
                               :priority "A"
                               :order 6)
                              (:name "Due Today"
                               :deadline today
                               :order 2)
                              (:name "Due Soon"
                               :deadline future
                               :order 8)
                              (:name "Overdue"
                               :deadline past
                               :order 7)
                              (:name "Assignments"
                               :tag "Assignment"
                               :order 10)
                              (:name "Issues"
                               :tag "Issue"
                               :order 12)
                              (:name "Projects"
                               :tag "Project"
                               :order 14)
                              (:name "Emacs"
                               :tag "Emacs"
                               :order 13)
                              (:name "Research"
                               :tag "Research"
                               :order 15)
                              (:name "To read"
                               :tag "Read"
                               :order 30)
                              (:name "Exercises"
                               :tag "Exercise"
                               :order 31)
                              (:name "Waiting"
                               :todo "WAITING"
                               :order 20)
                              (:name "trivial"
                               :priority<= "C"
                               :tag ("Trivial" "Unimportant")
                               :todo ("SOMEDAY" )
                               :order 90)
                              (:discard (:tag ("Chore" "Routine" "Daily")))))))))))
    )

  (defun my-open-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:org-create-source "Green")  ; orgmode source
      ;; (cfw:ical-create-source "Moon" "/home/eethern/Projects/course/master/mphpc1.ics" "Gray")  ; ICS source1
      (cfw:ical-create-source "gcal" "https://cloud.timeedit.net/chalmers_test/web/public/ri6Xn0gQ5560YZQQ55Z6973Y00y80074Q5Y64Q587v530Z62.ics" "IndianRed")
      )))
