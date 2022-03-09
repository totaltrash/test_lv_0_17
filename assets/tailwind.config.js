module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex',
    '../lib/i_fix_components/**/*.*ex'
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
