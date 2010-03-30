;;; fileutils.el --- unix utils as emacs functions

;; Copyright (C) 1997-2000 Free Software Foundation, Inc.

;; Author: Kevin A. Burton (burton@openprivacy.org)
;; Maintainer: Kevin A. Burton (burton@openprivacy.org)
;; Location: http://relativity.yi.org
;; Keywords: fileutils unix commands
;; Version: 1.0.0

;; This file is [not yet] part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 2 of the License, or any later version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
;; Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Commentary:

;; This package provides a set of emulated UNIX commands which are provided by
;; almost all POSIX compliant Operating Systems.  The real commands are not
;; executed themselves, this is all done through ELisp.  All of the commands
;; provided here are interactive.

;; Note that in order to correctly emulate these commands there is no command
;; prefix and since these have short names (md, ls, mv, etc) they could conflict
;; with future Emacs lisp functions.

;;; TODO:

;; cp
;; df
;; ln
;; rmdir
;; touch

(defun mkdir( &optional directory )
  "Make a directory."
  (interactive)
  (setq directory (read-file-name "New directory: " nil nil nil))
  (make-directory directory)
  (ls directory)
  (message "Made new directory: %s" directory))

(defun ls(&optional pattern)
  "ls... uses dired."
  (interactive)

  (if (null pattern)
      (setq pattern (read-file-name "Pattern: (same as UNIX 'ls'): " nil nil nil)))
  
  (dired pattern))

(defun mv()
  "Move a file."
  (interactive)

  (let(source dest newname)

    (setq source (read-file-name "Source file: "))

    (setq dest (read-file-name (format "Move %s to file or directory: " (file-name-nondirectory source))))

    ;;if source is a directory.. but dest is a file... this won't work
    (if (and (file-directory-p source)
             (not (file-directory-p dest)))
        (error (format "Can not move a directory into a file. %s, %s" source dest))
      (progn

        ;;if the destination is a directory... we need to build a new filename.
        (if (file-directory-p dest)
            (setq dest (concat (file-name-directory dest) (file-name-nondirectory source))))

        (if (file-exists-p dest)
            (error (format "File already exists: %s" dest))
          (progn 
        
            (rename-file source dest)
        
            (message "Moved %s to %s" source dest)))))))

(defun cp()
  "Copy a file."
  (interactive) 

  (let(source dest)

    (setq source (read-file-name "Source: " nil nil t (buffer-name)))

    (setq dest (read-file-name "Destination: " nil nil nil))

    ;;what to do if the file already exists
    
    (if (file-exists-p dest)
          (if (y-or-n-p (format "%s already exists.  Replace? " dest))
              (copy-file source dest t))
      (copy-file source dest)))
  (message ""))

(defun rm(file)
  "Delete a file."
  (interactive
   (list
    (read-file-name "File: " nil nil t)))

  (if (file-directory-p file)
      (delete-directory file)
    (delete-file file))

  (message "Deleted file: %s" file))

(provide 'fileutils)
