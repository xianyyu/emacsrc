
;; theme emacs
(set-foreground-color "burlywood3")
(set-background-color "#161616")
(set-cursor-color "#40FF40")

(global-hl-line-mode 1)
(set-face-background 'hl-line "midnight blue")

;; Bright-red TODOs
(setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-note-face)
(mapc (lambda (mode)
	(font-lock-add-keywords
	 mode
	 '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
	   ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
      fixme-modes)
(modify-face 'font-lock-fixme-face "red4" nil nil t nil t nil nil)
(modify-face 'font-lock-note-face "Dark Green" nil nil t nil t nil nil)

(set-face-attribute 'font-lock-builtin-face nil :foreground "#DAB98F")
(set-face-attribute 'font-lock-comment-face nil :foreground "gray50")
(set-face-attribute 'font-lock-constant-face nil :foreground "olive drab")
(set-face-attribute 'font-lock-doc-face nil :foreground "gray50")
(set-face-attribute 'font-lock-function-name-face nil :foreground "burlywood3")
(set-face-attribute 'font-lock-keyword-face nil :foreground "DarkGoldenrod3")
(set-face-attribute 'font-lock-string-face nil :foreground "OliveDrab4")
(set-face-attribute 'font-lock-type-face nil :foreground "burlywood3")
;;(set-face-attribute 'font-lock-variable-name-face nil :foreground "cornflower blue")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "light goldenrod")
(set-face-attribute 'mode-line nil :background "grey50")
(set-face-attribute 'minibuffer-prompt nil :foreground "OliveDrab4")


(set-face-attribute 'region nil :background "red4")
;; better shell look
(setq ansi-color-names-vector
      ["black" "LemonChiffon3" "burlywood3" "yellow" "grey50" "DarkSlateGray3" "gray50" "AntiqueWhite1"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; automatically add complete pair (){}
(electric-pair-mode t)

;; moving current line up and down
(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

(global-set-key [S-C-up] 'move-text-up)
(global-set-key [S-C-down] 'move-text-down)


;; better copy and delete functions
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; better copy word and paste imple
(defun get-point (symbol &optional arg)
  "get the point"
  (funcall symbol arg)
  (point))

(defun copy-thing (begin-of-thing end-of-thing &optional arg)
  "Copy thing between beg & end into kill ring."
  (save-excursion
    (let ((beg (get-point begin-of-thing 1))
	  (end (get-point end-of-thing arg)))
      (copy-region-as-kill beg end))))

(defun paste-to-mark (&optional arg)
  "Paste things to mark, or to the prompt in shell-mode."
  (unless (eq arg 1)
    (if (string= "shell-mode" major-mode)
	(comint-next-prompt 25535)
      (goto-char (mark)))
    (yank)))

(defun copy-word (&optional arg)
  "Copy words at point into kill-ring"
  (interactive "P")
  (copy-thing 'backward-word 'forward-word arg)
  ;;(paste-to-mark arg)
  )


(defun copy-backward-word ()
  "copy word before point - rocky @ stackexchange"
  (interactive "")
  (save-excursion
    (let ((end (point))
	  (beg (get-point 'backward-word 1)))
      (copy-region-as-kill beg end))))



(defun copy-line (&optional arg)
  "Save current line into Kill-Ring without mark the line "
  (interactive "P")
  (copy-thing 'beginning-of-line 'end-of-line arg)
  ;;  (paste-to-mark arg)
  )



(defun beginning-of-string (&optional arg)
  (when (re-search-backward "[ \t]" (line-beginning-position) :noerror 1)
    (forward-char 1)))
(defun end-of-string (&optional arg)
  (when (re-search-forward "[ \t]" (line-end-position) :noerror arg)
    (backward-char 1)))

(defun thing-copy-string-to-mark(&optional arg)
  " Try to copy a string and paste it to the mark
     When used in shell-mode, it will paste string on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-string 'end-of-string arg)
  (paste-to-mark arg)
  )

(defun copy-paragraph (&optional arg)
  "Copy paragraphes at point"
  (interactive "P")
  (copy-thing 'backward-paragraph 'forward-paragraph arg)
  ;;(paste-to-mark arg)
  )

(defun beginning-of-parenthesis (&optional arg)
  (when (re-search-backward "[[<(?\"]" (line-beginning-position) :noerror)
    (forward-char 1)))
(defun end-of-parenthesis (&optional arg)
  (when (re-search-forward "[]>)?\"]" (line-end-position) :noerror arg)
    (backward-char 1)))

(defun thing-copy-parenthesis-to-mark (&optional arg)
  " Try to copy a parenthesis and paste it to the mark
     When used in shell-mode, it will paste parenthesis on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-parenthesis 'end-of-parenthesis arg)
  (paste-to-mark arg)
  )
;;(global-set-key (kbd "C-c a")         (quote thing-copy-parenthesis-to-mark))
;;(global-set-key (kbd "C-c p") 'copy-paragraph)

(global-set-key (kbd "C-c w") 'copy-word)
(global-set-key (kbd "C-c W") 'copy-backward-word)
(global-set-key (kbd "C-c l") 'copy-line)
;;(global-set-key (kbd "C-c s")         (quote thing-copy-string-to-mark))


;; replacing backward delete word
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(global-set-key (kbd "C-M-<backspace>") 'backward-kill-word)
(global-set-key (kbd "M-DEL") 'backward-delete-word)

;; hide ^M
(defun hidden-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (unless buffer-display-table
    (setq buffer-display-table (make-display-table)))
  (aset buffer-display-table ?\^M []))

;; remove ^M
(defun remove-dos-eol ()
  "Replace DOS eolns CR LF with Unix eolns CR"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))

(defun indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer()
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn
	  (indent-region (region-beginning) (region-end))
	  (message "Indent selected region."))
      (progn
	(indent-buffer)
	(message "Indent buffer.")))))
(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key [f1] 'open-my-init-file)
(global-set-key [f2] 'shell)
(global-set-key [f5] 'compile)
(global-set-key [f12] 'browse-url-of-file)
(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)
;;(global-set-key (kbd "C-M-\\") 'clang-format-buffer)
;;move line up down
(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (let ((column (current-column)))
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
        (forward-line)
        (when (or (< arg 0) (not (eobp)))
          (transpose-lines arg))
        (forward-line -1))
      (move-to-column column t)))))


;; ui settings
(setq frame-title-format "%b")
;;(setq initial-frame-alist (quote ((fullscreen . maximized))))
(setq inhibit-splash-screen t)
(setq global-font-lock-mode t)

(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(blink-cursor-mode 0)
(show-paren-mode t)
(column-number-mode t)

(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

(global-set-key (kbd "C-M-k") 'kill-buffer-and-window)


;;goto buffer's beginning and ending
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
;; don't backup files
(setq auto-save-mode nil)
(setq-default make-backup-files nil)
(setq make-backup-files nil)


;; setup for org-mode
(global-set-key (kbd "C-c a") 'org-agenda)


;; configuration for c/c++
;; auto complete powerful semantic
(require 'cedet)
(require 'semantic)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)
(require 'semantic/db)
(require 'semantic/decorate/include)
(require 'semantic/c nil 'noerror)
(require 'semantic/sb)

(semantic-mode 1)

;;enable semantic idle complete
;;(global-semantic-idle-completions-mode)
(setq semantic-complete-inline-analyzer-idle-displayor-class 'semantic-displayor-traditional)

;;enable semantic idle summary mode
(global-semantic-idle-summary-mode)

;;set the way of semantic search
(setq-mode-local c++-mode
		 semanticdb-find-default-throttle
		 '(file project local unloaded system recursive))

(setq-mode-local c-mode
		 semanticdb-find-default-throttle
		 '(file project local unloaded system recursive))

;;higlight fun
(global-semantic-highlight-func-mode)

;; complete menu

;;decoration mode
(global-semantic-decoration-mode)
(setq semantic-toggle-decoration-style 'semantic-tag-boundary)

(global-set-key (kbd "C-c C-SPC") 'semantic-ia-fast-jump)
(global-set-key (kbd "C-c SPC") 'semantic-complete-analyze-inline)

(semantic-add-system-include "/usr/include/" 'c++-mode)
(semantic-add-system-include "/usr/include/gtk-3.0" 'c++-mode)
(semantic-add-system-include "/usr/include/glib-2.0" 'c++-mode)
;;(semantic-add-system-include "/usr/include/GLFW/" 'c++-mode)
(semantic-add-system-include "~/cocos2d-x-4.0/cocos/" 'c++-mode)
(setq semantic-default-submodes
      '(global-semantic-idle-scheduler-mode
        global-semanticdb-minor-mode
        global-semantic-idle-summary-mode
        global-semantic-idle-completions-mode
        global-semantic-highlight-func-mode
        global-semantic-decoration-mode
        global-semantic-mru-bookmark-mode
	global-semantic-sticky-func-mode
	global-semantic-show-parser-state-mode 1
	global-semantic-idle-local-symbol-highlight-mode))
(setq semanticdb-default-save-directory "~/.emacs.d/.semanticdb/"
      semantic-complete-inline-analyzer-idle-displayor-class 'semantic-displayor-ghost)

(add-to-list 'semantic-inhibit-functions
	     (lambda () (not (member major-mode '(c-mode c++-mode)))))


;; imenu setup
(add-hook 'c-mode-hook 'imenu-add-menubar-index)
(defun try-to-add-imenu ()
  (condition-case nil (imenu-add-to-menubar "Imenu") (error nil)))
(add-hook 'font-lock-mode-hook 'try-to-add-imenu)



(global-auto-revert-mode 1)
(setq inhibit-compacting-font-caches t)
(delete-selection-mode t)
(setq visible-bell 0)
(setq ring-bell-function 'ignore)
(fset 'yes-or-no-p 'y-or-n-p)
(setq auto-image-file-mode t)
(put 'scroll-left 'disabled nil)
(put 'scroll-right 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)
(setq show-paren-style 'parenthesis)
(setq x-select-enable-clipboard t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(semantic-c-dependency-system-include-path
   (quote
    ("/usr/include" "/usr/include/gtk-3.0" "/usr/include/glib-2.0"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-directory ((t (:foreground "white smoke"))))
 '(font-lock-function-name-face ((t (:foreground "tomato4"))))
 '(font-lock-variable-name-face ((t (:foreground "light goldenrod"))))
 '(isearch ((t (:background "dark gray" :foreground "brown4"))))
 '(semantic-decoration-on-unknown-includes ((t (:background "red4"))))
 '(semantic-decoration-on-unparsed-includes ((t (:background "gray18"))))
 '(semantic-highlight-func-current-tag-face ((t (:background "gray18" :distant-foreground "orange"))))
 '(semantic-tag-boundary-face ((t (:box (:line-width 1 :color "gray18" :style released-button))))))
