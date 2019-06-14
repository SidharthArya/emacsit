;; emacsit.el -- Packages manager
(require 'subr-x)
(defun emacsit::initialize()
  "Initialize emacsit"
  (interactive)
  (if (not (equal emacsit::cask-path nil))
      (setenv "PATH"
	      (concat
	       emacsit::cask-path "/bin:"
	       (getenv "PATH"))
  )
      
  ))
(defun emacsit::preprocess(a)
  "Preprocess list"
  (if (not (equal (member "" (split-string (format "%s" a) "/")) nil))
      (format "%s@%s" a (concat emacsit::savedir "/"  (car (last (butlast (split-string (format "%s" a) "/" )))) "/" (car (last (split-string (format "%s" a) "/")))))
  (format "%s%s@%s%s%s" "https://github.com/" a emacsit::savedir "/" a))
)


(defun emacsit::getprocess(a)
  "Preprocess Package String"
  (setq a (emacsit::preprocess a))
  (if (file-directory-p (car (cdr (split-string a "@"))))
      " "
     a))

(defun emacsit::clone(a)
  "Clone Package"
  (if (not (equal a " "))
      (progn
	(setq emacsit::dir (car (cdr (split-string a "@"))))
	(setq emacsit::url (car (split-string a "@")))
	(async-shell-command (format "git clone --depth=1 --recursive %s %s && pushd %s && if [ -f Makefile ]; then make all; fi && popd" emacsit::url emacsit::dir emacsit::dir)))
    )
  a
  )
(defun emacsit::clone-byte-compile(a)
  "Clone and Byte Compile Package"
  (if (not (equal a " "))
      (progn
	(setq emacsit::dir (car (cdr (split-string a "@"))))
	(setq emacsit::url (car (split-string a "@")))
	(if (not (file-exists-p (concat emacsit::dir "/Makefile")))
	    (byte-recompile-directory emacsit::dir 0))))
  a)

(defun emacsit::update(a)
  "Update all packages"
  (if (not (equal a " "))
      (progn
	(setq emacsit::dir (car (cdr (split-string a "@"))))
	(setq emacsit::url (car (split-string a "@")))
	(async-shell-command (format "cd %s && git pull " emacsit::dir)))
    )
  )


(defun emacsit::update-all()
  "Update all packages"
  (interactive)
  (mapcar 'emacsit::update (mapcar 'emacsit::preprocess emacsit::packages))
  )


(defun emacsit::byte-compile-all()
  "Byte Compile"
  (interactive)
    (mapcar 'emacsit::clone-byte-compile (mapcar 'emacsit::preprocess emacsit::packages)))


(defun emacsit::loadPackage(a)
  "Load Package"
  (setq a (car (cdr (split-string a "@"))))
  (add-to-list 'load-path a)
  (mapcar (lambda (b) (if (not (equal b "")) (add-to-list 'load-path b))) (split-string (string-trim (shell-command-to-string (format "find %s -regextype sed -regex '.*/lisp'" a)) "\n")))
    (mapcar (lambda (b) (if (not (equal b "")) (add-to-list 'load-path b))) (split-string (string-trim (shell-command-to-string (format "find %s -regextype sed -regex '.*/lib'" a)) "\n")))
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

(emacsit::initialize)
(provide 'emacsit)
