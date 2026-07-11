(import "TML.lisp")

@tml
<modal>
    <absolute @window visible=false 
    orientation=orientation? 
    row-offset=row-offset?
    col-offset=col-offset?
    relative=relative?
    width=width? 
    height=height?>
        <repl oneshot=true/>
    </absolute>
</modal>

(defmethod set-window ((mod modal) base-window new-window callable)
    (set-atr :window mod "visible" true)
    (set-child :window mod new-window)
    (push base-window new-window 
        _(progn
            (set-atr :window mod "visible" false)
            (callable)
        )
   )
)

(defmethod set-window ((mod modal) base-window new-window)
    (set-window mod base-window new-window _(progn null))
)
