(import "TML.lisp")


@tml 
<toastContainer border-color? width? height? >
    @{
        (set-base-atr this "justification" "center")
        (set-base-atr this "border" true)
        (set-base-atr this "width" width)
        (set-base-atr this "height" height)
        (set-base-atr this "border-color" border-color)
        
        #(print (times (+ (str (len children)) " ") 10))
    }
    <stacker direction="right" justification="center">
        @children
    </stacker>
</toastContainer>

@tml
<toaster width? height? visible-time=5000 border-color="white">
    @toasts = (list)
    @toastedCount = 0
    <absolute orientation="right">
        <stacker reverse=false @content>
            
        </stacker>
    </absolute>
</toaster>

(defmethod pop ((this toaster))
    (if (eq (len :toasts this) 0)
        (return null)
    )
    (pop-front :toasts this)
    (set-children :content this :toasts this)
    (set :toastedCount this (+ :toastedCount this -1))
)

(defmethod write ((this toaster) view redraw)
    (while (< :toastedCount this (len :toasts this))
        (add-timer view :visible-time this _(pop this))
        (incr :toastedCount this 1)
    )
    (write :stacker_ this view redraw)
)

(defmethod toast ((this toaster) value )
    (push :toasts this @tml-emit <toastContainer border-color=(progn :border-color this)  > 
        @{(emit-child value)}  
        </toastContainer>)
    (set-children :content this :toasts this)
)

(defmethod toast ((this toaster) (value string_t))
    #(push :toasts this @tml-emit <toastContainer> <Text content=value /> </toastContainer>)
    (push :toasts this @tml-emit <toastContainer border-color=(progn :border-color this)> <Text multiline=true content=value/>  </toastContainer>)
    (set-children :content this :toasts this)
)
