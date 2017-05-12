#lang racket/gui
(provide *game-window* *update-timer*)

(define *game-window* (new frame%
                           [width 1000]
                           [height 1000]
                           [label "Space invader"]))


;; draw object function
(define (draw-object object dc)
  (send object draw dc))

;; Render function
(define (render-function canvas dc)
  ;Draws out the map 
  (draw-object (send *canvas* get-map) dc)

  ;;Draw player  
  (for-each (lambda (player)
              (draw-object player dc))
            (send *canvas* get-list-of-player))

  ;;Draw enemies
  (for-each (lambda (enemie)
              (draw-object enemie dc))
            (send *canvas* get-list-of-enemies))

  ;;Draw projectiles
  (for-each (lambda (object)
              (send object update)
              (draw-object object dc))
            (send *canvas* get-list-of-projectiles))

  ;;Draw power-ups
  (for-each (lambda (object)
              (send object update)
              (draw-object object dc))
            (send *canvas* get-list-of-power-ups))

  (for-each (lambda (asteroid)
              (send asteroid update)
              (draw-object asteroid dc)
              (send *canvas* get-list-of-asteroids))))



  
;; canvas for the game
(define game-canvas%
  (class canvas%
    ;;--- comment out when fixed keyboard handler
    ;(init-field
     ;keyboard-handler)
    ;(define/override (on-char key-event)
     ; (keyboard-handler key-event))
    ;; -----
    (super-new)))
      

;;init game canvas
(define *canvas* (new game-canvas%
                      [parent *game-window*]
                      ;;--- comment out when fixed keyboard handler
                      ;[keyboard-handler keyboard-handler]
                      [paint-callback render-function]))

;;Return the canvas
(define (get-game-canvas)
  *canvas*)

;;Uppdate canvas
(define (refresh-canvas)
  (send *canvas* refresh))

;;Timer which says when the canvas should update
(define *update-timer* (new timer%
                            [notify-callback refresh-canvas]
                            [interval 16]
                            [just-once? #f]))
