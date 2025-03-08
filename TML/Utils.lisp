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
<suggester suggestions=(list "awooga" "slugma" "xxxddd")>
    <absolute @top relative=true row-offset=0>
        <stacker border=true reversed=true @container>
            asdasdasd
        </stacker>
    </absolute>
    <stacker @testContainer>
        awoooga
    </stacker>
    <repl @input/>

@suggestions=suggestions

</suggester>

(defmethod get-text ((this suggestionContainer))
    :text this
)

(defmethod get-suggestion-elements (elems)
    (map _(progn 
            (setl text _)
            @tml-emit
            <suggestionContainer @text=text >
                <Text content=text highlight-color="yellow"/>
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
        (setl active-suggestions (filter _(&& (in current-string _) (not (eq current-string _))) suggestions))
     else 
        (setl active-suggestions (suggestions current-string))
    )
    (if (eq (len active-suggestions) 0)
        (set-atr :top this "visible" false)
    else
        (set-atr :top this "visible" true)
    )
    (set-children :container this (get-suggestion-elements active-suggestions))
)

(defmethod set-suggestions ((this suggester) suggestions)
    (set :suggestions this suggestions)
    (update-suggestions this)
)


(defmethod handle-input ((this suggester) input)
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
