Emacsit is a new package manager for emacs. It's somewhat inspired from vim-plug. 


# Table of Contents

1.  [Introduction](#orge23976b)
2.  [Basic Usage](#org02baacd)
3.  [To Do](#orgc613731)


<a id="orge23976b"></a>

# Introduction

Emacsit is a package manager for people who would like to mess with the emacs packages. Emacsit allows you to easily clone the required packages from any git repository and immediately put it in your emacs load file. It works on very basic functions, and it doesn't want you to stop your work while packages are downloading or compiling. 


<a id="org02baacd"></a>

# Basic Usage

All you have to do for configuration is to load the emacsit directory to your load path or load emacsit.el directly, and add a variable emacsit::packages which is the list of packages you want to install. 
Add this to your `.emacs` file.

    (add-to-list load-path "path-to-emacsit.el directory")
    (require 'emacsit)
    (setq emacsit::packages '(
    			  abo-abo/avy
    			  creichert/ido-vertical-mode.el
    			  jwiegley/use-package
    			  sidhartharya10/emacs-ide-mode
    			  sidhartharya10/emacs-essentials
    			  sidhartharya10/emacs-easymotion
    			  sidhartharya10/emacsit
    			  magnars/expand-region.el	
    			  emacs-evil/evil
    			  https://code.orgmode.org/bzg/org-mode
    ))
    (setq emacsit::savedir "~/.emacs.d/packages")
    (emacsit::get)
    (emacsit::load)

The two functions **emacsit::get** and **emacsit::load** fetch the required packages and append then to your load path respectively.
These functions are also interactively callable, so, if you don't want to fetch the packages every time you start emacs, remove emacsit::get from your configuration.


<a id="orgc613731"></a>

# To Do

-   [ ] Compiling
-   [ ] Updating
-   [ ] Cleaning

