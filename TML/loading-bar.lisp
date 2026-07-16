(import TML.TML)

@tml
<loadingBar width="100%" height?>
    @percent = 0
    <Text @bar width=width? height=height?/>
</loadingBar>

(defmethod write ((this loadingBar) view redraw)
    (setl text (times "█" (times (width view) (divide (times :percent this (width view)) 100))))
    (set-atr :bar this "content" text)
    (set-updated this false)
    (write :stacker_ this view redraw)
)

(defmethod set-percent ((this loadingBar) percent)
    null
)
