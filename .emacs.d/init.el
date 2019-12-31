
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; better zenburn look
(defvar zenburn-override-colors-alist
  '(("zenburn-bg" . "#111111")))
(load-theme 'zenburn t)

;; better shell look
(setq ansi-color-names-vector
      ["black" "LemonChiffon3" "SeaGreen1" "yellow" "CadetBlue3" "DarkSlateGray3" "cyan" "AntiqueWhite1"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;; clang-format
(add-to-list 'load-path "~/.emacs.d/lisp/clang-format/")
(require 'clang-format)

;; neotree
(add-to-list 'load-path "~/.emacs.d/lisp/emacs-neotree/")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(add-to-list 'load-path "~/.emacs.d/lisp/projectile/")
(require 'projectile)
(projectile-mode t)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


(add-to-list 'load-path "~/.emacs.d/lisp/web-beautify/")
(require 'web-beautify) ;; Not necessary if using ELPA package
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'web-mode
  '(define-key web-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

;; (eval-after-load 'js2-mode
;;   '(add-hook 'js2-mode-hook
;;              (lambda ()
;;                (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

;; ;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
;; (eval-after-load 'js
;;   '(add-hook 'js-mode-hook
;;              (lambda ()
;;                (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

;; (eval-after-load 'json-mode
;;   '(add-hook 'json-mode-hook
;;              (lambda ()
;;                (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

;; (eval-after-load 'sgml-mode
;;   '(add-hook 'html-mode-hook
;;              (lambda ()
;;                (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))

;; (eval-after-load 'web-mode
;;   '(add-hook 'web-mode-hook
;;              (lambda ()
;;                (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))

;; (eval-after-load 'css-mode
;;   '(add-hook 'css-mode-hook
;;              (lambda ()
;;                (add-hook 'before-save-hook 'web-beautify-css-buffer t t))))

(add-to-list 'load-path
	     "~/.emacs.d/lisp/org-bullets/")
(require 'org-bullets)
(require 'org)
(with-eval-after-load 'org
  ;; Org 模式相关设定
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
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

(add-to-list 'load-path
	     "~/.emacs.d/lisp/cmake-mode/")
(require 'cmake-mode)

;; kill other buffers
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
;;(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)
(global-set-key (kbd "C-M-\\") 'clang-format-buffer)
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
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-filename-at-point 'guess)
;; ;;(setq ido-everywhere t)          
;; (ido-mode 1)
;; (setq ido-separator "\n")
;; (setq ido-ignore-buffers '("^ " "*Completions*" "*Shell Command Output*"
;; 			   "*Messages*" "Async Shell Command" "*scratch*"))
;; (setq ido-auto-merge-work-directories-length -1)
;;(add-to-list 'ido-ignore-files "*.o")
;; ;; use current pane for newly opened file
;; (setq ido-default-file-method 'selected-window)
;; ;; use current pane for newly switched buffer
;; (setq ido-default-buffer-method 'selected-window)

;; ui settings
(setq frame-title-format "%b")
;;(setq initial-frame-alist (quote ((fullscreen . maximized))))
(setq inhibit-splash-screen t)
;;(setq global-font-lock-mode t)

(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(blink-cursor-mode 0)
(show-paren-mode t)
(column-number-mode t)
(global-hl-line-mode t)
;;(toggle-hl-line-when-idle 1)
;;(global-hl-spotlight-mode t)

;;(display-time-mode t)
;;(setq display-time-24hr-format t)
;;(setq display-time-day-and-date t)

(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

(global-set-key (kbd "C-M-k") 'kill-buffer-and-window)

;; replace flipping page to paste
(global-set-key (kbd "C-v") 'yank)


;; c++-mode commenting function
;;(add-hook 'c++-mode-hook (lambda () (setq comment-start "/* "                                          comment-end   " */")))

;; ctags etags support
(setq path-to-ctags "/usr/local/bin/ctags") ;; <- your ctags path here
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name)))
  (message "Tags generated")
  )

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
