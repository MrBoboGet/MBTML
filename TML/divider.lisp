(import "TML.lisp")

@tml
<divider width="100%" height?>
    <Text @bar width=width? height=height?/>
</divider>

(defmethod write ((this divider) view redraw)
    (setl text (times "―" (width view)))
    (set-atr :bar this "content" text)
    (set-updated this false)
    (write :stacker_ this view redraw)
)
