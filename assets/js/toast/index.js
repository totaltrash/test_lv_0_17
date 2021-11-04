const Toast = {
  mounted() {
    if (this.el.dataset.id && this.el.dataset.timeout > 0) {
      setTimeout(() => this.pushEvent("clear_toast", {id: this.el.dataset.id}), this.el.dataset.timeout)
    }
  }
}

export default Toast;
