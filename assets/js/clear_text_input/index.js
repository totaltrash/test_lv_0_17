// Used only by the ClearableTextInput component.
const ClearTextInput = {
  mounted() {
    this.el.addEventListener('click', (evt) => {
      let input = this.el
        .closest('[data-role="clearable-text-input-container"]')
        .getElementsByTagName('input')[0]
      
      input.value = ''

      // dispatch an input event to trigger a phx-change on the containing form
      input.dispatchEvent(
        new Event("input", {bubbles: true})
      )
    })
  }
}

export default ClearTextInput;
