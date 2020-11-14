new Vue({
    el: '#app',
    vuetify: new Vuetify(),
    data() {
        return {
            content: [],
            loading: true,
            errored: false,
            version: null

        }
    },
    mounted() {
        fetch('/VERSION')
            .then(r => r.text())
            .then(t => {
                this.version = t
            }),

            axios
                .get('etc/result.json')

                .then(r => {
                    var rpi = this.content = r.data
                    document.title = 'Rpifo - ' + rpi.hote
                })
                .catch(e => {
                    console.log(e)
                    this.errored = true
                })

    }
})
