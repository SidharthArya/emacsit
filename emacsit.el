(setq emacsit::savedir "/home/arya/.emacs.d/packages")

(defun emacsit::preprocess(a)
  "Preprocess list"
  (if (not (equal (member "" (split-string (format "%s" a) "/")) nil))
      (format "%s@%s" a (concat emacsit::savedir "/"  (car (last (butlast (split-string (format "%s" a) "/" )))) "/" (car (last (split-string (format "%s" a) "/")))))
  (format "%s%s@%s%s%s" "https://github.com/" a emacsit::savedir "/" a))
)


(defun emacsit::getprocess(a)
  "Preprocess Something"
  (setq a (emacsit::preprocess a))
  (if (file-directory-p (car (cdr (split-string a "@"))))
      " "
     a))

(defun emacsit::clone(a)
  "Clone Something for me"
  (if (not (equal a " "))
      (progn
	(setq emacsit::dir (car (cdr (split-string a "@"))))
	(setq emacsit::url (car (split-string a "@")))
	(async-shell-command (format "git clone %s %s" emacsit::url emacsit::dir)))
    )
  a
  )
 
  
(defun emacsit::loadPackage(a)
  "Something for me"
  (setq a (car (cdr (split-string a "@"))))
  (if (file-directory-p (concat a "/lisp"))
      (add-to-list 'load-path (format "%s/lisp" a))
    (add-to-list 'load-path (format "%s" a)))
   )

(defun emacsit::get()
  "Get the required packages from github"
  (interactive)
  (mapcar 'emacsit::clone (mapcar 'emacsit::getprocess emacsit::packages))
  (emacsit::load)
  )
(defun emacsit::load()
  "Load all packages listed"
  (interactive)
  (mapcar 'emacsit::loadPackage (mapcar 'emacsit::preprocess emacsit::packages))
  )
   

(defun emacsit::clean()
  "Clean packages"
  
  )
(defun emacsit::dirclean()
  "Directory Clean"
  
)
(provide 'emacsit)
