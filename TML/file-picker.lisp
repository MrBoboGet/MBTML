(import "TML.lisp")


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
    on-pick=(lambda (path) null)
    >
    <stacker border=true @content>

    </stacker>
    @{
        (change-dir this directory)
    }
</filePicker>


(defmethod change-dir ((this filePicker) dir)
    (setl :directory this dir)
    (set-children :content this (map _(progn @tml-emit <dirEntry path=(path-append :directory this _) />) (list-dir :directory this))) 
)

(defmethod handle-input ((this filePicker) input)
    (handle-base this input)
    (if (eq input "enter")
        (setl selected-file (get-selected :content this))
        (if (not (eq selected-file null))
            (setl path :path selected-file)
            (print path)
            (if (is-directory path)
                (change-dir this path)
             else 
                (:on-pick this path)
                (return false)
            )
        )
     else if (eq input "u")
            (change-dir this (parent-path :directory this))
     else
        (return (handle-input :content this input))
    )
    (return true)
)
