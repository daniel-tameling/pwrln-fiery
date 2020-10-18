;; pwrln-fiery.el --- Small powerline theme for emacs
;; Copyright (C) 2020 Daniel Tameling
;; 
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of the
;; License, or (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110,
;; USA

(defun pwrln-left-separator (lface rface)
  "left separator"
  (propertize (char-to-string #xe0b0) 'face
              (list :foreground (face-attribute lface :background)
                    :background (face-attribute rface :background))))

(defface pwrln-fiery-buffer-prop-selected
  '((t (:background "#bd0026" :foreground "#e0e0e0" :inherit mode-line)))
  "color of buffer properties when window selected")

(defface pwrln-fiery-buffer-prop-unselected 
  '((t (:background "#000000" :foreground "#cccccc" :inherit mode-line-inactive)))
  "color of buffer properties when window not selected")

(defface pwrln-fiery-buffer-name-selected 
  '((t (:background "#ff8800" :foreground "#111111" :inherit mode-line)))
  "color of buffer name when window selected")

(defface pwrln-fiery-buffer-name-unselected 
  '((t (:background "#444444" :foreground "#dddddd" :inherit mode-line-inactive)))
  "color of buffer name when window not selected")

(defface pwrln-fiery-pos-info-selected 
'((t (:background "#ffaf00" :foreground "grey17" :inherit mode-line)))
  "color of buffer pos when window selected")

(defface pwrln-fiery-pos-info-unselected 
  '((t (:background "#777777" :foreground "#dddddd" :inherit mode-line-inactive)))
  "color of buffer pos when window not selected")

(defface pwrln-fiery-active-modes-selected 
  '((t (:background "#fecc5c" :foreground "#222222" :inherit mode-line)))
  "color of major and minor modes and mode-line-process when window selected")

(defface pwrln-fiery-active-modes-unselected 
  '((t (:background "#aaaaaa" :foreground "#111111" :inherit mode-line-inactive)))
  "color of major and minor modes and mode-line-process when window not selected")

(defface pwrln-fiery-dashes-selected 
  '((t (:background "#ffffb2" :foreground "#cccccc" :inherit mode-line)))
  "color of the dashes when window selected")

(defface pwrln-fiery-dashes-unselected 
  '((t (:background "#dddddd" :foreground "#aaaaaa" :inherit mode-line-inactive)))
  "color of dashes when window selected")


;; https://emacs.stackexchange.com/questions/26222/show-something-in-active-mode-line-instead-of-all-mode-lines
(defvar ml-selected-window nil)

(defun ml-record-selected-window ()
    (setq ml-selected-window (selected-window)))

(defun ml-update-all ()
    (force-mode-line-update t))

(add-hook 'post-command-hook 'ml-record-selected-window)
(add-hook 'buffer-list-update-hook 'ml-update-all)

(setq-default mode-line-format
              '("%e"
                (:eval (let* ((selected (eq ml-selected-window (selected-window)))
                              (face-buffer-props (if selected 'pwrln-fiery-buffer-prop-selected 'pwrln-fiery-buffer-prop-unselected))
                              (face-buffer-name (if selected 'pwrln-fiery-buffer-name-selected 'pwrln-fiery-buffer-name-unselected))
                              (face-pos-info (if selected 'pwrln-fiery-pos-info-selected 'pwrln-fiery-pos-info-unselected))
                              (face-active-modes (if selected 'pwrln-fiery-active-modes-selected 'pwrln-fiery-active-modes-unselected))
                              (face-dashes (if selected 'pwrln-fiery-dashes-selected 'pwrln-fiery-dashes-unselected)))
                         
                         (list `(:propertize " " face ,face-buffer-props)
                               (when (buffer-modified-p)
                                 `(:propertize "! " face ,face-buffer-props))
                               (when buffer-read-only
                                 `(:propertize ,(concat (char-to-string #xe0a2) " ") face ,face-buffer-props))
                               (when current-input-method
                                 `(:propertize ,(concat current-input-method-title " ") face ,face-buffer-props))
                               `(:propertize "%Z" face ,face-buffer-props)
                               `(:propertize " " face ,face-buffer-props)
                               (pwrln-left-separator face-buffer-props face-buffer-name)
                               `(:propertize " %b " face ,face-buffer-name)
                               (pwrln-left-separator face-buffer-name face-pos-info)
                               `(:propertize (-4 " %p") face ,face-pos-info)
                               `(:propertize " " face ,face-pos-info)
                               `(:propertize "L%l" face ,face-pos-info)
                               (when column-number-mode
                                 `(:propertize " C%c" face ,face-pos-info))
                               `(:propertize " " face ,face-pos-info)
                               (pwrln-left-separator face-pos-info face-active-modes)
                               `(:propertize " " face ,face-active-modes)
                               `(:propertize ("" mode-name) face ,face-active-modes)
                               ;; `(:propertize ("" mode-line-process) face ,face-active-modes)
                               ;; expand now because it sometimes contains other faces
                               ;; if it contains any %, emacs will try to expand them, so replace them with %%
                               `(:propertize
                                 ,(replace-regexp-in-string "%" "%%"
                                                            (format-mode-line mode-line-process))
                                 face ,face-active-modes)
                               ;; `(:propertize ("" minor-mode-alist) face ,face-active-modes)
                               `(:propertize
                                 ,(replace-regexp-in-string "%" "%%"
                                                            (format-mode-line minor-mode-alist))
                                 face ,face-active-modes)
                               `(:propertize " " face ,face-active-modes)
                               (pwrln-left-separator face-active-modes face-dashes)
                               `(:propertize " " face ,face-dashes)
                               `(:propertize ("" global-mode-string) face ,face-dashes)
                               `(:propertize "%-" face ,face-dashes))))))
