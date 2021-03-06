// http://blog.pthompson.org/phoenix-liveview-livecomponent-modal#scrolllock-javascript-hook_3
const ScrollLock = {
  mounted() {
    this.lockScroll()
  },
  destroyed() {
    this.unlockScroll()
  },
  lockScroll() {
    // From https://github.com/excid3/tailwindcss-stimulus-components/blob/master/src/modal.js
    // Add right padding to the body so the page doesn't shift when we disable scrolling
    const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth
    document.body.style.paddingRight = `${scrollbarWidth}px`
    // Save the scroll position
    this.scrollPosition = window.pageYOffset || document.body.scrollTop
    // Add classes to body to fix its position
    document.body.classList.add('fix-position')
    // Add negative top position in order for body to stay in place
    document.body.style.top = `-${this.scrollPosition}px`
  },
  unlockScroll() {
    // From https://github.com/excid3/tailwindcss-stimulus-components/blob/master/src/modal.js
    // Remove tweaks for scrollbar
    document.body.style.paddingRight = null
    // Remove classes from body to unfix position
    document.body.classList.remove('fix-position')
    // Restore the scroll position of the body before it got locked
    document.documentElement.scrollTop = this.scrollPosition
    // Remove the negative top inline style from body
    document.body.style.top = null
  }
}

export default ScrollLock;
