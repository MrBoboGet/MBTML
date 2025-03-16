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
</suggestionContainer>

(defmethod set-focus ((this suggestionContainer) focused)
    (set-atr :hider this "visible" focused)
)
@tml
<suggester 
        suggestions=(list "awooga" "slugma" "xxxddd")
        value-func=(lambda (x) x)
        display-func=(lambda (x) @tml-emit <Text content=(str x) highlight-color="yellow" />)
        on-changed = (lambda (x) null)
        filter-func = (lambda (input suggestion) (&& (in input suggestion) (not (eq input suggestion))))
    >
    @{
        null
    }
    <absolute @top relative=true row-offset=0>
        <stacker border=true reversed=true @container>
            asdasdasd
        </stacker>
    </absolute>
    <stacker @testContainer>
        awoooga
    </stacker>
    <repl @input/>
</suggester>

(defmethod get-text ((this suggestionContainer))
    :text this
)
#<Text content=text highlight-color="yellow"/>
(defmethod get-suggestion-elements ((this suggester) elems)
    (map _(progn 
            (setl text _)
            @tml-emit
            <suggestionContainer @text=text >
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
        (setl active-suggestions (filter _(:filter-func this current-string _) :suggestions this))
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
    else if (eq input "\t")
        (setl selected (get-selected :container this))
        (if (&& (eq selected null) (> (child-count :container this) 0))
            (setl selected (first :container this))
        )
        (if (not (eq selected null))
            (set-line :input this (get-text selected))
            (update-suggestions this)
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
        alternatives=(list "test test")
        display-func? value-func? on-changed? filter-func? >
    <hider @result-container visible=true >
        <placeholder @result />
    </hider>

    <hider @input-container visible=true >
        <suggester @content
            suggestions=alternatives
            display-func=display-func?
            value-func=value-func?
            on-changed=on-changed?
            filter-func=filter-func?
            />
    </hider>
    @{
        :alternatives this
    }
</dropdown>

(defmethod handle-input ((this dropdown) input)
    (handle-input :content this input)
    (if (|| (eq input "esc") (eq input "\t")) 
        (set-child :result this (:display-func :content this (get-value :content this)))
        (set-atr :input-container this "visible" false)
        (set-atr :result-container this "visible" true)
        (return false)
    )
    true
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


