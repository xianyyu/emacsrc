
;;(load-theme 'adwaita t)


(require 'org)
(with-eval-after-load 'org
  ;; Org 模式相关设定
;;  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-src-fontify-natively t)
;; 设置默认 Org Agenda 文件目录
(setq org-agenda-files '("~/Documents/notes/"))
;; 设置 org-agenda 打开快捷键
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-startup-indented t)

(setq org-src-tab-acts-natively t)

(add-hook 'org-mode-hook 
	  (lambda () (setq truncate-lines nil)))

(org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
        (C . t)
        (java . t)
        (js . t)
        (ruby . t)
        (ditaa . t)
        (python . t)
        (shell . t)
        (latex . t)
        (plantuml . t)
        (R . t)))

)

;; hide ^M something like that
(defun hidden-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (unless buffer-display-table
    (setq buffer-display-table (make-display-table)))
  (aset buffer-display-table ?\^M []))


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

;; moving current line up and down
(global-set-key [S-C-up] 'move-text-up)
(global-set-key [S-C-down] 'move-text-down)

;; automatically add complete pair (){}
(electric-pair-mode t)

;; sacling fonts with mouse and contrl key
(global-set-key (kbd "<C-mouse-4>") 'text-scale-decrease)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-increase)

;; ido-mode setup
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-everywhere t)          
(ido-mode 1)
(setq ido-separator "\n")
(setq ido-ignore-buffers '("^ " "*Completions*" "*Shell Command Output*"
			   "*Messages*" "Async Shell Command" "*scratch*"))
(setq ido-auto-merge-work-directories-length -1)
;;(add-to-list 'ido-ignore-files "*.o")
;; ;; use current pane for newly opened file
;; (setq ido-default-file-method 'selected-window)
;; ;; use current pane for newly switched buffer
;; (setq ido-default-buffer-method 'selected-window)

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
(global-hl-line-mode t)

;;(display-time-mode t)
;;(setq display-time-24hr-format t)
;;(setq display-time-day-and-date t)

(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

(global-set-key (kbd "C-M-k") 'kill-buffer-and-window)

;; replace flipping page to paste
(global-set-key (kbd "C-v") 'yank)





;; auto complete powerful semantic
(require 'cedet)
(require 'semantic)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)
(require 'semantic/db)
(require 'semantic/decorate/include)
(require 'semantic/c nil 'noerror)
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
(semantic-add-system-include "/usr/include/GLFW/" 'c++-mode)
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


;;goto buffer's beginning and ending
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
;; don't backup files
(setq auto-save-mode nil)
(setq-default make-backup-files nil)
(setq make-backup-files nil)


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
