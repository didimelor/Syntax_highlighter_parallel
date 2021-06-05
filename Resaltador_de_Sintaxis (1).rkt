#|
Parallel json syntax highlighter 
Diana Karen Melo Reyes A01023785
Miguel Medina A01023656
Emilio Sánchez
|#

#lang racket

(require racket/trace)


;Function to create the html file and to call loop with the JSON file converted to string.
(define (JsonFile theFile)
  ;(define htmlFile (open-output-file (string-append (substring theFile 0 (- (string-length  theFile) 5)) ".html") #:exists 'truncate))
  (define htmlFile (open-output-file (string-append (substring (path->string theFile) 0 (- (string-length (path->string theFile)) 5)) ".html") #:exists 'truncate))
  (display  "<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Document</title>
</head>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Yeseva+One&display=swap');
    @import url('https://fonts.googleapis.com/css2?family=Italiana&display=swap');
    #allContent{ 
        font-family:'Yeseva One', cursive;
        background-color: #121212;
        height: auto;
        margin: 0;
        padding: 20px;
        font-size: 20px;
    }
    #intro {color: white; font-family: 'Italiana', serif;}
    .key {color: #FF7597;}
    .value {color: #BB86FC;}
    .operator {color: #03DAC6;}
    .parenthesis {color: #3700B3;}
    .digit{color: #767D92;}
    .bool{color: blue;}

</style>
<body>
    <div id=\"allContent\">
        <div id=\"intro\">
            <h1>JSON Syntax Highlighter with Racket.</h1>
            <h3>Developed by Diana Melo, Miguel Medina and Emilio Sanchez &#128512;</h3>
        </div>" htmlFile)
  (check (file->string (string-append "Short_Yelp\\" (path->string theFile))) htmlFile))

;Function to write string into html
(define (writeStrFunction strToWrite htmlFile)
  (display strToWrite htmlFile)
  (close-output-port htmlFile))
  

;Function to identify tokens with regular expresions
(define(check ourStr htmlFile)
  (define operation #px"^(?:\\(|\\)|\\[|\\]|\\{|\\}|\\,)")
  (define enter #px"^\n|\r")
  (define spc #px"^ ")
  (define tab #px"^\t")
  (define num #px"^[\\d]+(\\.\\d+)?")
  (define key #px"^\"[^\"]+\":")
  (define value #px"^\"([^\"]+|[ ]?)\"")
  (define bool #px"^true|^false")
  (let loop([ourStr ourStr] [htmlFile htmlFile] [creatingStr " "])
    (if (not (non-empty-string? ourStr))
        (writeStrFunction creatingStr htmlFile)
        ;(display "termino")
        (cond
          ;Operations
          [(regexp-match operation ourStr)
           (define result (car(regexp-match operation ourStr)))
           (loop (substring ourStr (string-length result)) htmlFile
                 (string-append creatingStr "<span class=\"operator\">" result "</span>"))]
          ;New line
          [(regexp-match enter ourStr)
           (loop(substring ourStr 1) htmlFile (string-append creatingStr "<br>"))]
          ;Whitespace
          [(regexp-match spc ourStr)
           (loop(substring ourStr 1) htmlFile (string-append creatingStr "<span>&nbsp;</span>"))]
          ;Tab
          [(regexp-match tab ourStr)
           (loop(substring ourStr 1)
                htmlFile (string-append creatingStr "<span>&ensp;</span>"))]
          ;Ints or decimal numbers
          [(regexp-match num ourStr)
           (define result (car(regexp-match num ourStr)))
           (loop (substring ourStr (string-length result))
                 htmlFile (string-append creatingStr "<span class=\"digit\">" result "</span>"))]
          ;Key 
          [(regexp-match key ourStr)
           (define result (car(regexp-match key ourStr)))
           (loop (substring ourStr (string-length result))
                 htmlFile (string-append creatingStr "<span class=\"key\">"
                                         (substring result 0 (- (string-length result) 1)) "</span>" "<span class=\"operator\">:</span>"))]
          ;Value
          [(regexp-match value ourStr)
           (define result (car(regexp-match value ourStr)))
           (loop (substring ourStr (string-length result))
                 htmlFile (string-append creatingStr "<span class=\"value\">" result "</span>"))]
          ;bool
          [(regexp-match bool ourStr)
           (define result (car(regexp-match bool ourStr)))
           (loop (substring ourStr (string-length result))
                 htmlFile (string-append creatingStr "<span class=\"bool\">" result "</span>"))]
          ;When none works
          [else (display "no agarro nada, se estaba buscando! ")
                (display (substring ourStr 0 5))(close-output-port htmlFile)]))))

; un future por archivo;


; make futures given a list consisting of file paths.
(define (make-future lst-paths)
  ; return a new future that calls JsonFile "n" times, where n is the size of lst-paths.
  (future (lambda()
             ; loop through the list.
            (let loop
              ([mylst lst-paths])
              (cond
                ; as long as there are files in the list call JsonFile.
                [(not (empty? mylst))
                 (display "AQUI ESTA LA LISTA: ")
                 (display mylst)
                 (JsonFile (car mylst))
                 (loop (cdr mylst))])))))





#|(define (use-all-cores cores num fileLst)
  (define num-futures (floor(/ num cores)))
  (let loop
    ([i num-futures][lst fileLst][newLst empty])
    (cond
      [(empty? fileLst) ;2 4
       #t]
      [(zero? i)
       (make-future newLst)
       (loop num-futures lst '())]
      
      [(eq? (length lst) 1)
       (loop (sub1 i) '() (append newLst (list(car lst))))]
      [(> i 0)
       (display lst)
       (display (length lst))
       (loop (sub1 i)(cdr lst)(append newLst (list (car lst))))]
      [else (loop i (cdr lst) (append newLst (list (car lst))))])))|#


#|(define (use-all-cores cores how-many-files fileLst)
  (define range (floor(/ how-many-files cores)))
  (let loop
    ([i 1] [lst fileLst] [newLst empty] [range range])
    (cond
      [(empty? lst)
       #t]
      [(equal? i range)
       (append newLst (car lst))
       (make-futures newLst)
       (loop (add1 i) (cdr lst) empty (+ range range))]
      [else (add1)])))|#


; Function to determine how many files each future will take on.
; beta
(define (use-all-cores cores n fileLst)
  (define how-many-futures (floor(/ n cores))); 4/6 = 0
  (if (> cores n)
      (moreCores fileLst cores)
      (let loop
        ([i 1] [workFiles empty] [lst fileLst])
        (cond
          [(empty? lst)
           (assign-files workFiles)]
          [(> i how-many-futures)
           (assign-files workFiles)
           (loop 1 '() lst)]
          [else 
           (loop (add1 i) (append workFiles (list (car lst))) (cdr lst))]))))

(define(moreCores fileLst numCores)
  (let loop
    ([lst fileLst][i numCores][fLst '()])
    (cond
      [(empty? lst)
       fLst]
      [else
       (loop (cdr lst) (- i 1)(append fLst (list (make-future (list (car lst))))))])))

; alpha
(define (assign-files workFiles)
  (let loop
    ([lst workFiles] [f-lst '()])
    (cond
      [(empty? lst)
       f-lst]
      [else
       (display lst)
        (loop (cdr lst) (append f-lst (list (make-future (list (car lst))))))])))

(define (convertToHtml dir numCores)
  ;Generates list with file paths in the directory
  (define fileList(directory-list dir))
  (display fileList)
  ;Defines list of futures returned fron the use-all-cores function
  (define futures (use-all-cores numCores (length fileList) fileList))
  ;Activates futures
  (map touch futures))
  
  
; Main function to run the program
;parallel, sacar todos los archivos del directorio con chance (map (directory-list))
; hacer futures por cada core de la computadora y que cada future se encargue de hacer "n/cores = m" archivos.
 