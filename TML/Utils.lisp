(import TML.TML)

(setl test "bruh bruh bruh")

(setl better-test "asdasd")

@tml
<suggestionContainer>
    <stacker @content reversed=true direction="right">
        <hider @hider  visible=false>
            @("> ")
        </hider>
        @children
    </stacker>
@text=""
@value=null
</suggestionContainer>

(defmethod set-focus ((this suggestionContainer) focused)
    (set-atr :hider this "visible" focused)
)
@tml
<suggester 
        suggestions=(list "awooga" "slugma" "xxxddd")
        value-func=(lambda (x) x)
        display-func=(lambda (x) @tml-emit <Text content=(str x) highlight-color="yellow" />)
        on-completion = (lambda (x) null)
        filter-value = (lambda (x) x)
        filter-func = (lambda (input suggestion) (&& (in input suggestion) (not (eq input suggestion))))
    >
    <absolute @top visible=false relative=true row-offset=0>
        <stacker border=true reversed=true @container>
        </stacker>
    </absolute>
    <repl @input/>
</suggester>

(defmethod get-text ((this suggestionContainer))
    :text this
)
(defmethod get-value ((this suggestionContainer))
    :value this
)
#<Text content=text highlight-color="yellow"/>
(defmethod get-suggestion-elements ((this suggester) elems)
    (map _(progn 
            (setl text _)
            @tml-emit
            <suggestionContainer @text=(:filter-value this text) @value=(progn _) >
                @{
                    (emit-child (:display-func this text))
                }
            </suggestionContainer>
        ) 
       elems)
)

(defmethod update-suggestions ((this suggester))
    (setl suggestions :suggestions this)
    (setl active-suggestions (list))
    (setl current-string (get-line :input this))
    (if (eq current-string "")
        false
     else if (eq (type suggestions) list_t)
        (setl active-suggestions (filter _(:filter-func this current-string (:filter-value this _)) :suggestions this))
     else 
        (setl active-suggestions (suggestions current-string))
    )
    (if (eq (len active-suggestions) 0)
        (set-atr :top this "visible" false)
    else
        (set-atr :top this "visible" true)
    )
    (set-children :container this (get-suggestion-elements this active-suggestions))
)

(defmethod set-suggestions ((this suggester) suggestions)
    (set :suggestions this suggestions)
    (update-suggestions this)
)


(defmethod handle-input ((this suggester) input)
    #(handle-base this input)
    (if (eq input "up") 
        (handle-input :container this (create-input "k"))
    else if (eq input "down")
        (handle-input :container this (create-input "j"))
    else if (ctrl input "k")
         (handle-input :container this (create-input "k"))
    else if (ctrl input "j")
         (handle-input :container this (create-input "j"))
    else if (|| (eq input "\t") (eq input "enter"))
        (setl selected (get-selected :container this))
        (if (&& (eq selected null) (> (child-count :container this) 0))
            (setl selected (first :container this))
        )
        (if (not (eq selected null))
            (set-line :input this (get-text selected))
            (update-suggestions this)
            (set-atr :top this "visible" false)
            (:on-completion this (get-value selected))
        )
        #else if (|| (eq input "\n") (eq input "enter"))
        #    (setl content "awooogers")
        #    @tml-emit
        #    <Text @newText content=content color="red"/>
        #    (add-child :testContainer this 
        #        newText
        #    )
    else
        (handle-input :input this input)
        (update-suggestions this)
    )
)

(defmethod get-value ((this suggester))
    (get-line :input this)
)
@tml
<placeholder>
    @child = (Text "placeholder")
</placeholder>

(defmethod set-focus ((this placeholder) value)
    (set-focus :child this value)
)
(defmethod get-cursor-info ((this placeholder))
    (get-cursor-info :child this)
)
(defmethod prefered-dims ((this placeholder) dimensions)
    (prefered-dims :child this dimensions)
)
(defmethod handle-input ((this placeholder) input)
    (handle-input :child this input)
)
(defmethod write ((this placeholder) view redraw)
    (write :child this view redraw)
)
(defmethod set-child ((this placeholder) child)
    (setl :child this child)
    (set-parent-info child :parent this)    
)

#suggestions=(list "awooga" "slugma" "xxxddd")
#value-func=(lambda (x) x)
#display-func=(lambda (x) @tml-emit <Text content=(str x) highlight-color="yellow" />)
#on-changed = (lambda (x) null)
#filter-func = (lambda (input suggestion) (&& (in input suggestion) (not (eq input suggestion))))

@tml
<dropdown 
        value=(progn null)
        alternatives=(list "test test" "test2")
        display-func? 
        value-func? 
        filter-value? 
        filter-func? 
        >
    <hider @result-container visible=false >
        <placeholder @result />
    </hider>

    <hider @input-container visible=true >
        <suggester @content
            suggestions=alternatives
            display-func=display-func?
            value-func=value-func?
            filter-value=filter-value?
            on-completion=(progn _(on-selected this _))
            filter-func=filter-func?
            />
    </hider>
    @{
        (if (not (eq :value this null))
            (on-selected this :value this)
        )
    }
</dropdown>

(defmethod handle-input ((this dropdown) input)
    (handle-input :content this input)
    (if (|| (eq input "esc") (eq input "\t") (eq input "enter"))
        (return false)
    )
    true
)

(defmethod on-selected ((this dropdown) value)
    (set :value this value)
    (set-child :result this (:display-func :content this (get-value this)))
    (set-atr :input-container this "visible" false)
    (set-atr :result-container this "visible" true)
)

(defmethod get-value ((this dropdown))
    :value this
)

(defmethod set-focus ((this dropdown) is-focused)
    (if is-focused  
        (set-atr :input-container this "visible" true)
        (set-atr :result-container this "visible" false)
    else
        (set-atr :input-container this "visible" false)
        (set-atr :result-container this "visible" true)
    )
)

@tml
<button on-enter=(lambda () (print "slugma")) border=false>
    <stacker @input  border=border highlight-color="green" >
        @children
    </stacker>
</button>

(defmethod handle-input ((this button) input)
    (if (eq input "enter")
        (:on-enter this)
        (return false)
    )
    true
)
(defmethod set-focus ((this button) focus)
    (if focus 
        (if :border this
            (set-atr :input this "border-color" "green")
         else
            (set-atr :input this "bg-color" "green")
        )
    else
        (if :border this
            (set-atr :input this "border-color" "white")
        else
            (set-atr :input this "bg-color" "white")
        )
    )
)

#(setl value @tml-emit <Text />)
#(display-window @tml-emit <dropdown value="asdasd" />)
#(print @tml-emit <Text />)
