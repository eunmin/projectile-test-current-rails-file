(setq last-test-file-name nil)

(defun projectile-test-run (test-file-name)
  (interactive)
  (if test-file-name
      (progn (setq last-test-file-name test-file-name)
             (message (concat "Test:" test-file-name))
             (let ((default-directory (projectile-project-root)))
               (cond
                ((member (projectile-project-type) '(rails-test ruby-test)) 
                 (compilation-start (concat projectile-ruby-test-cmd " TEST=" test-file-name)))
                ((member (projectile-project-type) '(lein))
                 (compilation-start (concat projectile-lein-test-cmd " " test-file-name))))))
    (message "No test file.")))

(defun projectile-test-current-rails-file ()
  (interactive)
  (let* ((current-file-name (buffer-file-name (current-buffer)))
         (test-file-name (if (projectile-test-file-p current-file-name)
                             current-file-name
                             (if (projectile-find-matching-test current-file-name)
                                 (concat (projectile-project-root) (projectile-find-matching-test current-file-name))))))
    (projectile-test-run test-file-name)))

(defun projectile-test-last-test-file ()
  (interactive)
  (if last-test-file-name
      (projectile-test-run last-test-file-name)
    (message "No last test file.")))
