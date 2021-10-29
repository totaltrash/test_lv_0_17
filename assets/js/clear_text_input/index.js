// Used only by the ClearableTextInput component.
const ClearTextInput = {
  mounted() {
    this.el.addEventListener('click', (evt) => {
      this.el
        .closest('[data-role="clearable-text-input-container"]')
        .getElementsByTagName('input')[0]
        .value = ''
    })
  }
}

export default ClearTextInput;
