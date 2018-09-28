(setq frame-title-format "Currently Editing %b")
(setq initial-frame-alist (quote ((fullscreen . maximized))))
(setq inhibit-splash-screen t)
(setq global-font-lock-mode t)

(scroll-bar-mode 0)
(tool-bar-mode 0)
;(menu-bar-mode 0)

;;.emacs file keymap config
(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key [f1] 'open-my-init-file)
(global-set-key [f2] 'other-window)
(global-set-key [f5] 'shell)

;;eval buffer is save all of the changes of .emacs file
(global-set-key [f12] 'eval-buffer)

(setq initial-scratch-message "happy coding")
(global-set-key [escape] 'kill-buffer-and-window)

;;goto buffer's beginning and ending
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
;; don't backup files
(setq auto-save-mode nil)
(setq-default make-backup-files nil)
(setq make-backup-files nil)

;; turn up disabled function
; delete selection mode is delete your selected word and change it direct
(delete-selection-mode t)
(setq visible-bell t)
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
