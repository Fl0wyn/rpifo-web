import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify';
import VueSvgGauge from 'vue-svg-gauge'

require('typeface-roboto')

Vue.config.productionTip = false
Vue.use(VueSvgGauge)

new Vue({
  vuetify,
  render: h => h(App)
}).$mount('#app')
