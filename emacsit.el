;; emacsit.el -- Packages manager

(require 'subr-x)
(defvar emacsit::cask-path
  "Cask Path"
  )
(defcustom emacsit::auto-compile t
  "Auto compile packages"
  )
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
(setq emacsit::current-processes 0)
(setq emacsit::current-make-queue '())
(defun emacsit::clone(a)
  "Clone Package"
  (if (not (equal a " "))
      (progn
	(setq emacsit::dir (car (cdr (split-string a "@"))))
	(setq emacsit::url (car (split-string a "@")))
	(setq emacsit::current-processes (+ emacsit::current-processes 1))
        (set-process-sentinel (start-process-shell-command (format "Emacsit GET: %s" emacsit::url) (format "*Emacsit GET: %s*" emacsit::url) (format "git clone --depth=1 --recursive %s %s ||git clone --recursive %s %s" emacsit::url emacsit::dir emacsit::url emacsit::dir)) (lambda (process-name process-status) (setq emacsit::current-processes (- emacsit::current-processes 1)) )))

   
; (async-shell-command (format "git clone --depth=1 --recursive %s %s ||git clone --recursive %s %s && pushd %s && if [ -f Makefile ]; then make all; fi && popd" emacsit::url emacsit::dir emacsit::url emacsit::dir emacsit::dir)))
	
    a))
    
 
(defun emacsit::byte-compile(a)
  "Clone and Byte Compile Package"
  (if (not (equal a " "))
      (progn
	(setq emacsit::dir (car (cdr (split-string a "@"))))
	(setq emacsit::url (car (split-string a "@")))
	(if (file-exists-p (concat emacsit::dir "/Makefile"))
	    (start-process-shell-command (format "Emacsit Compile: %s" emacsit::dir) (format "*Emacsit Compile: %s*" emacsit::dir) (format "cd %s && make" emacsit::dir))
	  (start-process-shell-command (format "Emacsit Compile: %s" emacsit::dir) (format "Emacsit Compile: %s" emacsit::dir) (format "emacs -Q --batch --eval '(byte-recompile-directory \"%s\" 0)'" emacsit::dir))))))
(defun emacsit::update(a)
  "Update all packages"
  (if (not (equal a " "))
      (progn
	(setq emacsit::dir (car (cdr (split-string a "@"))))
	(setq emacsit::url (car (split-string a "@")))
	(start-process-shell-command (format "Emacsit Update: %s" emacsit::dir) (format "Emacsit Update: %s" emacsit::dir) (format "cd %s && git pull " emacsit::dir)))
    )
  )


(defun emacsit::update-all()
  "Update all packages"
  (interactive)
  (mapcar 'emacsit::update (mapcar 'emacsit::preprocess emacsit::packages))
  )

(defun emacsit::compile-all()
  ""
  (interactive)
  
  (mapcar (lambda (a) (add-to-list 'emacsit::current-make-queue a)) (mapcar 'emacsit::preprocess emacsit::packages))
  (emacsit::byte-compiling-queue))
(defun emacsit::byte-compiling-queue()
  "Byte Compile"
  (interactive)
  (if (not (equal emacsit::current-make-queue nil))
      (let ((current-name (car emacsit::current-make-queue)))
	(message current-name)
	(set-process-sentinel (emacsit::byte-compile current-name) (lambda (name state) (emacsit::byte-compiling-queue)))
	(setq emacsit::current-make-queue (cdr emacsit::current-make-queue)))
    ))
      
	

(defun emacsit::loadPackage(a)
  "Load Package"
  (setq a (car (cdr (split-string a "@"))))
  (add-to-list 'load-path a)
  (message "[Emacsit] %s" a)
  (mapcar (lambda (b) (add-to-list 'load-path b)) (split-string (string-trim (shell-command-to-string (format "ls -d %s/*/ 2>/dev/null" a))) "\n"))
  (add-to-list 'load-path a)
  )

;; for i in %s/*/; do find $i -name \"*.el\" -type f -print -quit;done | awk -F / '{NF--}1'|sed 's/ /\\//g'" "~/.emacs.d/packages"))


(defun emacsit::get()
  "Get the required packages from github"
  (interactive)
  (mapcar 'emacsit::clone (mapcar 'emacsit::getprocess emacsit::packages))
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

(defun emacsit::logclear()
  "Clear all the log buffers"
  (interactive)
 (mapcar (lambda (a) (if (string-match-p "\*Emacsit.*\*" a) (kill-buffer a)))  (mapcar 'buffer-name (buffer-list))))
(emacsit::initialize)
(provide 'emacsit)
