;; extends

((jsx_element
  open_tag: _
  _+ @tag.inner
  close_tag: _) @tag.outer)

(jsx_element
  open_tag: (_ name: _ @tag.name))

(jsx_element
  close_tag: (_ name: _ @tag.name))

((jsx_self_closing_element
   name: _ @tag.name) @tag.outer)
