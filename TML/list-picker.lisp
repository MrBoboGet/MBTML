#(import "TML.lisp")
#(import "modal.lisp")
#
#@tml 
#<listEntry path="" >
#    <Text @text content=(file-name path) color="#000000" highlight-bg-color="#00ff00" />
#    @{
#        (if (is-file path)
#            (set-atr :text this "bg-color" "#0000ff")
#         else 
#            (set-atr :text this "bg-color" "#ff0000")
#        )
#    }
#</listEntry>
#
#@tml
#<listPicker 
#    directory=(cwd) 
#    on-pick=(lambda (path) null)
#    >
#    <stacker border=true width=width? height=height? @content justification="end" overflow=false >
#
#    </stacker>
#    @{
#        (change-dir this directory)
#    }
#    <modal @mod row-offset=1 col-offset=1 width=-2 relative=true>
#
#    </modal>
#
#    @entries = (list)
#</listPicker>
#
#(defmethod apply-filter ((this filePicker) string)
#    (setl new-entries (filter _(in string _) :entries this ))
#    (set-children :content this (map _(progn @tml-emit <dirEntry path=(path-append :directory this _) />)      new-entries))
#    (set-selected-index :content this 0)
#)
#
#(defmethod handle-input ((this filePicker) input)
#    (if (eq input "esc")
#        (apply-filter this "")
#    )
#    (handle-base this input)
#    (if (eq input "enter")
#        (setl selected-file (get-selected :content this))
#        (if (not (eq selected-file null))
#            (setl path :path selected-file)
#            (if (is-directory path)
#                (change-dir this path)
#             else 
#                (:on-pick this path)
#                (return false)
#            )
#        )
#     else if (|| (eq input "u") (eq input "backspace"))
#            (change-dir this (parent-path :directory this))
#     else if (|| (eq input "u") (eq input "backspace"))
#            (change-dir this (parent-path :directory this))
#     else if (eq input "/")
#            (set-window :mod this this 
#                @tml-emit
#                <repl oneshot=true
#                    onenter=(progn _(apply-filter this _))
#                />
#            )
#     else if (ctrl input  "o")
#            (set-window :mod this this 
#                @tml-emit
#                <repl oneshot=true
#                    completion=(progn file-completion)
#                    onenter=(progn 
#                            _(if (is-file _)
#                                (:on-pick this _)
#                                (pop this)
#                            )
#                        )
#                />
#            )
#     else
#        (return (handle-input :content this input))
#    )
#    (return true)
#)
