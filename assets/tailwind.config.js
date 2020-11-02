module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  theme: {},
  variants: {
    fontSize: ['responsive', 'hover', 'focus'],
  },
  plugins: []
};
