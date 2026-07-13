(import "TML.lisp")
(import "Utils.lisp")




@tml
<Highlighter>
    <stacker @content border-color="white">
        <placeholder @input>
            @children
        </placeholder>
    </stacker>
</Highlighter>

(defmethod set-focus ((this Highlighter) focus)
    (if focus
        (set-atr :content this "border" true)
     else 
        (set-atr :content this "border" false)
    )
    (set-focus :input this focus)

)
