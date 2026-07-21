(import "TML.lisp")


@tml 
<toastContainer>
    @{
        (set-base-atr this "justification" "center")
        (set-base-atr this "border" true)
        #(set-base-atr this "width" 10)
        #(set-base-atr this "height" 5)
        
        (set-children :stacker_ this children)
        #(print (times (+ (str (len children)) " ") 10))
    }
    <stacker direction="right" justification="center">
        @children
    </stacker>
</toastContainer>

@tml
<toaster width="10" height="10">
    @toasts = (list)
    @toastedCount = 0
    <absolute orientation="right">
        <stacker reverse=false @content>
            
        </stacker>
    </absolute>
</toaster>

(defmethod pop ((this toaster))
    (pop-front :toasts this)
    (set-children :content this :toasts this)
    (set :toastedCount this (+ :toastedCount this -1))
)

(defmethod write ((this toaster) view redraw)
    (while (< :toastedCount this (len :toasts this))
        (add-timer view 5000 _(pop this))
        (incr :toastedCount this 1)
    )
    (write :stacker_ this view redraw)
)

(defmethod toast ((this toaster) value )
    (push :toasts this @tml-emit <toastContainer> @{(emit-child value)}  </toastContainer>)
    (set-children :content this :toasts this)
)

(defmethod toast ((this toaster) (value string_t))
    #(push :toasts this @tml-emit <toastContainer> <Text content=value /> </toastContainer>)
    (push :toasts this @tml-emit <toastContainer> <Text content=value/>  </toastContainer>)
    (set-children :content this :toasts this)
)
