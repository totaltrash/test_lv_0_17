const Flash = {
  mounted() {
    if (this.el.dataset.key && this.el.dataset.timeout > 0) {
      setTimeout(() => this.pushEvent("lv:clear-flash", {key: this.el.dataset.key}), this.el.dataset.timeout)
    }
  }
}

export default Flash;
