#!/usr/local/bin/sbcl --script

(defun command-line-file ()
  (or 
    #+SBCL (second *posix-argv*)
    #+LISPWORKS (second system:*line-arguments-list*)
    #+CMU (second extensions:*command-line-words*)
    #+CLISP (first *args*)
    nil))

(defun hexdump (pname)
  (let* ((infp (open pname :element-type '(unsigned-byte 8)))			;FILE* infp = fopen (pname "rb")
	 (leng (file-length infp))									;long  leng = file_length (infp)
	 (buffer (make-array leng :element-type '(unsigned-byte 8))))	;char* buffer = malloc (leng * sizeof (char))
    (read-sequence buffer infp :end leng)								;fread (buffer, leng, 1, infp)
    (close infp)														;fclose (infp)
    (do ((i 0)) ((>= i leng))											;for (i=0; i<leng; i++)
      (format t "~8,'0x  " i)											;printf ("08x  ", i)
      (do ((j 0 (1+ j))) ((or (>= j 16) (>= i leng)))					;for (j=0; j<16 && i<leng; j++)
	(format t "~2,'0x " (aref buffer i))						;printf ("02x " buffer [i])
	(incf i))													;i++
      (format t "~%"))))												;printf ("\n")
(hexdump (command-line-file))
