;;; region-bindings-mode.el --- Enable custom bindings when mark is active.

;; Copyright (C) 2012  Fabián E. Gallina

;; Author: Fabián E. Gallina <fabian@anue.biz>
;; URL: https://github.com/fgallina/region-bindings-mode
;; Version: 0.1
;; Created: Oct 2012
;; Keywords: convenience

;; This file is NOT part of GNU Emacs.

;; region-bindings-mode is free software: you can redistribute it
;; and/or modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; region-bindings-mode is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied warranty
;; of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with region-bindings-mode.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Minor mode that enables the ability of having a custom keys for
;; working with regions.  This is a pretty good way to keep the global
;; bindings clean.

;;; Installation:

;; Add this to your .emacs:

;; (add-to-list 'load-path "/folder/containing/file")
;; (require 'region-bindings-mode)
;; (region-bindings-mode-enable)

;;; Usage:

;; Now that region-bindings-mode has been installed and initialized
;; all you need to do is to add keys to it, here's and example:

;; (define-key region-bindings-mode-map "g" 'keyboard-quit)

;; And as you would expect that will trigger a `keyboard-quit' when
;; pressing g, but this only happens when region is active.

;; You can have fine grained control on the situations where this mode
;; should not be enabled, the first is using the simple
;; `region-bindings-mode-disabled-modes' variable and the other is
;; using `region-bindings-mode-disable-predicates'.  This is just a
;; list of functions that receive no args and if any of them return
;; non-nil the mode is not enabled.

;; If you want to disable the mode completely, please use
;; `region-bindings-mode-disable'.

;;; Code:

(defgroup region-bindings-mode nil
  "Indenting and region-bindings-modeing text."
  :group 'region-bindings-mode)

(defvar region-bindings-mode-map
  (let ((region-bindings-mode-map (make-sparse-keymap)))
    region-bindings-mode-map)
  "Keymaps for command `region-bindings-mode-map'.")

(defcustom region-bindings-mode-disable-predicates nil
  "List of predicates that disable the mode.
Each function in the list receive no argument."
  :group 'region-bindings-mode)

(defcustom region-bindings-mode-disabled-modes nil
  "Modes where `region-bindings-mode' should not activate."
  :group 'region-bindings-mode
  :type '(repeat symbol))

(define-minor-mode region-bindings-mode
  "Enable special bindings when working with regions."
  :lighter " rk" :group 'convenience)

(defun region-bindings-mode-on ()
  "Turn on region bindings mode.
Don't use this, use `region-bindings-mode-enable'."
  (and (not (memq major-mode region-bindings-mode-disabled-modes))
       (not (catch 'disable
              (dolist (pred region-bindings-mode-disable-predicates)
                (and (funcall pred)
                     (throw 'disable t)))))
       (region-bindings-mode 1)))

(defun region-bindings-mode-off ()
  "Turn off region bindings mode.
Don't use this, use `region-bindings-mode-disable'."
  (region-bindings-mode -1))

(defun region-bindings-mode-enable ()
  "Add initialization hooks."
  (add-hook 'activate-mark-hook 'region-bindings-mode-on)
  (add-hook 'deactivate-mark-hook 'region-bindings-mode-off))

(defun region-bindings-mode-disable ()
  "Remove initialization hooks and turn off."
  (remove-hook 'activate-mark-hook 'region-bindings-mode-on)
  (remove-hook 'deactivate-mark-hook 'region-bindings-mode-off)
  (region-bindings-mode -1))

(provide 'region-bindings-mode)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; region-bindings-mode.el ends here
