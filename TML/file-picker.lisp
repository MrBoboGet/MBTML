(import "TML.lisp")
(import "modal.lisp")
(import "divider.lisp")
(import "Utils.lisp")

@tml 
<dirEntry path="" >
    <Text @text content=(file-name path) color="#000000" highlight-bg-color="#00ff00" />
    @{
        (if (is-file path)
            (set-atr :text this "bg-color" "#0000ff")
         else 
            (set-atr :text this "bg-color" "#ff0000")
        )
    }
</dirEntry>

@tml
<filePicker 
    directory=(cwd) 
    warn-replace=false
    width?
    height?
    on-pick=(lambda (path) null)
    >
    @{
        (set-base-atr this "border" true)
    }
    @(:directory this)
    <divider/>
    <stacker width=width? height=height? @content justification="end" overflow=false >

    </stacker>
    @{
        (change-dir this directory)
    }
    <modal @mod row-offset=0 col-offset=0 relative=true>

    </modal>

    <modal @warning orientation="center" relative=true >

    </modal>
    @entries = (list)
</filePicker>


(defmethod entry-< (lhs rhs)
    (if (&& (is-directory lhs) (not (is-directory rhs)))
        (return true)
     else if (&& (not (is-directory lhs)) (is-directory rhs))
        (return false)
     else
        (return (> lhs rhs))
    )
)

(defmethod sort-entries (entries dir)
    (sort (map _(+ dir "/" _) entries) entry-<)
)

(defmethod apply-filter ((this filePicker) string)
    (setl new-entries (filter _(in string _) :entries this ))
    (set-children :content this (map _(progn @tml-emit <dirEntry path=(path-append :directory this _) />)      new-entries))
    (set-selected-index :content this 0)
)

#(defmethod change-dir ((this filePicker) dir entries current-filter)
#    (setl :directory this dir)
#    (setl entries (list-dir :directory this))
#    (set-children :content this (map _(progn @tml-emit <dirEntry path=(path-append :directory this _) />) (sort-entries  entries :directory this)) )
#    (set-selected-index :content this 0)
#)

(defmethod change-dir ((this filePicker) dir)
    (setl :directory this dir)
    (setl entries (sort-entries (list-dir :directory this) :directory this))
    (set :entries this entries)
    (set-children :content this (map _(progn @tml-emit <dirEntry path=(path-append :directory this _) />) entries) )
    (set-selected-index :content this 0)
    (update this)
)

(defun file-completion (tokens)
    (setl dir (foldl tokens _(+ _1 "/" _2)))
    (if (eq dir "")
        (return (list-dir "."))
    )
    (if (is-directory dir)
        (return (map _(+ dir "/" _) (list-dir dir)))
     else if (|| (is-directory (parent-path dir)) (eq (parent-path dir) ""))
        (setl file (file-name dir))
        (setl parent-dir (parent-path dir))
        (setl entries (cond (is-directory parent-dir) (list-dir parent-dir) (list-dir ".")))
        (return (filter _(in file (file-name _))  (map _(+ (cond (is-directory parent-dir) (+ parent-dir "/") ""  )   _ )   entries) ))
    )
    (list)
)

@tml
<warningModal parent-elem=null path="" callback=(progn _(progn null))>
    <stacker border=true>
        <Text content=(+ path " already exists. Select anyway?") />
        <stacker @input justification="evenly" width="16" direction="right" passthrough="enter"  reversed=true >
            <button on-enter=callback >
                <Text content="yes" />
            </button>
            <button on-enter=(lambda () (pop parent-elem)) input-res=true>
                <Text content="no" />
            </button>
        </stacker>
    </stacker >
</warningModal>

(defmethod pick-file ((this filePicker) path)
   (if (&& :warn-replace this (exists path))
       (set-window :warning this this @tml-emit <warningModal path=path parent-elem=this callback=(progn _(:on-pick this path))> </warningModal> _(progn null) true)
        (return true)
      else
      (:on-pick this path)
      (return false)
   )
)
(defmethod handle-input ((this filePicker) input)
    (if (eq input "esc")
        (apply-filter this "")
    )
    (handle-base this input)
    (if (eq input "enter")
        (setl selected-file (get-selected :content this))
        (if (not (eq selected-file null))
            (setl path :path selected-file)
            (if (is-directory path)
                (change-dir this path)
             else 
                (return (pick-file this path))
            )
        )
     else if (|| (eq input "u") (eq input "backspace"))
            (change-dir this (parent-path :directory this))
     else if (eq input "/")
            (set-window :mod this this 
                @tml-emit
                <repl oneshot=true
                    onenter=(progn _(apply-filter this _))
                />
            )
     else if (eq input "n")
            (setl file-res "")
            (set-window :mod this this 
                @tml-emit
                <repl oneshot=true
                    onenter=(progn _(setl file-res (+ :directory this "/" _)))
                />
                _(progn (pick-file this file-res))
                true
            )
     else if (ctrl input  "o")
            (set-window :mod this this 
                @tml-emit
                <repl oneshot=true
                    completion=(progn file-completion)
                    onenter=(progn 
                            _(if (is-file  _)
                                (:on-pick this _)
                                (pop this)
                            )
                        )
                />
            )
     else
        (return (handle-input :content this input))
    )
    (return true)
)
