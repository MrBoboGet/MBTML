(import TML.TML)






@tml
<suggestionContainer>
    <stacker @content reversed=true direction="right">
        <hider @hider  visible=false>
            @("> ")
        </hider>
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
    awoooga
    <repl @input/></repl>

@suggestions=suggestions

</suggester>





(defmethod get-text ((this suggestionContainer))
    :text this
)

(defmethod get-suggestion-elements (elems)
    (map _(progn 
            (setl content (Text _ (make-dict ("highlight-color" "yellow")))) 
            (setl container (suggestionContainer))
            (setl :text container _)
            (add-child :content container content)
            container
        ) elems)
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
    else
        (handle-input :input this input)
        (update-suggestions this)
    )
)
