document.getElementById('app-rpifo').innerHTML = (`
<div id="app">
    <v-app>
        <v-main>

            <v-toolbar class="mb-2" color="#BC1142" dark flat>
                <v-img class="lg-4 mr-4" max-width="32" src="src/img/logo.svg"></v-img>
                <v-toolbar-title>
                    Rpifo - {{ content.hote }}
                </v-toolbar-title>
            </v-toolbar>

            <v-container>
                <v-row gutters>
                    <v-col cols="12" md="6" lg="4">
                        <v-card>

                            <v-list>
                                <v-list-item v-for="item in content.info" :key="item.title">
                                    <v-list-item-content>
                                        <v-list-item-subtitle>{{ item.title }}</v-list-item-subtitle>
                                        <v-list-item-title>
                                            {{ item.response }}
                                        </v-list-item-title>
                                    </v-list-item-content>
                                </v-list-item>
                            </v-list>

                            <v-divider class="ma-6"></v-divider>

                            <v-list-item>
                                <v-list-item-content v-for="item in content.mem" :key="item.total">
                                    <v-list-item-title>
                                        <v-img src="src/img/memory.svg" max-width="20" class="mr-2 float-left">
                                        </v-img>Mémoire
                                        <br>
                                        Total (<b>{{ item.totalH }}</b>) Libre (<b>{{ item.freeH }}</b>)
                                    </v-list-item-title>

                                    <v-progress-linear height="25"
                                        :value="parseFloat(item.use/item.total*100).toFixed(2)" class="rounded-r-xl"
                                        color="#75A928">
                                        {{ item.useH + ' (' + parseFloat(item.use/item.total*100).toFixed(1) + '%)' }}
                                    </v-progress-linear>
                                </v-list-item-content>
                            </v-list-item>

                            <v-list-item>
                                <v-list-item-content v-for="item in content.swap" :key="item.total">
                                    <v-list-item-title>
                                        <v-img src="src/img/swap.svg" max-width="20" class="mr-2 float-left">
                                        </v-img>Swap
                                        <br>
                                        Total (<b>{{ item.totalH }}</b>) Libre (<b>{{ item.freeH }}</b>)
                                    </v-list-item-title>

                                    <v-progress-linear height="25"
                                        :value="parseFloat(item.use/item.total*100).toFixed(2)" class="rounded-r-xl"
                                        color="#75A928">
                                        {{ item.useH + ' (' + parseFloat(item.use/item.total*100).toFixed(1) + '%)' }}
                                    </v-progress-linear>
                                </v-list-item-content>
                            </v-list-item>

                            <v-list-item>
                                <v-list-item-content v-for="item in content.sd" :key="item.total">
                                    <v-list-item-title>
                                        <v-img src="src/img/sd.svg" max-width="20" class="mr-2 float-left">
                                        </v-img>Carte SD
                                        <br>
                                        Total (<b>{{ item.totalH }}</b>) Libre (<b>{{ item.freeH }}</b>)
                                    </v-list-item-title>

                                    <v-progress-linear height="25"
                                        :value="parseFloat(item.use/item.total*100).toFixed(2)" class="rounded-r-xl"
                                        color="#75A928">
                                        {{ item.useH + ' (' + parseFloat(item.use/item.total*100).toFixed(1) + '%)' }}
                                    </v-progress-linear>
                                </v-list-item-content>
                            </v-list-item>

                        </v-card>
                    </v-col>

                    <v-col cols="12" md="6" lg="4">
                        <v-card>

                            <v-card-title class="subtitle-1">
                                <v-img src="src/img/temp.svg" max-width="24" class="mr-2">
                                </v-img>
                                Température
                            </v-card-title>
                            <v-card-actions class="justify-center">
                                <v-progress-circular :rotate="-90" :size="150" :width="30" :value="content.temp"
                                    color="#75A928">
                                    <span class="text--primary">{{ content.temp }}°</span>
                                </v-progress-circular>
                            </v-card-actions>

                            <v-card-title class="subtitle-1">
                                <v-img src="src/img/cpu.svg" max-width="24" class="mr-2">
                                </v-img>
                                Charge CPU
                            </v-card-title>
                            <v-card-actions class="justify-center">
                                <v-progress-circular class="justify-center mx-2" :rotate="-90" :size="120" :width="30"
                                    v-for="item in content.cpu" :key="item.title" :value="item.title/5*100"
                                    color="#75A928">
                                    <span class="text--primary">{{ item.title }}</span>
                                </v-progress-circular>
                            </v-card-actions>

                        </v-card>
                    </v-col>

                </v-row>
            </v-container>

        </v-main>

        <v-footer>
            <v-col class="text-center text--disabled" cols="12">
                v{{ version }} ©{{ new Date().getFullYear() }} - <a class="text--secondary"
                    href="https://github.com/debmus/rpifo-web" target="_blank" rel="noopener noreferrer">Rpifo</a>
            </v-col>
        </v-footer>

    </v-app>
</div>
`);

var vm = new Vue({
    el: '#app',
    vuetify: new Vuetify(),
    data() {
        return {
            content: [],
            version: ''
        }
    },
    methods: {
        vresult: function () {
            axios
                .get('./src/result.json')
                .then(r => {
                    var rpi = this.content = r.data
                    document.title = 'Rpifo - ' + rpi.hote
                })
                .catch(e => {
                    console.log(e)
                })
        },
    },
    mounted() {
        fetch('./VERSION')
            .then(r => r.text())
            .then(t => {
                this.version = t
            },
            )
    },
})
vm.vresult()

this.interval = setInterval(() => {
    vm.vresult()
}, 300000);